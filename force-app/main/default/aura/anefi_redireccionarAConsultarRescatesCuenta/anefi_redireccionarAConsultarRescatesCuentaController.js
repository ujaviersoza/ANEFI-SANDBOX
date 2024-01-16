({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");        
        var clienteId = myPageRef.state.c__clienteId;
        var codigoProducto = myPageRef.state.c__codigoProducto;        
        var numeroCuenta = myPageRef.state.c__numeroCuenta;
        var clienteCodigoGestor = myPageRef.state.c__clienteCodigoGestor;
        var tipoTransaccion = myPageRef.state.c__tipoTransaccion;        

        cmp.set("v.clienteId", clienteId);
        cmp.set("v.codigoProducto", codigoProducto);      
        cmp.set("v.numeroCuenta", numeroCuenta);
        cmp.set("v.clienteCodigoGestor", clienteCodigoGestor);
        cmp.set("v.tipoTransaccion", tipoTransaccion);  
        
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
                                        if(statePageReference.c__clienteId === clienteId && 
                                            statePageReference.c__codigoProducto === codigoProducto && 
                                            statePageReference.c__numeroCuenta === numeroCuenta && 
                                            statePageReference.c__clienteCodigoGestor === clienteCodigoGestor &&
                                            statePageReference.c__tipoTransaccion === tipoTransaccion){
                                                workspaceAPI.setTabLabel({
                                                    tabId: subtab.tabId,
                                                    label: "Rescates de la cuenta número: " + numeroCuenta
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
    }
})