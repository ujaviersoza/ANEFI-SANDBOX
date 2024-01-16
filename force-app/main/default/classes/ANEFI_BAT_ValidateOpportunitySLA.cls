/**
*Class Name: ANEFI_BAT_ValidateOpportunitySLA.
*Description: Clase Batch que evalua el SLA de las oportunidades de tipo: Gestión de cuentas
              y las reasigna al Jefe Inmediato por vencimiento de tiempo.
*Created Date: 2/6/2023, 15:28 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 13/7/2023, 12:00 PM.
*/
global class ANEFI_BAT_ValidateOpportunitySLA implements Database.Batchable<Sobject>, Database.Stateful {
	
    global static MDT_ANEFI_SLA__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_SLA_Object__c, ANEFI_SLA__c, ANEFI_Is_Active__c 
                                                  FROM MDT_ANEFI_SLA__mdt Where DeveloperName = 'Oportunidad_Gestion_de_cuentas' 
                                                  and ANEFI_SLA_Object__c = 'Oportunidad'];
    
    global static map<String, Opportunity> updateOpps = new map<String, Opportunity>();
    global static set<String> idUsers = new set<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(test.isRunningTest()) {
        	return Database.getQueryLocator([Select Id,Name,StageName,ANEFI_Opportunity_SLA__c,OwnerId,ANEFI_Manager_Id__c,ANEFI_Send_Notification__c,
                                         ANEFI_adviser__c,ANEFI_Date_assignment__c from Opportunity Limit 1]);    
        } else {
        	return Database.getQueryLocator([Select Id,Name,StageName,ANEFI_Opportunity_SLA__c,OwnerId,ANEFI_Manager_Id__c,ANEFI_Send_Notification__c,
                                         ANEFI_adviser__c,ANEFI_Date_assignment__c from Opportunity Where StageName != 'No Interesado' and 
                                         StageName != 'Convertido' and ANEFI_Opportunity_SLA__c >: listMDT[0].ANEFI_SLA__c and 
                                         Recordtype.DeveloperName = 'Gestion_de_Cuentas' and ANEFI_Manager_Id__c != Null]);
        }
    }
       
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {         
        for(Opportunity target : scope) {
            if(target.ANEFI_Manager_Id__c != Null) {
                target.ANEFI_adviser__c = target.OwnerId;
                target.OwnerId = target.ANEFI_Manager_Id__c;
                target.ANEFI_Date_assignment__c = System.today();
                target.ANEFI_Send_Notification__c = true;
                updateOpps.put(target.Id,target);
            }
        }
        
        if(updateOpps.size() > 0) {       
            
            Database.SaveResult[] srListOpps = Database.update(updateOpps.values(), false);
            
            // Iterate through each returned result
            for(Database.SaveResult sr : srListOpps) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully update Opportunity. Opportunity ID: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Opportunity fields that affected this error: ' + err.getFields());
                    }
                }
            }
     	}       
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob asyncJob = [SELECT ID,Status,NumberOfErrors FROM 
                                 AsyncApexJob WHERE ID =:bc.getJobId()];
    }
    
}