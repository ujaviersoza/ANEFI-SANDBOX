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
    
    public static id recordTypeIdPersonaJuridica = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Juridica').getRecordTypeId();
    
    public static id recordTypeIdPersonaNatural = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Natural').getRecordTypeId();
    
    
    
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
    
    public static void markUpdatedOrNot(List<Account> accs, Map<Id, Account> mapOldAccount){
        
        for (Account acc : accs) {           

            Account oldAccount = mapOldAccount.get(acc.Id);     
            
            //Check persona Natural            
            if(acc.RecordTypeId == recordTypeIdPersonaNatural){
                
                  //Check if any integration field was changed before making call to integration
                if(oldAccount.PrimerNombre__c != acc.PrimerNombre__c ||
                   oldAccount.SegundoNombre__c != acc.SegundoNombre__c ||
                   oldAccount.PrimerApellido__c != acc.PrimerApellido__c ||
                   oldAccount.SegundoApellido__c != acc.SegundoApellido__c ||
                   oldAccount.Name != acc.Name ||
                   oldAccount.Tipo_de_identificacion__c != acc.Tipo_de_identificacion__c ||
                   oldAccount.Numero_de_identificacion__c != acc.Numero_de_identificacion__c ||
                   oldAccount.Correo_electronico__c != acc.Correo_electronico__c ||
                   oldAccount.Codigo_pais_nacionalidad__c != acc.Codigo_pais_nacionalidad__c ||
                   oldAccount.Paga_impuestos__c != acc.Paga_impuestos__c ||
                   oldAccount.Telefono_celular__c != acc.Telefono_celular__c ||
                   oldAccount.Codigo_pais_de_nacimiento__c != acc.Codigo_pais_de_nacimiento__c ||
                   oldAccount.Codigo_provincia_de_nacimiento__c != acc.Codigo_provincia_de_nacimiento__c ||
                   oldAccount.Secuencia_canton_de_nacimiento__c != acc.Secuencia_canton_de_nacimiento__c ||
                   oldAccount.Codigo_canton_nacimiento__c != acc.Codigo_canton_nacimiento__c ||
                   oldAccount.Fecha_de_nacimiento__c != acc.Fecha_de_nacimiento__c ||
                   oldAccount.Estado_civil__c != acc.Estado_civil__c ||
                   oldAccount.Genero__c != acc.Genero__c ||
                   oldAccount.Codigo_pais_direccion_domicilio__c != acc.Codigo_pais_direccion_domicilio__c ||
                   oldAccount.Codigo_canton_direccion_domicilio__c != acc.Codigo_canton_direccion_domicilio__c ||
                   oldAccount.Secuencia_canton_direccion_domicilio__c != acc.Secuencia_canton_direccion_domicilio__c ||
                   oldAccount.Codigo_provincia_direccion_domicilio__c != acc.Codigo_provincia_direccion_domicilio__c ||
                   oldAccount.Calle_principal_direccion_domicilio__c != acc.Calle_principal_direccion_domicilio__c ||
                   oldAccount.Referencia_direccion_domicilio__c != acc.Referencia_direccion_domicilio__c ||
                   oldAccount.Telefono_domicilio__c != acc.Telefono_domicilio__c ||
                   oldAccount.Es_direccion_fiscal_direccion_domicilio__c != acc.Es_direccion_fiscal_direccion_domicilio__c ||
                   oldAccount.Tipo_de_empleo__c != acc.Tipo_de_empleo__c ||
                   oldAccount.Codigo_actividad_economica__c != acc.Codigo_actividad_economica__c ||
                   oldAccount.Politicamente_expuesto__c != acc.Politicamente_expuesto__c ||
                   oldAccount.Phone != acc.Phone ||
                   oldAccount.Total_activos__c != acc.Total_activos__c ||
                   oldAccount.Total_pasivos__c != acc.Total_pasivos__c ||
                   oldAccount.Total_patrimonio__c != acc.Total_patrimonio__c ||
                   oldAccount.Total_gastos__c != acc.Total_gastos__c ||
                   oldAccount.Entidad_financiera__c != acc.Entidad_financiera__c ||
                   oldAccount.Numero_de_cuenta_bancaria__c != acc.Numero_de_cuenta_bancaria__c ||
                   oldAccount.Tipo_de_cuenta_bancaria__c != acc.Tipo_de_cuenta_bancaria__c ||
                   oldAccount.Ingresos_mensuales__c != acc.Ingresos_mensuales__c ||
                   
                   oldAccount.Canton_direccion_domicilio__c != acc.Canton_direccion_domicilio__c ||
                   oldAccount.Canton_de_nacimiento__c != acc.Canton_de_nacimiento__c ||
                   oldAccount.Entidad_Financiera__c != acc.Entidad_Financiera__c ||
                   oldAccount.Pais_direccion_domicilio__c != acc.Pais_direccion_domicilio__c ||
                   oldAccount.Nacionalidad__c != acc.Nacionalidad__c ||                  
                   oldAccount.Actividad_Economica__c != acc.Actividad_Economica__c ||                                 
                   oldAccount.Calle_principal_direccion_trabajo__c != acc.Calle_principal_direccion_trabajo__c ||
                   oldAccount.ANEFI_work_position__c != acc.ANEFI_work_position__c ||
                   oldAccount.ANEFI_Monthly_expenses__c != acc.ANEFI_Monthly_expenses__c
                  ){
                       
                     //Update en gestor
                       checkAndUpdateFields(acc.Id, acc.Codigo_persona_en_Gestor__c);       
                                     
                   }                
                
            }else{
                //Check persona juridica
                if(acc.RecordTypeId == recordTypeIdPersonaJuridica){
                    //Check if any integration field was changed before making call to integration
                    if (oldAccount.Capital_social__c != acc.Capital_social__c ||
                        oldAccount.Calle_principal_direccion_tributaria__c != acc.Calle_principal_direccion_tributaria__c ||
                        oldAccount.Calle_principal_direccion_trabajo__c != acc.Calle_principal_direccion_trabajo__c ||
                        oldAccount.Cargo_representante_legal__c != acc.Cargo_representante_legal__c ||
                        oldAccount.Codigo_canton_direccion_trabajo__c != acc.Codigo_canton_direccion_trabajo__c ||
                        oldAccount.Codigo_canton_direccion_tributaria__c != acc.Codigo_canton_direccion_tributaria__c ||
                        oldAccount.Codigo_pais_direccion_tributaria__c != acc.Codigo_pais_direccion_tributaria__c ||
                        oldAccount.Codigo_pais_direccion_trabajo__c != acc.Codigo_pais_direccion_trabajo__c ||
                        oldAccount.Codigo_pais_nacionalidad__c != acc.Codigo_pais_nacionalidad__c ||
                        oldAccount.Codigo_actividad_economica__c != acc.Codigo_actividad_economica__c ||
                        oldAccount.Tipo_de_identificacion__c != acc.Tipo_de_identificacion__c ||
                        oldAccount.Tipo_de_persona_juridica__c != acc.Tipo_de_persona_juridica__c ||
                        oldAccount.Fecha_de_constitucion__c != acc.Fecha_de_constitucion__c ||
                        oldAccount.Numero_de_identificacion__c != acc.Numero_de_identificacion__c ||
                        oldAccount.Interseccion_direccion_tributaria__c != acc.Interseccion_direccion_tributaria__c ||
                        oldAccount.Interseccion_direccion_trabajo__c != acc.Interseccion_direccion_trabajo__c ||
                        oldAccount.Name != acc.Name ||
                        oldAccount.Numero_direccion_tributaria__c != acc.Numero_direccion_tributaria__c ||
                        oldAccount.Numero_direccion_trabajo__c != acc.Numero_direccion_trabajo__c ||
                        oldAccount.Description != acc.Description ||
                        oldAccount.Politicamente_expuesto__c != acc.Politicamente_expuesto__c ||
                        oldAccount.Identificacion_representante_legal__c != acc.Identificacion_representante_legal__c ||
                        oldAccount.Secuencia_canton_direccion_tributaria__c != acc.Secuencia_canton_direccion_tributaria__c ||
                        oldAccount.Secuencia_canton_direccion_trabajo__c != acc.Secuencia_canton_direccion_trabajo__c ||
                        oldAccount.Telefono_celular__c != acc.Telefono_celular__c ||
                        oldAccount.Phone != acc.Phone ||
                        oldAccount.Total_activos__c != acc.Total_activos__c ||
                        oldAccount.Total_pasivos__c != acc.Total_pasivos__c ||
                        oldAccount.Total_gastos__c != acc.Total_gastos__c ||
                        oldAccount.AnnualRevenue != acc.AnnualRevenue ||
                        oldAccount.Entidad_financiera__c != acc.Entidad_financiera__c ||                                                
                        oldAccount.Numero_de_cuenta_bancaria__c != acc.Numero_de_cuenta_bancaria__c ||
                        oldAccount.Tipo_de_cuenta_bancaria__c != acc.Tipo_de_cuenta_bancaria__c ||
                        oldAccount.Tipo_identificacion_representante_legal__c != acc.Tipo_identificacion_representante_legal__c ||   
                        
                        oldAccount.Entidad_Financiera__c != acc.Entidad_Financiera__c ||
                        oldAccount.Actividad_Economica__c != acc.Actividad_Economica__c ||  
                        oldAccount.Nacionalidad__c != acc.Nacionalidad__c ||       
                        oldAccount.Pais_direccion_trabajo__c != acc.Pais_direccion_trabajo__c || 
                        oldAccount.Pais_direccion_tributaria__c != acc.Pais_direccion_tributaria__c || 
                        oldAccount.Canton_direccion_de_trabajo__c != acc.Canton_direccion_de_trabajo__c || 
                        oldAccount.Canton_direccion_tributaria__c != acc.Canton_direccion_tributaria__c ||                        
                        
                        oldAccount.Correo_electronico__c != acc.Correo_electronico__c) {

                            //Update en gestor
                            checkAndUpdateFields(acc.Id, acc.Codigo_persona_en_Gestor__c);
                            system.debug('-----------------Update to Gestor -------------------');
                                            
                        }
                    
                }
            }                                    
        }        
        
    }
    

    @future(callout=true)
     public static void checkAndUpdateFields(String accId, String accCodGestor) {
        system.debug('---------------------Method CHECK AND UPDATE FIELDS------------------ ');        
        if(!ANEFI_ConsultarClienteEnGestorController.markUpdatedOrNot(accId)) {
            system.debug('If fields are different, enqueue the job to update fields ');   
            System.enqueueJob(new ANEFI_UpdateFieldsQueueable(accId, accCodGestor));
        }
    }
    

    
    
}