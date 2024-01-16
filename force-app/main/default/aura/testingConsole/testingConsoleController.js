({
    doInit: function(component, event, helper) {
        // Load testing cases
        let getTestingCasesAction = component.get("c.getAllTestingCases");
        getTestingCasesAction.setParams({ queryLimits: component.get("v.queryLimits") });
        getTestingCasesAction.setCallback(component, function(response) {
            let testingCaseState = response.getState();
            let testingCases = [{label: "-- Ninguno --", value: ""}];

            if(testingCaseState === "SUCCESS") {
                let data = response.getReturnValue();
                if(!helper.validateInput(data)) {
                    //Evaluate each record 
                    data.forEach(item => {
                        testingCases.push({label: `${item.Name} - ${item.Descripcion_del_Caso_de_Prueba__c}`, value: item.Id });
                    });
                    component.set("v.testingCasesData", data);
                    component.set("v.testingCasesOptions", testingCases);
                } else {
                    component.set("v.testingCasesData", []);
                    component.set("v.testingCasesOptions", testingCases);
                }
            } else if(testingCaseState === "INCOMPLETE") {
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se ha podido recuperar los registros de casos de prueba, favor recargar su navegador.";
                helper.showToast(mode, type, title, message);
            } else if(testingCaseState === "ERROR") {
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se pudo recuperar los registros de casos de prueba, favor contacte a su administrador.";
                helper.showToast(mode, type, title, message);
            }
        });
        $A.enqueueAction(getTestingCasesAction);
    },

    testingCaseOptionHandler: function(component, event, helper) {
        let caseIdSelected = event.getParam("value");
        let criterias = [{label: "-- Ninguno --", value: ""}];

        if(helper.validateInput(caseIdSelected)) {
            component.set("v.criteriaCasesData", []);
            component.set("v.criteriaCasesOptions", criterias);
        } else {
            // Load list of criterias
            let getCriteriasAction = component.get("c.getCriteriasByTestingCase");
            getCriteriasAction.setParams({ testingCaseId : caseIdSelected, queryLimits : component.get("v.queryLimits") });
            getCriteriasAction.setCallback(component, function(response) {
                let criteriaState = response.getState();

                if(criteriaState === 'SUCCESS') {
                    let data = response.getReturnValue();
                    if(!helper.validateInput(data)) {
                        //Evaluate each record 
                        data.forEach(item => {
                            criterias.push({label: `${item.Name} - ${item.Criterio_Name__c}`, value: item.Id });
                        });
                        component.set("v.criteriaCasesData", data);
                        component.set("v.criteriaCasesOptions", criterias);
                    } else {
                        component.set("v.criteriaCasesData", []);
                        component.set("v.criteriaCasesOptions", criterias);
                    }
                } else if(criteriaState === 'INCOMPLETE') {
                    let mode = "sticky";
                    let type = "error";
                    let title = "Aviso de error";
                    let message = "No se ha podido recuperar los registros de criterios, favor recargar su navegador.";
                    helper.showToast(mode, type, title, message);
                } else if(criteriaState === 'ERROR') {
                    let mode = "sticky";
                    let type = "error";
                    let title = "Aviso de error";
                    let message = "No se pudo recuperar los registros de criterios, favor contacte a su administrador.";
                    helper.showToast(mode, type, title, message);
                }
            });
            $A.enqueueAction(getCriteriasAction);
        }

        // Erase selections 
        helper.eraseStages(component);
        helper.eraseExecutions(component);

        // Clean target selection.
        helper.cleanCriterias(component);
        helper.cleanStages(component)
        helper.cleanExecutions(component);
    },

    criteriaCaseOptionHandler: function(component, event, helper) {
        let criteriaIdSelected = event.getParam("value");
        let stages = [{label: "-- Ninguno --", value: ""}];

        if(helper.validateInput(criteriaIdSelected)) {
            component.set("v.stageCasesData", []);
            component.set("v.stageCasesOptions", stages);
        } else {
            // Load list of stages
            let getStageByAccAction = component.get("c.getStagesByAcceptanceCriteriaId");
            getStageByAccAction.setParams({ criteriaId : criteriaIdSelected, queryLimits : component.get("v.queryLimits") });
            getStageByAccAction.setCallback(component, function(response) {
                let stageState = response.getState();

                if(stageState === 'SUCCESS') {
                    let data = response.getReturnValue();
                    if(!helper.validateInput(data)) {
                        //Evaluate each record 
                        data.forEach(item => {
                            stages.push({label: `${item.Name} - ${item.Estado_del_Escenario__c}`, value: item.Id });
                        });
                        component.set("v.stageCasesData", data);
                        component.set("v.stageCasesOptions", stages);
                    } else {
                        component.set("v.stageCasesData", []);
                        component.set("v.stageCasesOptions", stages);
                    }
                } else if(stageState === 'INCOMPLETE') {
                    let mode = "sticky";
                    let type = "error";
                    let title = "Aviso de error";
                    let message = "No se ha podido recuperar los escenarios, favor recargar su navegador.";
                    helper.showToast(mode, type, title, message);
                } else if(stageState === 'ERROR') {
                    let mode = "sticky";
                    let type = "error";
                    let title = "Aviso de error";
                    let message = "No se pudo recuperar los escenarios de prueba, favor contacte a su administrador.";
                    helper.showToast(mode, type, title, message);
                }
            });
            $A.enqueueAction(getStageByAccAction);
        }

        // Erase selections 
        helper.eraseExecutions(component);

        // Clean target selection.
        helper.cleanStages(component);
        helper.cleanExecutions(component);
    },

    stageCaseOptionHandler : function(component, event, helper) {
        let stageIdSelected = event.getParam("value");
        component.set("v.stageCaseSelected", stageIdSelected);
        let executions = [{label: "-- Ninguno --", value: ""}];

        if(helper.validateInput(stageIdSelected)) {
            component.set("v.executionCasesData", []);
            component.set("v.executionCasesOptions", executions);
        } else {
            helper.loadExecutions(component);
        }

        // Clean target selection.
        helper.cleanExecutions(component);
    },

    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "title": "Registro actualizado",
            "message": "El registro ha sido actualizado de forma exitosa.",
            "variant": "success"
        });
    },

    handleError : function(component, event, helper) {
        component.find('notifLib').showToast({
            "title": "Algo está mal",
            "message": event.getParam("message"),
            "variant": "error"
        });
    },

    openNewWork : function(component, event, helper) {
        let workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: "/lightning/o/agf__ADM_Work__c/new?navigationLocation=LIST_VIEW&nooverride=true&useRecordTypeCheck=true",
            focus: true
        }).catch(function(error) {
            let mode = "sticky";
            let type = "error";
            let title = "Aviso de error";
            let message = "Ocurrió un error al tratar de abrir tab para nuevo registro, favor contacte a su administrador.";
            helper.showToast(mode, type, title, message);
        });
    },

    cloneConfirmationPrompt : function(component, event, helper) {
        helper.cloneConfirmationPrompt(component, event);
    },

    cloneExecution : function(component, event, helper) {
        // Load list of criterias
        let cloneExecutionAction = component.get("c.cloneExecutionRecord");
        cloneExecutionAction.setParams({ originalExecutionId : component.get("v.executionCaseSelected"), stageId : component.get("v.stageCaseSelected"), queryLimits : component.get("v.queryLimits") });
        cloneExecutionAction.setCallback(component, function(response) {
            let cloneActionState = response.getState();
            // Enable button for cloning
            component.set("v.disableCloneBtn", false);

            if(cloneActionState === 'SUCCESS') {
                let data = response.getReturnValue();
                if(!helper.validateInput(data)) {
                    let mode = "dismissible";
                    let type = "success";
                    let title = "Notificación";
                    let message = `Se ha genarado el nuevo registro "${data.Name}" de forma exitosa, favor seleccione la ejecución correspondiente.`;
                    helper.showToast(mode, type, title, message);

                    // Reload Records of Executions
                    helper.loadExecutions(component);
                }
            } else if(cloneActionState === 'INCOMPLETE') {
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se ha podido realizar la clonación de la Ejecución, favor recargar su navegador.";
                helper.showToast(mode, type, title, message);
                // Enable button for cloning
                component.set("v.disableCloneBtn", false);
            } else if(cloneActionState === 'ERROR') {
                let errors = response.getError();
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se pudo realizar la clonación del registro, favor contacte a su administrador.";

                if(errors) {
                    if(errors[0] && errors[0].message) {
                        message += ` Detalle técnico: ${errors[0].message}.`;
                    }
                }
                helper.showToast(mode, type, title, message);
                // Enable button for cloning
                component.set("v.disableCloneBtn", false);
            }
        });
        $A.enqueueAction(cloneExecutionAction);
    }
})