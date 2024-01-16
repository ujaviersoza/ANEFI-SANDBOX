/*
    * Author: Juan P. Rodriguez
    * Version Date: 2023-01-06
    * Description: Apex class for testing business logics.
*/
public with sharing class IQA_serviceTestingCasoDePrueba {
    
    public static List<IQA_Caso_de_Prueba__c> getAllTestingCases(Integer queryLimits) {
        return IQA_selectorLocalCasosDePrueba.getAllTestingCases(queryLimits);
    }

    public static List<IQA_Criterio__c> getCriteriasByTestingCase(String testingCaseId, Integer queryLimits) {
        return IQA_selectorLocalCriterioDeAceptacion.getCriteriasByTestingCase(testingCaseId, queryLimits);
    }

    public static List<IQA_Escenario__c> getStagesByAcceptanceCriteriaId(String criteriaId, Integer queryLimits) {
        return IQA_selectorLocalEscenario.getStagesByAcceptanceCriteriaId(criteriaId, queryLimits);
    }

    public static List<IQA_Ejecucion__c> getAllExecutionsByStages(String stageId, Integer queryLimits) {
        return IQA_selectorLocalEjecucion.getAllExecutionsByStages(stageId, queryLimits);
    }

    public static IQA_Ejecucion__c cloneExecutionRecord(String originalExecutionId, String stageId, Integer queryLimits) {
        IQA_Ejecucion__c newExecution = new IQA_Ejecucion__c();
        List<IQA_Ejecucion__c> executions = new List<IQA_Ejecucion__c>();
        IQA_Ejecucion__c originalExecution = new IQA_Ejecucion__c();

        try {
            // Get original execution record 
            executions = getAllExecutionsByStages(stageId, queryLimits);

            if(!executions.isEmpty()) {
                for(IQA_Ejecucion__c exec : executions) {
                    if(exec.Id == originalExecutionId) {
                        originalExecution = exec;
                        break;
                    }
                }

                // Clone execution
                if(originalExecution != null) {
                    newExecution = IQA_domainLocalEjecucion.cloneExecutionRecord(originalExecution);

                    // Query all fields from record.
                    if(newExecution != null) {
                        newExecution = IQA_selectorLocalEjecucion.getExecutionById(newExecution.Id);
                    }
                }
            }
        } catch(Exception ex) { throw ex; }

        return newExecution;
    }

}