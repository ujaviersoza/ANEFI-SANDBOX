/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-06
    * Description: Apex class controller for testing console component.
*/
public with sharing class IQA_testingConsoleController {
    
    @AuraEnabled
    public static List<IQA_Caso_de_Prueba__c> getAllTestingCases(Integer queryLimits) {
        return IQA_serviceTestingCasoDePrueba.getAllTestingCases(queryLimits);
    }

    @AuraEnabled
    public static List<IQA_Criterio__c> getCriteriasByTestingCase(String testingCaseId, Integer queryLimits) {
        return IQA_serviceTestingCasoDePrueba.getCriteriasByTestingCase(testingCaseId, queryLimits);
    }

    @AuraEnabled
    public static List<IQA_Escenario__c> getStagesByAcceptanceCriteriaId(String criteriaId, Integer queryLimits) {
        return IQA_serviceTestingCasoDePrueba.getStagesByAcceptanceCriteriaId(criteriaId, queryLimits);
    }

    @AuraEnabled
    public static List<IQA_Ejecucion__c> getAllExecutionsByStages(String stageId, Integer queryLimits) {
        return IQA_serviceTestingCasoDePrueba.getAllExecutionsByStages(stageId, queryLimits);
    }

    @AuraEnabled
    public static IQA_Ejecucion__c cloneExecutionRecord(String originalExecutionId, String stageId, Integer queryLimits) {
        IQA_Ejecucion__c executionCloned = new IQA_Ejecucion__c();

        try {
            executionCloned = IQA_serviceTestingCasoDePrueba.cloneExecutionRecord(originalExecutionId, stageId, queryLimits);
        } catch(Exception ex) { throw new AuraHandledException(ex.getMessage()); }

        return executionCloned;
    }

}