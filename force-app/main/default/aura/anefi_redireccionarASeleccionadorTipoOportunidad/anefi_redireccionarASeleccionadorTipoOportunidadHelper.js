({
    getRecordTypes : function(component,event,helper, clienteId){
        var action = component.get("c.obtenerTiposRegistroOportunidad");
        var valorSeleccionado = '';
        action.setParams({ objectId : clienteId });
        action.setCallback(this,function(response){            
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var recordTypes = response.getReturnValue();
                console.log(recordTypes);
                console.log('recordTypes -> ' + JSON.stringify(recordTypes));
                for(var key in recordTypes){                   
                   returning.push({ label: recordTypes[key], value: key });
            
                }
                console.log('returning -> ' + JSON.stringify(returning));
                valorSeleccionado = returning[0].value;                
                component.set("v.availableRecordTypes",returning);
                component.set("v.retrievedTypes",true);
                component.set("v.valorSeleccionado",valorSeleccionado);
                component.set("v.recordTypeId",valorSeleccionado ); 
            }
            else{
                this.showError(component,event,helper);
            }
        });
        $A.enqueueAction(action); 
    },
    obtenerInformacionCliente: function(component,event,helper, objectId){
        if(objectId){
            var action = component.get("c.obtenerClienteId");
            action.setParams({ objectId : objectId });
            action.setCallback(this,function(response){                
                var state = response.getState();
                if(state === "SUCCESS"){ 
                    var clienteId = response.getReturnValue();                 
                    component.set("v.clienteId",clienteId);   
                    this.getRecordTypes(component,event,helper, clienteId);                 
                }
                else{
                    this.showError(component, event, helper);
                }
            });
            $A.enqueueAction(action); 
        }else{
            this.getRecordTypes(component,event,helper, objectId);
        }
    },

    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Se presentó un problema obteniendo los tipos de registro de una oportunidad',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },

})