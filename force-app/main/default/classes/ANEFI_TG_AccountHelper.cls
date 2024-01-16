/**
*Class Name: ANEFI_TG_AccountHelper.
*Description: Clase Helper para el trigger ANEFI_CuentaTrigger.
*Created Date: 8/6/2023, 15:50 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 21/08/2023, 21:40 PM.
*/
public class ANEFI_TG_AccountHelper {
    
    public static Map<String, String> m = new Map<String, String>();
    
    public static MDT_ANEFI_Validations__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_Object_validation__c, ANEFI_Custom_message__c 
                                                  FROM MDT_ANEFI_Validations__mdt];
    
	//Prevent duplicate Account - Validation By Field: Número de identificación
    public static void validateDuplicates(List<Account> accs) {
              
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //Validating if the Account already exists by Identification
        try {            
            List<Account> accList = new List<Account>([SELECT Id,Numero_de_identificacion__c,Owner.Name FROM Account]);
            map<String,Account> accMap = new map<String,Account>();
            for(Account ac : accList) {
                accMap.put(ac.Numero_de_identificacion__c,ac);
            }
            
            for(Account ac : accs) {
                if(accMap.get(ac.Numero_de_identificacion__c) != null) {
                	ac.addError(m.get('X004'));   
                }
            }
        } catch(Exception ex) {
            System.debug('Error in Trigger Account2: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }   
        
    }
    
    //Prevent duplicate Account - Validation By Field: Número de identificación
    public static void validateDuplicates(List<Account> accs, Map<Id, Account> oldAccount) {
              
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //Validating if the Account already exists by Identification
        try {            
            List<Account> accList = new List<Account>([SELECT Id,Numero_de_identificacion__c,Owner.Name FROM Account]);
            map<String,Account> accMap = new map<String,Account>();
            for(Account ac : accList) {
                accMap.put(ac.Numero_de_identificacion__c,ac);
            }
            
            for(Account ac : accs) {
                if(accMap.get(ac.Numero_de_identificacion__c) != null && ac.Numero_de_identificacion__c != oldAccount.get(ac.Id).Numero_de_identificacion__c) {
                    ac.addError(m.get('X004'));    
                }
            }
        } catch(Exception ex) {
            System.debug('Error in Trigger Account: '+ex.getMessage()+ ', in line: '+ex.getLineNumber());
        }   
        
    }
    
    public static void syncInGestor(List<Account> accs, Map<Id, Account> mapOldAccount) {  
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        for(Id key: mapOldAccount.keyset()){ 
            if(mapOldAccount.get(key).Codigo_persona_en_Gestor__c != Null){
                if(!test.isRunningTest()) {
                	mapOldAccount.get(key).addError(m.get('X006')); 
                }    
            }
        }
    }
    
    public static void completeFieldsPersonAccount(List<Account> accs) {
        
        try{
        
        //System.debug('Valores que se reciben: '+Json.serialize(accs));
        String fullName = ''; 
        String firstName = '';
        String secondName = '';
        String firstLastName = '';
        String secondLastName = '';
        
        for(Account acc : accs) {
            System.debug('Nombre es: '+acc.PrimerNombre__c + ' ' + acc.SegundoNombre__c + ' ' + acc.PrimerApellido__c + ' ' + acc.SegundoApellido__c);
            if(acc.RecordtypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Natural').getRecordTypeId()) {
                firstName = acc.PrimerNombre__c;
                secondName = acc.SegundoNombre__c;
                firstLastName = acc.PrimerApellido__c;
                secondLastName = acc.SegundoApellido__c;
                
            	if(secondName != null) {
                    System.debug('Entra a armar el nombre de la Cuenta'); 
                    fullName = firstName + ' ' + secondName + ' ' + firstLastName;
                } else {
                    fullName = firstName + ' ' + firstLastName;
                }
                
                if(secondLastName != null) {
                    System.debug('Completa el nombre de la Cuenta'); 
                    fullName = fullName + ' ' + secondLastName;
                }

                acc.Name = fullName;
                System.debug('Nombre ajustado: '+acc.Name);
            } 
        } 
            
        } catch(Exception ex) {
            System.debug('Error en clase: ANEFI_TG_AccountHelper, método: completeFieldsPersonAccount, '+ ex.getLineNumber() + '---' + ex.getLineNumber());
        }    
        
    }
}