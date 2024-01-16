public class ANEFI_OpportunityHandler {
        
    public static void createFileContractCPOpportunity(List<Opportunity> oppClosed, List<Opportunity> oldOpp){
          System.debug('createFileContractCPOpportunity TRIGGER HANDLER' +oppClosed);

        if(ANEFI_OpportunityHelper.STAGE_NAME.equals(oppClosed.get(0).StageName) && oppClosed.get(0).StageName != oldOpp.get(0).StageName && oppClosed.get(0).Oportunidad_es_Aporte__c ){
            System.debug('ANEFI_OpportunityHelper call  helper' +oppClosed);
  
            ANEFI_OpportunityHelper.createContractFilesOpportunity(oppClosed.get(0).id,oppClosed.get(0).Producto_de_Interes__c);

        
        }

    }
    
    public static void createFilesOpportunity(List<Opportunity> oppClosed, List<Opportunity> oldOpp){
        System.debug('oppClosed' +oppClosed);
       
        List<Account> listAcc = [Select RecordtypeId from account where id =: oppClosed.get(0).accountId];
        //Id recordTypeId = oppClosed.get(0).Account.RecordtypeId;
        
        List<ContentDocumentLink> contentDocument = [select id ,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =:oppClosed.get(0).Id];
        List<ContentVersion> listContentVersion = new List<ContentVersion>();
        System.debug('contentDocument'+ contentDocument);
        if(contentDocument.size()>0){
             listContentVersion = [Select Title from ContentVersion where ContentDocumentId=:contentDocument[0].ContentDocumentId and title = 'Origen Lícito de Recursos'];
        }
        System.debug('listContentVersion'+ listContentVersion);

        if(ANEFI_OpportunityHelper.RECORDTYPE_ACCOUNT_BUSINESS.equals(Schema.SObjectType.Account.getRecordTypeInfosById().get(listAcc[0].recordTypeId).getDeveloperName())
           && ANEFI_OpportunityHelper.STAGE_NAME.equals(oppClosed.get(0).StageName)  && oppClosed.get(0).StageName != oldOpp.get(0).StageName){
            ANEFI_OpportunityHelper.createAccountBusinessFilesOpportunity(oppClosed.get(0).id, (listContentVersion.size()>0 ? true:false));            
        }else if(ANEFI_OpportunityHelper.RECORDTYPE_ACCOUNT_PERSON.equals(Schema.SObjectType.Account.getRecordTypeInfosById().get(listAcc[0].recordTypeId).getDeveloperName()) &&
                ANEFI_OpportunityHelper.STAGE_NAME.equals(oppClosed.get(0).StageName)    && oppClosed.get(0).StageName != oldOpp.get(0).StageName) { 
            ANEFI_OpportunityHelper.createAccountPersonFilesOpportunity(oppClosed.get(0).id,(listContentVersion.size()>0 ? true:false));
        }
    }
}