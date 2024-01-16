({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");        
        var clienteId = myPageRef.state.c__clienteId;
        var codigoProducto = myPageRef.state.c__codigoProducto;
        var nombreProducto = myPageRef.state.c__nombreProducto;
        var codigoAgencia = myPageRef.state.c__codigoAgencia;
        var nombreAgencia = myPageRef.state.c__nombreAgencia;
        var codigoTrader = myPageRef.state.c__codigoTrader;
        var nombreTrader = myPageRef.state.c__nombreTrader;
        var numeroCuenta = myPageRef.state.c__numeroCuenta;
        var codigoTipoCuenta = myPageRef.state.c__codigoTipoCuenta;
        var nombreTipoCuenta = myPageRef.state.c__nombreTipoCuenta;
        var fechaApertura = myPageRef.state.c__fechaApertura;
        var estado = myPageRef.state.c__estado;
        var nombreComponente = myPageRef.state.c__nombreComponente;
        console.log('nombreComponente: ' + nombreComponente);

        cmp.set("v.clienteId", clienteId);
        cmp.set("v.codigoProducto", codigoProducto);
        cmp.set("v.nombreProducto", nombreProducto);
        cmp.set("v.codigoAgencia", codigoAgencia);
        cmp.set("v.nombreAgencia", nombreAgencia);
        cmp.set("v.codigoTrader", codigoTrader);
        cmp.set("v.nombreTrader", nombreTrader);
        cmp.set("v.numeroCuenta", numeroCuenta);
        cmp.set("v.codigoTipoCuenta", codigoTipoCuenta);
        cmp.set("v.nombreTipoCuenta", nombreTipoCuenta);
        cmp.set("v.fechaApertura", fechaApertura);
        cmp.set("v.estado", estado); 
        
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
                                        if(statePageReference.c__nombreComponente === 'DetalleCuenta' &&
                                         statePageReference.c__clienteId === clienteId){
                                                workspaceAPI.setTabLabel({
                                                    tabId: subtab.tabId,
                                                    label: "Detalle cuenta número: " + numeroCuenta
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