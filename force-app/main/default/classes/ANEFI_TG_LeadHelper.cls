/**
*Class Name: ANEFI_TG_LeadHelper.
*Description: Clase Helper para el trigger ANEFI_TG_Lead.
*Created Date: 7/6/2023, 16:21 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 4/08/2023, 11:05 AM.
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
            List<Lead> leadList = new List<Lead>([SELECT Id,Name,Status,Email,Numero_de_identificacion__c,Owner.Name,ConvertedAccountId,StatusPEPList__c FROM Lead 
                                                  Where Numero_de_identificacion__c In : idLeads]);
            
            map<String,Lead> leadMap = new map<String,Lead>();
            for(Lead l : leadList) {
                leadMap.put(l.Numero_de_identificacion__c,l);
            }
            
            for(Lead l : lds) {
                if(leadMap.get(l.Numero_de_identificacion__c) != null) {
                    l.addError(m.get('X001'));     
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
}