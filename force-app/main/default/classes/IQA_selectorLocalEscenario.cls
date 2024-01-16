/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-07
    * Description: Apex class for query data from IQA_Escenario__c object.
*/
public with sharing class IQA_selectorLocalEscenario {
    
    public static List<IQA_Escenario__c> getStagesByAcceptanceCriteriaId(String criteriaId, Integer queryLimits) {
        return [SELECT Id, Name, CreatedById, Datos_de_Prueba__c, Estado_del_Escenario__c, Fila__c, Id_Criterio__c, LastModifiedById, Notas__c, Pasos__c, Perfil_o_Rol__c, Resultado_Esperado__c, Total_de_Ejecuciones__c, Descripcion_del_Escenario__c FROM IQA_Escenario__c WHERE Id_Criterio__c = :criteriaId WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT :queryLimits];
    }

}