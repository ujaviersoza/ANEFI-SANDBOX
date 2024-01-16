/**
*Class Name: ANEFI_BAT_ValidateLeadSLA.
*Description: Clase Batch que evalua el SLA de los Prospectos 
              y los reasigna el registro al Jefe Inmediato por vencimiento de tiempo.
*Created Date: 5/5/2023, 9:39 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 13/7/2023, 11:46 AM.
*/
global class ANEFI_BAT_ValidateLeadSLA implements Database.Batchable<Sobject>, Database.Stateful {
	
    global static MDT_ANEFI_SLA__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_SLA_Object__c, ANEFI_SLA__c, ANEFI_Is_Active__c 
                                                  FROM MDT_ANEFI_SLA__mdt Where DeveloperName = 'Prospecto' and ANEFI_SLA_Object__c = 'Prospecto'];
    
    global static map<String, Lead> updateLeads = new map<String, Lead>();
    global static set<String> idUsers = new set<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id,Name,Status,ANEFI_LEAD_SLA__c,OwnerId,ANEFI_Manager_Id__c,ANEFI_Send_Notification__c,
                                         ANEFI_adviser__c,ANEFI_Date_assignment__c from Lead Where IsConverted = false 
                                         and ANEFI_Manager_Id__c != Null and ANEFI_LEAD_SLA__c >: listMDT[0].ANEFI_SLA__c]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope) {         
        for(Lead target : scope) {
            if(target.ANEFI_Manager_Id__c != Null) {
                target.ANEFI_adviser__c = target.OwnerId;
                target.OwnerId = target.ANEFI_Manager_Id__c;
                target.ANEFI_Date_assignment__c = System.today();
                target.ANEFI_Send_Notification__c = true;
                updateLeads.put(target.Id,target);
            }
        }
        
        if(updateLeads.size() > 0) {       
            
            Database.SaveResult[] srListOpps = Database.update(updateLeads.values(), false);
            
            // Iterate through each returned result
            for(Database.SaveResult sr : srListOpps) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully update Lead. Lead ID: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
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