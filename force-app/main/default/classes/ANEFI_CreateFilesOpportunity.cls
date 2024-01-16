public with sharing class ANEFI_CreateFilesOpportunity {
    
    public static final String RECORDTYPE_ACCOUNT_BUSINESS = 'Persona_Juridica';
    public static final String RECORDTYPE_ACCOUNT_PERSON = 'Persona_Natural';    
    public static final String STAGE_NAME = 'Cerrada ganada';
    @InvocableMethod()
    public static List<String> createFiles(List<String> idOpportunity){
        List<String> respuesta = new List<String>();
        Id sObjectId = Id.valueOf(idOpportunity.get(0));
        String objectType = String.valueOf(sObjectId.getSObjectType());
        try{
            if(objectType == 'Account'){
                system.debug('sObjectId ->' + sObjectId);
                List< ANEFI_Rescates_Programados__c > lstRescates = new List< ANEFI_Rescates_Programados__c >();
                lstRescates = [Select id, AccountId__c  from ANEFI_Rescates_Programados__c where  AccountId__c  =: sObjectId order by createddate desc ];
                system.debug('lstRescates ->' + lstRescates);
                if(lstRescates.size()>0 && lstRescates.get(0).AccountId__c != null){
                    String correo = '';
                    
                    Account acc = [Select id,RecordType.DeveloperName,name,Correo_electronico__c  from Account where id =: lstRescates.get(0).AccountId__c];
                    correo = acc.Correo_electronico__c ;
                    if(RECORDTYPE_ACCOUNT_BUSINESS.equals(acc.RecordType.DeveloperName)){
                        ANEFI_ServicesDTO.ConsultaPersonaJuridica consulta = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(lstRescates.get(0).Anefi_CuentaRescate__c);
                        
                        for(integer i=0 ; i<consulta.personaJuridicaOut.direccionesElectronicas.size();i++){
                            if(consulta.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                                correo = consulta.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                            }
                        }
                    }
                    ANEFI_CreaRescate.creaPdfRescate(lstRescates.get(0).Id,acc.Id,correo,acc.name);
                }        	
            }else{
                List<Opportunity> opp = [Select id,Oportunidad_es_Aporte__c,Producto_de_Interes__c,accountId from Opportunity where id =: idOpportunity];
                List<Account> listAcc = [Select RecordtypeId from account where id =: opp.get(0).accountId];
                List<ContentDocumentLink> contentDocument = [select id ,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =:opp.get(0).Id];
                List<ContentVersion> listContentVersion = new List<ContentVersion>();
                System.debug('contentDocument'+ contentDocument);
                delete contentDocument;
                if(opp.get(0).Oportunidad_es_Aporte__c ){
                    createContractFilesOpportunity(opp.get(0).id,opp.get(0).Producto_de_Interes__c);
                    
                }
                if( RECORDTYPE_ACCOUNT_BUSINESS.equals(Schema.SObjectType.Account.getRecordTypeInfosById().get(listAcc[0].recordTypeId).getDeveloperName())
                  ){
                      System.debug('Persona juridica');
                      createAccountBusinessFilesOpportunity(opp.get(0).id, false);            
                  }else if( RECORDTYPE_ACCOUNT_PERSON.equals(Schema.SObjectType.Account.getRecordTypeInfosById().get(listAcc[0].recordTypeId).getDeveloperName())
                          ) { 
                              createAccountPersonFilesOpportunity(opp.get(0).id,false);
                          }
            }
            
        }catch(Exception ex){
            
        }
        
        return respuesta;
    }
    
    
    
    
    
    public static void createContractFilesOpportunity(String oppId,String typeProduct){
        
        if(typeProduct.equals('F001')){
            createFileContractCPOpportunity( oppId);
            
        }else if(typeProduct.equals('F002')){
            createFileContractFS2Opportunity(oppId);
        }else if(typeProduct.equals('F003')){
            createFileContractFondoInversionOptimoOpp(oppId);
            
        }else if(typeProduct.equals('F004')){
            createFileContractFM3Opportunity(oppId);
            
        }else if(typeProduct.equals('F005')){
            createFileContractFM5Opportunity(oppId);
            
        }
        
    }
    
    public static void createAccountPersonFilesOpportunity(String oppId,boolean createOriginResourceFIle){
        
        if(!createOriginResourceFIle){
            createOriginResourceFile(oppId);    
        }
        createConditionAssignFileAccountPerson( oppId);
        createStatementFatcaPersonAccount(oppId);
        //createFileContractFM3Opportunity(oppId);
        
    }
    
    public static void createAccountBusinessFilesOpportunity(String oppId,boolean createOriginResourceFIle ){
        createConditionAssignFileAccountBusiness( oppId);
        if(!createOriginResourceFIle){
            createOriginResourceFile(oppId);
            
        }
        createStatementFatcaAccountBusiness(oppId);
        createSituationAccountBusiness(oppId);
    }
    
    private static void createSituationAccountBusiness(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIEstadoSituacionJuridico';
        titulo = 'Estado de Situación Jurídico';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    
    private static void createStatementFatcaAccountBusiness(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIDeclaracionFATCAPJ';
        titulo = 'Declaración FATCA Persona Jurídica';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    
    private static void createConditionAssignFileAccountBusiness(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFICondicionesFirmas';
        titulo = 'Condiciones de Firmas';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }    
    
    
    public static void createConditionAssignFileAccountPerson(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFICondicionesFirmasPNatural';
        titulo = 'Condiciones de Firmas';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    
    private static void createStatementFatcaPersonAccount(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIDeclaracionFATCAPNat';
        titulo = 'Declaración FATCA Persona Natural';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    private static void createFileContractCPOpportunity(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFCPCP1';
        titulo = 'Contrato de Incorporación CP-1';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    private static void createFileContractFM3Opportunity(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFMFM3';
        titulo = 'Contrato de Incorporación Fondo Meta FM-3';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    
    public static void createFileContractFASOpportunity(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFMFM3';
        titulo = 'Contrato de Incorporación Fondo Meta FM-3';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    private static void createFileContractFM5Opportunity(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFS5';
        titulo = 'Contrato de Incorporación Fondo Administrado Semilla FS-5';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    private static void createFileContractFS2Opportunity(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFSFS2';
        titulo = 'Contrato de Incorporación Fondo Seguro FS-2';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    private static void createFileContractFondoInversionOptimoOpp(String oppId){
        System.debug('entro helper opp');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIContratoIncorpFIO';
        titulo = 'Contrato de Incorporación Fondo de Inversión Óptimo';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        if(!Test.isRunningTest() ) insert contentDocResumen;
    }
    public static void createLicitudFondosFile(List<Opportunity> newOpp){
        
        
        
        createOriginResourceFile(newOpp[0].id);
        
        
    }
    @future(callout=true)
    private static void createOriginResourceFile(String  oppId){
        Boolean sendEmail = false; 
        Opportunity opp = [Select id,Producto_de_Interes__c,Amount,CreatedDate,Numero_oportunidad__c,Account.Correo_electronico__c,
                           Account.Owner.Email,AccountId,Account.RecordType.DeveloperName,Account.Name from Opportunity where id=:oppId]; 
        String correoElectronicoCliente; 
        if( RECORDTYPE_ACCOUNT_BUSINESS.equals(opp.Account.RecordType.DeveloperName) && !Test.isRunningTest()){
            ANEFI_ServicesDTO.ConsultaPersonaJuridica consulta = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(opp.AccountId);
            
            for(integer i=0 ; i<consulta.personaJuridicaOut.direccionesElectronicas.size();i++){
                if(consulta.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                    correoElectronicoCliente = consulta.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                }
            }
        }else{
            correoElectronicoCliente = opp.Account.Correo_electronico__c;
        }
        
        String monto = String.valueOf(opp.Amount);
        System.debug('Se genera file y se enviara correo.');
        string pagina,titulo,typeDoc;
        pagina = 'ANEFIFormularioOLR';
        titulo = 'Origen Lícito de Recursos';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+oppId);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = oppId,ShareType = 'I');
        insert contentDocResumen;
        sendEmail = (correoElectronicoCliente != null) ? true :false;
        if(sendEmail){
            
            EmailTemplate et = [SELECT Id,Subject, Body,DeveloperName,HtmlValue FROM EmailTemplate where developername = 'PlantillaNuevoAporte'];
            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace('{!Opportunity.Producto_de_Interes__c}',opp.Producto_de_Interes__c).
                replace('{!Opportunity.Amount}',monto).
                replace('{!Opportunity.CreatedDate}',String.valueOf(opp.CreatedDate)).
                replace('{!Opportunity.Numero_oportunidad__c}',opp.Numero_oportunidad__c).
                replace('{!Opportunity.Account}',opp.Account.Name).
                replace(']]>','');
            Messaging.Emailfileattachment efat = new Messaging.Emailfileattachment();
            efat.setFileName(titulo+'.pdf');
            Blob b = blob.valueof('error');
            efat.setBody( (Test.isRunningTest()) ? b :  ref.getContentAsPDF());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {'alexis2tj@hotmail.com'}; 
            //String[] ccAddresses = new String[] {'axellanda93@gmail.com'};
            String correo = UserInfo.getUserEmail();
            String[] toAddresses = new String[] {correo,correoElectronicoCliente}; 
                String[] ccAddresses = new String[] {Label.Correo_Administrador};
                    mail.setToAddresses(toAddresses);	
            mail.setCcAddresses(ccAddresses);
            mail.setSubject(et.subject);
            mail.setHtmlBody(htmlBody);            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efat });//Set File Attachment
            
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                
            }
            
            
        }
    }  
    
}