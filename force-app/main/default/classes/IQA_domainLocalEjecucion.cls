/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-09
    * Description: Apex class for CRUD action over IQA_Ejecucion__c object.
*/
public with sharing class IQA_domainLocalEjecucion {

    public static IQA_Ejecucion__c cloneExecutionRecord(IQA_Ejecucion__c originalRecord) {
        IQA_Ejecucion__c newExecution = new IQA_Ejecucion__c();

        try {
            newExecution = originalRecord.clone();

            // Clean key data 
            newExecution.Estado_de_la_Ejecucion__c = 'No Iniciada';
            newExecution.Inicio__c = null;
            newExecution.Fin__c = null;
            newExecution.Resultados_Obtenidos__c = null;
            newExecution.URL_de_Evidencias__c = null;

            // Insert new record
            Insert newExecution;
        } catch(Exception ex) { throw ex; }

        return newExecution;
    }

}