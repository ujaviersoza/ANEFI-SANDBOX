public with sharing class ANEFI_CampoFormularioController {

    public class RespuestaConsultaObjeto{
        @AuraEnabled
        public String id;
        
        @AuraEnabled
        public String nombre;
    }

    @AuraEnabled(Cacheable=true)
    public static RespuestaConsultaObjeto consultarObjetoPorCodigo(String objectApiName, String codigo){
        RespuestaConsultaObjeto resp = new RespuestaConsultaObjeto();
        if(objectApiName.equals('ANEFI_Pais__c')){
            List<ANEFI_Pais__c> paises = [SELECT Id, Name, Codigo_Pais__c FROM ANEFI_Pais__c WHERE Codigo_Pais__c = :codigo WITH SECURITY_ENFORCED LIMIT 1];
            if(paises.size() > 0){
                ANEFI_Pais__c pais = paises.get(0);
                resp.id = pais.Id;
            	resp.nombre = pais.Name;
            }            
        }
        else if(objectApiName.equals('ANEFI_Actividad_Economica__c')){
            List<ANEFI_Actividad_Economica__c> actividadesEconomicas = [SELECT Id, Name FROM ANEFI_Actividad_Economica__c WHERE Name = :codigo WITH SECURITY_ENFORCED LIMIT 1];
            if(actividadesEconomicas.size() > 0){
                ANEFI_Actividad_Economica__c actividadEconomica = actividadesEconomicas.get(0);
                resp.id = actividadEconomica.Id;
                resp.nombre = actividadEconomica.Name;
            }
            
        }
        else if(objectApiName.equals('ANEFI_Canton__c')){
            List<ANEFI_Canton__c> cantones = [SELECT Id, Name, 	Nombre_canton__c FROM ANEFI_Canton__c WHERE Name = :codigo WITH SECURITY_ENFORCED LIMIT 1];
            if(cantones.size() > 0){
                ANEFI_Canton__c canton = cantones.get(0);
                resp.id = canton.Id;
            	resp.nombre = canton.Nombre_canton__c;
            }
            
        }
        else if(objectApiName.equals('ANEFI_Entidad_financiera__c')){
            List<ANEFI_Entidad_financiera__c> entidadesFinancieras = [SELECT Id, Name FROM ANEFI_Entidad_financiera__c WHERE Name = :codigo WITH SECURITY_ENFORCED LIMIT 1];
            if(entidadesFinancieras.size() > 0){
                ANEFI_Entidad_financiera__c entidadFinanciera = entidadesFinancieras.get(0);
                resp.id = entidadFinanciera.Id;
            	resp.nombre = entidadFinanciera.Name; 
            }
            
        }
        return resp;
    }
}