/*Noviembre 12 - 2020 - Julia Yaneth Barco
 Clase para gestionar los métodos que permiten consultar los saldos de cuentas de partícipe que alimentan los informes mensuales de gestión comercial
*/
public class ANEFI_ConsultarSaldosCuentasParticipeCC {
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
    public static ANEFI_RequestsHandler requestHandler;
    
    
    @AuraEnabled()
    public static String consultarSaldosCuentasDeParticipe(ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput){       
        String idInformeSaldosCuentasParticipe = '';
        List<ANEFI_Saldo_participe__c> saldosParticipeACrear = new List<ANEFI_Saldo_participe__c>(); 
        List<ANEFI_ServicesDTO.ItemSaldosParticipe> itemsSaldosParticipe = new List<ANEFI_ServicesDTO.ItemSaldosParticipe>();
        if(!String.isEmpty(saldosCuentasParticipeInput.codigoProducto) && !String.isBlank(saldosCuentasParticipeInput.codigoProducto)){         
            requestHandler = new ANEFI_RequestsHandler(); 	
            try{
            	configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
                loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, null, configuracionGestorWeb);
                if(loginOUTDTO != null){//El servicio de autenticación respondió correctamente  
                    //Se valida el producto seleccionado
                    if(!saldosCuentasParticipeInput.codigoProducto.equals('todos')){//Se consulta por el producto específico
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput));
                    }
                    else{//Se consultan los dos productos de fondos                        
                        //obtener saldos participe producto CP-1
                        saldosCuentasParticipeInput.codigoProducto = 'F001';
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput));
                        //obtener saldos partícipe producto FS-2
                        saldosCuentasParticipeInput.codigoProducto = 'F002';
                        //Se reinicia el número de página para consultar el nuevo producto
                        saldosCuentasParticipeInput.pageNumber = 1;
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput)); 
                        //obtener saldos partícipe producto FM-3
                        saldosCuentasParticipeInput.codigoProducto = 'F004';
                        //Se reinicia el número de página para consultar el nuevo producto
                        saldosCuentasParticipeInput.pageNumber = 1;
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput)); 
                        //obtener saldos partícipe producto FO-4
                        saldosCuentasParticipeInput.codigoProducto = 'F003';
                        //Se reinicia el número de página para consultar el nuevo producto
                        saldosCuentasParticipeInput.pageNumber = 1;
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput));
                        //obtener saldos partícipe producto FAS-5
                        saldosCuentasParticipeInput.codigoProducto = 'F005';
                        //Se reinicia el número de página para consultar el nuevo producto
                        saldosCuentasParticipeInput.pageNumber = 1;
                        saldosParticipeACrear.addAll(obtenerSaldosParticipePorProducto(saldosCuentasParticipeInput));
                    }                   
                        
                    //Eliminar los registros actuales de saldos de partícipe
                    List<ANEFI_Saldo_participe__c> saldosParticipesAEliminar = [Select Id from ANEFI_Saldo_participe__c];
                    delete saldosParticipesAEliminar;                  
                    //Crear los nuevos registros de saldos de partícipe  
                    if(saldosParticipeACrear.size() > 0){
                       insert saldosParticipeACrear; 
                    }             
                    
                    //obtener el id del reporte de saldos de cuentas de partícipes
                    List<Report> informes = [Select Id from Report where DeveloperName = 'Saldos_de_Partcipes_por_Mes_x1Z'];
                    if(informes.size() > 0){
                        idInformeSaldosCuentasParticipe = informes.get(0).Id;
                    }
                }    
                 
            }
            catch(Exception e){
                system.debug('Error obteniendo los saldos de cuentas de partícipes por producto: ' + e.getMessage());
            }
        }
        
        return idInformeSaldosCuentasParticipe;
    }
    
    public static ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut obtenerSaldosParticipePorPagina(ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput){
        ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut saldosCuentasParticipePorProductoOut = new ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut();
        try{
           saldosCuentasParticipePorProductoOut = ANEFI_Utilitarios.consultaSaldosCuentasDeParticipePorProducto(loginOUTDTO, configuracionGestorWeb, saldosCuentasParticipeInput, requestHandler);
        }
        catch(Exception e){
            system.debug('Error obteniendo saldos de partícipes por página: ' + e.getMessage());
        }       
        
        return saldosCuentasParticipePorProductoOut;
    }
    
    public static List<ANEFI_Saldo_participe__c> obtenerSaldosParticipePorProducto(ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput){
        List<ANEFI_ServicesDTO.ItemSaldosParticipe> itemsSaldosParticipeProducto = new List<ANEFI_ServicesDTO.ItemSaldosParticipe>();
        List<ANEFI_Saldo_participe__c> saldosParticipesACrear = new List<ANEFI_Saldo_participe__c>();
        try{
            ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut saldosCuentasParticipePorProductoOut = obtenerSaldosParticipePorPagina(saldosCuentasParticipeInput);
            if(saldosCuentasParticipePorProductoOut != null){//El servicio de consulta de saldos de cuentas de partícipe respondió correctamente
                itemsSaldosParticipeProducto.addAll(saldosCuentasParticipePorProductoOut.data);                               
                While(!String.isBlank(saldosCuentasParticipePorProductoOut.links.next)){//Se recorren las páginas de saldos de partícipes
                    saldosCuentasParticipeInput.pageNumber += 1;
                    saldosCuentasParticipePorProductoOut = obtenerSaldosParticipePorPagina(saldosCuentasParticipeInput);
                    itemsSaldosParticipeProducto.addAll(saldosCuentasParticipePorProductoOut.data);
                } 
                
                //Adicionar los saldos de partícipe retornados por GESTOR a la lista de registros a crear en Salesforce
                for(ANEFI_ServicesDTO.ItemSaldosParticipe itemSaldosParticipe : itemsSaldosParticipeProducto){
                    
                    ANEFI_Saldo_participe__c saldoParticipe = new ANEFI_Saldo_participe__c();    
                    String[] fechaDesdeArray = saldosCuentasParticipePorProductoOut.meta.fechaConsultaSaldos.split('-');
                    String[] fechaHastaArray = saldosCuentasParticipeInput.fechaHasta.split('-');
                    saldoParticipe.Capital__c = itemSaldosParticipe.capital;
                    saldoParticipe.Codigo_Cliente__c = String.valueOf(itemSaldosParticipe.codigoCliente);
                    saldoParticipe.Nombre_cliente__c = itemSaldosParticipe.nombreCliente;
                    saldoParticipe.Codigo_Trader__c = itemSaldosParticipe.codigoTrader;
                    saldoParticipe.Nombre_Trader__c = itemSaldosParticipe.nombreTrader;
                    saldoParticipe.Numero_Cuenta__c = itemSaldosParticipe.numeroCuenta;
                    saldoParticipe.Rendimiento__c = itemSaldosParticipe.rendimiento;
                    saldoParticipe.Saldo_Interes__c = itemSaldosParticipe.saldoInteres;
                    saldoParticipe.Saldo_Total__c = itemSaldosParticipe.saldoTotal;
                    saldoParticipe.Codigo_producto__c = saldosCuentasParticipeInput.codigoProducto;
                    saldoParticipe.Fecha_desde__c = Date.newInstance(Integer.valueOf(fechaDesdeArray[0]), 
                                                                     Integer.valueOf(fechaDesdeArray[1]),
                                                                     Integer.valueOf(fechaDesdeArray[2]));
                    saldoParticipe.Fecha_hasta__c = Date.newInstance(Integer.valueOf(fechaHastaArray[0]), 
                                                                     Integer.valueOf(fechaHastaArray[1]),
                                                                     Integer.valueOf(fechaHastaArray[2]));
                    
                    saldosParticipesACrear.add(saldoParticipe);                     
                } 
            }
        }
        catch(Exception e){
            system.debug('Error obteniendo saldos de partícipes por producto');
        }
        
        return saldosParticipesACrear;
    }    
    
}