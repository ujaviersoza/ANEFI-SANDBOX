({
    doInit: function(component, event, helper) { 
        console.log('ENTRA AL INICIALIZADOR DEL COMPONENTE');
        let recordId = ''; 
        var pageRef = component.get("v.pageReference");  
        console.log('pageRef: ' + JSON.stringify(pageRef) );
              
        if(pageRef.state){
            var state = pageRef.state; // state holds any query params        	        
            var base64Context = state.inContextOfRef;	
            if(base64Context){                	        
                if (base64Context.startsWith("1\.")) {	            
                    base64Context = base64Context.substring(2);                  	        
                }	        
                var addressableContext = JSON.parse(window.atob(base64Context)); 
                console.log(addressableContext.attributes.recordId);               
                component.set("v.recordId", addressableContext.attributes.recordId);  
                recordId = addressableContext.attributes.recordId;
            } 
        }        
        
        helper.obtenerInformacionCliente(component,event,helper, recordId);
        
    },
    cancel : function(component, helper) {        
        var navService = component.find("navService");        
        var pageRef;
        var clienteId = component.get("v.clienteId");
        if(clienteId){
            // Navigate back to the record view
            var navigateEvent = $A.get("e.force:navigateToSObject");
            navigateEvent.setParams({ "recordId": clienteId });
            navigateEvent.fire();
        }
        else{
            pageRef = {
                type: "standard__objectPage",
                attributes: {
                    objectApiName: "Opportunity",
                    actionName: "home"
                }
            }

            navService.navigate(pageRef);
            
        }
        
        
        
    },
    optionSelected : function(component,event,helper){        
        var recordValue = event.getParam("value");       
        var recordTypes = component.get("v.availableRecordTypes");
        for(var i=0;i<recordTypes.length;i++){            
            if(recordValue == recordTypes[i].value){ 
                console.log(recordTypes[i].value);  
                component.set("v.recordTypeId",recordTypes[i].value);
                break;
            }
        }
    },
    siguiente : function(component,event, helper){
        var navService = component.find("navService");
        var clienteId = component.get("v.clienteId");
        var recordTypeId = component.get("v.recordTypeId");        

        var selectedRecordTypeId = recordTypeId;
        if(selectedRecordTypeId){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": 'Opportunity',
                "recordTypeId": selectedRecordTypeId,
                "defaultFieldValues":{                    
                    "AccountId" : clienteId,
                },
            });
            createRecordEvent.fire();
        }

    },
    handlePageChange : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})