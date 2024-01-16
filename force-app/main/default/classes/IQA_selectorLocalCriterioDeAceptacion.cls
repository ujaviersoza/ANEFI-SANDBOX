/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-07
    * Description: Apex class for query data from IQA_Criterio__c object.
*/
public with sharing class IQA_selectorLocalCriterioDeAceptacion {
    
    public static List<IQA_Criterio__c> getCriteriasByTestingCase(String testingCaseId, Integer queryLimits) {
        return [SELECT Id, Name, Id_Caso_de_Prueba__c, CreatedById, Criterio__c, Criterio_Name__c, Descripcion_del_Caso_de_Prueba__c, Estado_del_Criterio_de_Aceptacion__c, Id_Ciclo_de_Pruebas__c, Id_Historia_de_Usuario__c, LastModifiedById, Nombre_del_Ciclo_de_Pruebas__c, Sprint__c, Total_de_Escenarios__c, Titulo_de_la_Historia_de_Usuario__c FROM IQA_Criterio__c WHERE Id_Caso_de_Prueba__c = :testingCaseId WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT :queryLimits];
    }

}