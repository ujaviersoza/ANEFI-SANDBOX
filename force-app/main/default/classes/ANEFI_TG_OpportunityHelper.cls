/**
*Class Name: ANEFI_TG_OpportunityHelper.
*Description: Clase Helper para el trigger ANEFI_OportunidadTrigger.
*Created Date: 2/6/2023, 13:31 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 7/7/2023, 22:19 PM.
*/
public class ANEFI_TG_OpportunityHelper {
    
    public static Map<String, String> m = new Map<String, String>();
    
    public static MDT_ANEFI_Validations__mdt[] listMDT = [SELECT Id,DeveloperName, MasterLabel, ANEFI_Object_validation__c, ANEFI_Custom_message__c 
                                                  FROM MDT_ANEFI_Validations__mdt];
    
    public static Id FONDOS_DE_INVERSION =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Fondos_de_Inversion').getRecordTypeId();
    public static Id APORTE_PERSONA_JURIDICA =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Aporte_Persona_Juridica').getRecordTypeId();
    public static Id APORTE_PERSONA_NATURAL =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Aporte_Persona_Natural').getRecordTypeId();

    
    //Assign recordtype Opportunity in the Lead Conversion according the custom field: Línea de negocio.
    public static void assignRecordtypeLeadConversion(List<Opportunity> opps) {
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        //System.debug('El Registro que entra: '+Json.serialize(opps));
        Id devRecordTypeId;
        for(Opportunity op : opps) {
            if(op.ANEFI_Opportunity_conversion__c == true) {
                if(op.ANEFI_Business_line__c == 'Fondos') {
                    devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Fondos_de_Inversion').getRecordTypeId();
                    op.RecordTypeId = devRecordTypeId;
                } else if(op.ANEFI_Business_line__c == 'Negocios Fiduciarios'){
                    devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Negocios_Fiduciarios').getRecordTypeId();
                    op.RecordTypeId = devRecordTypeId;
                } else {
                    //op.addError(m.get('X002'));
                }
            }
            //System.debug('El Registro que se modificó con el tipo de registro correcto: '+Json.serialize(op));
        }
    }
    
    public static void validateOpportunities(List<Opportunity> opss) {    
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        List<Opportunity> lstOpps = new List<Opportunity>(); 
        
        Set<Id> associatedAccId = new Set<Id>() ;
        for(Opportunity op: opss) {
            associatedAccId.add(op.AccountId);
        }
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Gestion_de_Cuentas').getRecordTypeId();
           
        lstOpps = [Select Id,StageName,RecordType.DeveloperName,AccountId,Producto_de_Interes__c From Opportunity Where AccountId IN: associatedAccId];
        
        for(Opportunity o : opss) {
            if(oppRecordTypeId == o.RecordTypeId) {
                for(Opportunity opp : lstOpps) { 
                    if(opp.RecordType.DeveloperName == 'Gestion_de_Cuentas' && opp.StageName != 'No Interesado' && opp.StageName != 'Convertido' 
                       && o.Producto_de_Interes__c == opp.Producto_de_Interes__c) {
                        if(o.AccountId == opp.AccountId) {
                            o.addError(m.get('X003'));
                        }
                    }
                }
            }    
        }
    }
    
    public static void syncInGestor(List<Opportunity> opps, Map<Id, Opportunity> mapOldOpps) {  
        
        //get custom error messages
        for(MDT_ANEFI_Validations__mdt error : listMDT){
            m.put(error.DeveloperName,error.ANEFI_Custom_message__c);
        }
        
        for(Id key: mapOldOpps.keyset()){ 
            if(!test.isRunningTest()) {
            	if(mapOldOpps.get(key).Sincronizado_en_Gestor__c = True && mapOldOpps.get(key).Estado_sincronizacion_Gestor__c == 'SINCRONIZADO OK'){
                	mapOldOpps.get(key).addError(m.get('X007'));    
                }    
            }
        }
    }
    
    public static void incompleteClient(List<Opportunity> opps) {       
        for(Opportunity itemOpp : opps){
            if(itemOpp.StageName == 'Cerrada ganada' &&
               (itemOpp.RecordtypeId == FONDOS_DE_INVERSION ||
                itemOpp.RecordtypeId == APORTE_PERSONA_JURIDICA ||
                itemOpp.RecordtypeId == APORTE_PERSONA_NATURAL)){
                    list<String> missingFields = ANEFI_ValidarCamposCierreOportunidadCC.CamposFaltantesAltaCliente(itemOpp.AccountId);
                    if(missingFields.size() > 0){
                        itemOpp.addError('No se puede marcar esta oportunidad como Cerrada Ganada porque la información del cliente está incompleta');
                    }
                    
                }
            
        }
    }
}