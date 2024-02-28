/**
*Class Name: ANEFI_TG_LeadHelper.
*Description: Clase Helper para el trigger ANEFI_TG_Lead.
*Created Date: 7/6/2023, 16:21 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 2/05/2023, 11:05 AM.
*/
public class ANEFI_TG_LeadHelper {
    
    public static Map<String, String> m = new Map<String, String>();
    
    public static MDT_ANEFI_Validations__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_Object_validation__c, ANEFI_Custom_message__c 
                                                  FROM MDT_ANEFI_Validations__mdt];
        
    //Prevent duplicate Leads - Validation By Field: Número de identificación
    public static void validateDuplicates(List<Lead> lds) {
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //Validating if the Lead already exists by Identification        
        set<String> idLeads = new set<String>();
        
        for(Lead l : lds) {
        	idLeads.add(l.Numero_de_identificacion__c);        
        }
        
        try {            
            List<Lead> leadList = new List<Lead>([SELECT Id,Name,Status,Email,Numero_de_identificacion__c,Owner.Name,ConvertedAccountId,StatusPEPList__c, ANEFI_Business_line__c, Producto_de_Interes__c FROM Lead 
                                                  Where Numero_de_identificacion__c In : idLeads]);
            
            List<Account> AccountList = new List<Account>([SELECT id, Name, Numero_de_identificacion__c,OwnerId  FROM Account 
                                                           Where Numero_de_identificacion__c In : idLeads]);          

            map<String,Lead> leadMap = new map<String,Lead>();
            for(Lead l : leadList) {
                leadMap.put(l.Numero_de_identificacion__c,l);
            }
            
            map<String,Account> accountMap = new map<String,Account>();
            for(Account accountItem : AccountList) {
                accountMap.put(accountItem.Numero_de_identificacion__c,accountItem);
            }
            
            List<Opportunity> opportunitiesToInsert = new List<Opportunity>();

            for(Lead l : lds) {
                if(leadMap.get(l.Numero_de_identificacion__c) != null) {
                    l.addError(m.get('X001'));     
                }else{
                    if(accountMap.get(l.Numero_de_identificacion__c) != null && l.LeadSource == 'Redes Sociales') {
						l.ANEFI_markedForDeletion__c = true;
                        Opportunity newOpportunity = new Opportunity(
                            Name = accountMap.get(l.Numero_de_identificacion__c).Name,
                            ANEFI_Business_line__c = l.ANEFI_Business_line__c,
                            LeadSource = 'Redes Sociales',
                            Producto_de_Interes__c = l.Producto_de_Interes__c,
                            StageName = 'Nueva oportunidad',
                            CloseDate = Date.today(),
                            AccountId = accountMap.get(l.Numero_de_identificacion__c).Id,
                            OwnerId = accountMap.get(l.Numero_de_identificacion__c).OwnerId,
                            RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Gestion_de_Cuentas').getRecordTypeId()
                        ); 
                        
                        opportunitiesToInsert.add(newOpportunity);
                        
                    }
                }                           
            }
            
            if (!opportunitiesToInsert.isEmpty()) {
                
                insert opportunitiesToInsert ;              
                for(Opportunity opp: opportunitiesToInsert){

                    CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                               FROM CustomNotificationType 
                                                               WHERE DeveloperName='Notificacion_de_nueva_oportunidad'];
                                        
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                                       
                    notification.setTitle('Nueva Oportunidad');
                    notification.setBody('Se ha creado una oportunidad desde formulario de redes sociales');                                      
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(opp.Id);
                    
                    Set<String> addressee = new Set<String>();
                    addressee.add(opp.OwnerId);
                    notification.send(addressee);          
                }
            }
                        
            
        } catch(Exception ex) {
            System.debug('Error in Trigger Lead: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }
        
    }
    
    
	//Prevent duplicate Leads - Validation By Field: Número de identificación
    public static void validateDuplicates(List<Lead> lds, Map<Id, Lead> oldLead) {
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }      
        
        //Validating if the Lead already exists by Identification        
        set<String> idLeads = new set<String>();
        
        for(Lead l : lds) {
        	idLeads.add(l.Numero_de_identificacion__c);        
        }
        
        try {            
            List<Lead> leadList = new List<Lead>([SELECT Id,Name,Status,Email,Numero_de_identificacion__c,Owner.Name,ConvertedAccountId,StatusPEPList__c FROM Lead 
                                                  Where Numero_de_identificacion__c In : idLeads]);
            
            map<String,Lead> leadMap = new map<String,Lead>();
            for(Lead l : leadList) {
                leadMap.put(l.Numero_de_identificacion__c,l);
            }
            
            for(Lead l : lds) {
                if(leadMap.get(l.Numero_de_identificacion__c) != null && l.Numero_de_identificacion__c != oldLead.get(l.Id).Numero_de_identificacion__c) {                    
                    l.addError(m.get('X001'));                     
                } 
                System.debug('sasa' + leadMap.get(l.Numero_de_identificacion__c).status );
                if(leadMap.get(l.Numero_de_identificacion__c).status == 'Convertido' && leadMap.get(l.Numero_de_identificacion__c ).StatusPEPList__c == '' ) {
                    system.debug('errorrr');
                    l.addError(m.get('X001'));     
                } 
            }
        } catch(Exception ex) {
            System.debug('Error in Trigger Lead: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }
        
    }
    
    public static void deleteMarked(List<Lead> lds){

        list<ID> leadsToRollBack = new list<ID>();
                
        for(Lead item : lds){
            if(item.ANEFI_markedForDeletion__c){                
                leadsToRollBack.add(item.Id);
            }
            
        }
        
        if (!leadsToRollBack.isEmpty()) {           
           System.enqueueJob(new LeadDeletionQueueable(leadsToRollBack), 1);
        }
        
        
        
    }


}