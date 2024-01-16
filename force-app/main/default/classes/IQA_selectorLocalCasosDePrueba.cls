/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-06
    * Description: Apex class for query data from IQA_Caso_de_Prueba__c object.
*/
public with sharing class IQA_selectorLocalCasosDePrueba {
    
    public static List<IQA_Caso_de_Prueba__c> getAllTestingCases(Integer queryLimits) {
        return [SELECT Id, Name, Asignado_a__c, CreatedById, Criterios_Probados__c, Descripcion_del_Caso_de_Prueba__c, Enlace_de_Documentacion__c, Esfuerzo_Estimado__c, Estado_del_Caso_de_Prueba__c, Estado_del_Caso_de_Prueba_Texto__c, Fila__c, Id_Ciclo_de_Pruebas__c, LastModifiedById, Nombre_del_Ciclo_de_Pruebas__c, OwnerId, PO_Valido_Resultado_en__c, Product_Owner__c, Puntaje__c, RecordTypeId, Sprint__c, Theme__c, Tipo_de_Prueba__c, Total_de_Criterios__c, Titulo_de_la_Historia__c, WORK_ID__c, Epica__c FROM IQA_Caso_de_Prueba__c WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT :queryLimits];
    }

}