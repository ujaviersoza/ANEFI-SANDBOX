({
    showToast: function(modeParam, typeParam, titleParam, messageParam) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": modeParam,
            "type": typeParam,
            "title": titleParam,
            "message": messageParam
        });
        toastEvent.fire();
    },

    validateInput : function(input) {
        return (input == undefined || input == null || input == '' || input == [] || input == NaN || input == {});
    },

    cleanCriterias : function(component) {
        component.set("v.criteriaCaseSelected", "");
    },

    cleanStages : function(component) {
        component.set("v.stageCaseSelected", "");
    },

    cleanExecutions : function(component) {
        component.set("v.executionCaseSelected", "");
    },

    eraseStages : function(component) {
        let stages = [{label: "-- Ninguno --", value: ""}];
        component.set("v.stageCasesOptions", stages);
    },

    eraseExecutions : function(component) {
        let executions = [{label: "-- Ninguno --", value: ""}];
        component.set("v.executionCasesOptions", executions);
    },

    loadExecutions : function(component) {
        let self = this;
        let executions = [{label: "-- Ninguno --", value: ""}];

        // Load list of executions
        let getExecutionsByStageAction = component.get("c.getAllExecutionsByStages");
        getExecutionsByStageAction.setParams({ stageId : component.get("v.stageCaseSelected"), queryLimits : component.get("v.queryLimits") });
        getExecutionsByStageAction.setCallback(component, function(response) {
            let executionState = response.getState();

            if(executionState === 'SUCCESS') {
                let data = response.getReturnValue();
                if(!self.validateInput(data)) {
                    //Evaluate each record 
                    data.forEach(item => {
                        executions.push({label : item.Name, value : item.Id });
                    });
                    component.set("v.executionCasesData", data);
                    component.set("v.executionCasesOptions", executions);
                } else {
                    component.set("v.executionCasesData", []);
                    component.set("v.executionCasesOptions", executions);
                }
            } else if(executionState === 'INCOMPLETE') {
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se ha podido recuperar las ejecuciones, favor recargar su navegador.";
                self.showToast(mode, type, title, message);
            } else if(executionState === 'ERROR') {
                let mode = "sticky";
                let type = "error";
                let title = "Aviso de error";
                let message = "No se pudo recuperar las ejecuciones de escenarios, favor contacte a su administrador.";
                self.showToast(mode, type, title, message);
            }
        });
        $A.enqueueAction(getExecutionsByStageAction);
    },

    cloneConfirmationPrompt : function(component, event) {
        // Disable button for cloning
        component.set("v.disableCloneBtn", true);

        this.LightningConfirm.open({
            message: "¿Está seguro de realizar la operación?",
            theme: "warning",
            label: "Confirmación"
        }).then(function(result) {
            if(result == true) {
                $A.enqueueAction(component.get("c.cloneExecution"));
            } else {
                // Enable button for cloning
                component.set("v.disableCloneBtn", false);
            }
        });
    },
})