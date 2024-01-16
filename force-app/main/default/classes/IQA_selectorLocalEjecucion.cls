/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-07
    * Description: Apex class for query data from IQA_Ejecucion__c object.
*/
public with sharing class IQA_selectorLocalEjecucion {

    public static List<IQA_Ejecucion__c> getAllExecutionsByStages(String stageId, Integer queryLimits) {
        return [SELECT Id, Name, CreatedById, Estado_de_la_Ejecucion__c, Estado_de_la_Ejecucion_Texto__c, Fin__c, Id_de_Cliclo_de_prueba__c, Id_Escenario__c, Inicio__c, LastModifiedById, Resultados_Obtenidos__c, URL_de_Evidencias__c FROM IQA_Ejecucion__c WHERE Id_Escenario__c = :stageId WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT :queryLimits];
    }

    public static IQA_Ejecucion__c getExecutionById(String recordId) {
        return [SELECT Id, Name, CreatedById, Estado_de_la_Ejecucion__c, Estado_de_la_Ejecucion_Texto__c, Fin__c, Id_de_Cliclo_de_prueba__c, Id_Escenario__c, Inicio__c, LastModifiedById, Resultados_Obtenidos__c, URL_de_Evidencias__c FROM IQA_Ejecucion__c WHERE Id = :recordId WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT 1];
    }

}