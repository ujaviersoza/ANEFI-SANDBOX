({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");        
        var clienteId = myPageRef.state.c__clienteId; 
        var codigoProducto = myPageRef.state.c__codigoProducto;  
        var numeroCuentaParticipe = myPageRef.state.c__numeroCuentaParticipe; 
        var fechaCorte = myPageRef.state.c__fechaCorte; 
        var fechaDesde = myPageRef.state.c__fechaDesde; 
        var nombreComponente = myPageRef.state.c__nombreComponente;   
        var nombreProducto = myPageRef.state.c__nombreProducto;       

        
        cmp.set("v.clienteId", clienteId);
        cmp.set("v.codigoProducto", codigoProducto); 
        cmp.set("v.urlVisualForcePage", '/apex/ANEFI_GenerarEstadoDeCuentaPage?clienteId=' + clienteId + '&codigoProducto=' + codigoProducto +
        '&numeroCuentaParticipe=' + numeroCuentaParticipe + '&fechaCorte=' + fechaCorte + '&fechaDesde=' + fechaDesde + '&nombreProducto=' + nombreProducto);

        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            let tabs = response;                 
            if(tabs && tabs.length > 0){
                for(let tab of tabs){
                    let subtabs = tab.subtabs;                    
                    if(subtabs && subtabs.length > 0){
                        for(let subtab of subtabs){                          
                            let pageReferenceSubTab = subtab.pageReference;                                                       
                            if(pageReferenceSubTab){
                                if(pageReferenceSubTab.type === 'standard__component'){
                                    let statePageReference = pageReferenceSubTab.state;                                    
                                    if(statePageReference){
                                        if(statePageReference.c__nombreComponente === 'GenerarEstadoCuenta' &&
                                         statePageReference.c__clienteId === clienteId &&
                                         statePageReference.c__numeroCuentaParticipe === numeroCuentaParticipe){
                                                workspaceAPI.setTabLabel({
                                                    tabId: subtab.tabId,
                                                    label: "Estado de cuenta: " + numeroCuentaParticipe
                                                });                                                
                                            }                                            
                                    }
                                }                                
                            }
                            
                        }
                    }
                    
        
                }
            }
            
       })
        .catch(function(error) {
            console.log(error);
        });
            
      
    },
    downloadDocument : function(component, event, helper){
       
        /*var sendDataProc = component.get("v.sendData");
        var dataToSend = {
           "label" : "This is test"
        }; //this is data you want to send for PDF generation
      
        //invoke vf page js method
        sendDataProc(dataToSend, function(){
                    //handle callback
        });*/

        /*var url = '/apex/ANEFI_GenerarEstadoDeCuentaPage';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();*/

        var navService = cmp.find("navService");
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: '0011h00000lFijDAAS',
                objectApiName: 'Account',
                actionName: 'view'
            }
        }
        event.preventDefault();
        navService.navigate(pageReference);

       }


})