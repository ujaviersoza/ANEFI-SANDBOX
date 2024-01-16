public class ANEFI_OpportunityHelper {
    //Persona_Juridica
    public ANEFI_OpportunityHelper() {}
    public static final String RECORDTYPE_ACCOUNT_BUSINESS = 'Persona_Juridica';
    public static final String RECORDTYPE_ACCOUNT_PERSON = 'Persona_Natural';    
    public static final String STAGE_NAME = 'Cerrada ganada';    
    
   
     @future(callout=true)
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
        createConditionAssignFileAccountPerson( oppId);
        if(!createOriginResourceFIle){
        	createOriginResourceFile(oppId);    
        }
        
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
    @Future(callout=true)
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
     @Future(callout=true)
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
    @Future(callout=true)
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
    
    @future(callout=true)
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
     @future(callout=true)
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
        if(ANEFI_OpportunityHelper.RECORDTYPE_ACCOUNT_BUSINESS.equals(opp.Account.RecordType.DeveloperName) && !Test.isRunningTest()){
                ANEFI_ServicesDTO.ConsultaPersonaJuridica consulta = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(opp.AccountId);
                if(consulta.personaJuridicaOut != null && consulta.personaJuridicaOut.direccionesElectronicas != null){
                for(integer i=0 ; i<consulta.personaJuridicaOut.direccionesElectronicas.size();i++){
                    if(consulta.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                        correoElectronicoCliente = consulta.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                    }
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