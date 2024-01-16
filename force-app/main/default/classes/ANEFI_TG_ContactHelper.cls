/**
*Class Name: ANEFI_TG_ContactHelper.
*Description: Clase Helper para el trigger ANEFI_TG_Contact.
*Created Date: 2/6/2023, 10:40 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 4/8/2023, 11:36 AM.
*/
public class ANEFI_TG_ContactHelper {
    
    public static Map<String, String> m = new Map<String, String>();
    
    public static MDT_ANEFI_Validations__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_Object_validation__c, ANEFI_Custom_message__c 
                                                  FROM MDT_ANEFI_Validations__mdt];
    
	/*//Create Opportunity of Account management
    public static void createOppAccMan(List<Contact> cts) { 
        System.debug('Todos los contactos: '+cts.size()+'---'+Json.serialize(cts));
        List<Opportunity> opptiesToCreate = new List<Opportunity>();
        Map<Opportunity, String> listOpps = new Map<Opportunity, String>();
        for(Contact con : cts) {
            Opportunity opt = new Opportunity();
            opt = buildOpportunityForContact(con);  
            System.debug('Se contruye: '+opt);           
            if(opt != Null)
            opptiesToCreate.add(opt);
        }
        try {
            System.debug('Tamaño del lote: '+opptiesToCreate.size() + '**' + JSON.serialize(opptiesToCreate));
            Insert opptiesToCreate;
            ANEFI_TG_ContactHandler.setDoNotRunTrigger();
        } catch(Exception ex){
            System.debug('Error en la creación de oportunidades: '+ex.getMessage());
        }
    }
    
    private static Opportunity buildOpportunityForContact(Contact con) { 
        System.debug('El contacto es: '+Json.serialize(con));
        //Validate if exist opportunty of Gestión de Cuentas in the Account
        Account searAcc = new Account();
        List<Opportunity> searchOpp = new List<Opportunity>();
        
        searAcc = [Select Id,Name From Account Where Id =: con.AccountId];
                                                                        
        System.debug('Se encontratón las cuentas: '+Json.serialize(searAcc));
        
        searchOpp = [Select Id,StageName,RecordType.DeveloperName,AccountId From Opportunity Where AccountId =: searAcc.Id and 
                     RecordType.DeveloperName = 'Gestion_de_Cuentas' and StageName != 'No Interesado' and StageName != 'Convertido'];
                                                                        
        System.debug('Se encontratón las oportunidades: '+searchOpp.size()+'---'+Json.serialize(searchOpp));                                                                
        
        Opportunity opp; 
        
        if(searchOpp.size() == 0) {
            opp = new Opportunity();
            opp.Name = con.FirstName + ' ' + con.LastName + '-';
            opp.AccountId = con.AccountId;
            opp.ContactId = con.Id;
            opp.StageName = 'No Gestionado';
            opp.CloseDate = System.today() + 30;
            opp.OwnerId = con.OwnerId;
            opp.Description = 'Nueva oportunidad de tipo: Gestión de Cuentas.';
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Gestion_de_Cuentas').getRecordTypeId(); 
        }     
        return opp;                                                                        
    }*/
    
    //Prevent duplicate Contact - Validation By Field: Número de identificación
    public static void validateDuplicates(List<Contact> cons) {
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //Validating if the Contact already exists by Identification
        set<String> idContacts = new set<String>();
        
        for(Contact ac : cons) {
        	idContacts.add(ac.Numero_de_identificacion__c);        
        }
        
        try {            
            List<Contact> contList = new List<Contact>([SELECT Id,Numero_de_identificacion__c,Owner.Name FROM Contact 
                                                        where Numero_de_identificacion__c In : idContacts]);
            
            map<String,Contact> contMap = new map<String,Contact>();
            for(Contact ac : contList) {
                contMap.put(ac.Numero_de_identificacion__c,ac);
            }
            
            for(Contact con : cons) {
                if(contMap.get(con.Numero_de_identificacion__c) != null) {
                	con.addError(m.get('X005'));   
                }
            }
        } catch(Exception ex) {
            System.debug('Error in Trigger Contact: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }   
        
    }
    
    public static void validateDuplicates(List<Contact> cons, Map<Id, Contact> oldContact) {
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //Validating if the Contact already exists by Identification
        set<String> idContacts = new set<String>();
        
        for(Contact ac : cons) {
        	idContacts.add(ac.Numero_de_identificacion__c);        
        }
        
        try {            
            List<Contact> contList = new List<Contact>([SELECT Id,Numero_de_identificacion__c,Owner.Name FROM Contact 
                                                        where Numero_de_identificacion__c In : idContacts]);
            
            map<String,Contact> contMap = new map<String,Contact>();
            for(Contact ac : contList) {
                contMap.put(ac.Numero_de_identificacion__c,ac);
            }
            
            for(Contact con : cons) {
                if(contMap.get(con.Numero_de_identificacion__c) != null && con.Numero_de_identificacion__c != oldContact.get(con.Id).Numero_de_identificacion__c) {
                	con.addError(m.get('X005'));   
                }
            }
        } catch(Exception ex) {
            System.debug('Error in Trigger Contact: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }   
        
    }
    
}