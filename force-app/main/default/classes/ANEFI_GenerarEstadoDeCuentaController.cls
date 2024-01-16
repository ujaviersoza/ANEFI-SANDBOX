/*Septiembre 21 - 2020 - Julia Yaneth Barco
Clase para gestionar los métodos que permiten generar el estado de una cuenta de partícipe en Gestor
*/
public class ANEFI_GenerarEstadoDeCuentaController {  
     public class GestionarParticipeGestorException extends Exception {}
    //Parámetros enviados por URL desde el LWC de movimientos
    public String clienteId {set;get;}
    public String codigoProducto {set;get;}
    public String numeroCuentaParticipe{set;get;}
    public String numeroCodigoParticipe{set;get;}
    public String fechaDesde{set;get;}
    public String fechaCorte{set;get;}
    public Account cliente{set;get;}
    public String clienteDireccion {set;get;}
    public String cantonProvincia {set;get;}
    public ANEFI_ServicesDTO.ItemSaldoCuentaParticipe itemSaldoCuentaParticipeMesAnterior {set;get;}
    public ANEFI_ServicesDTO.ItemSaldoCuentaParticipe itemSaldoCuentaParticipeFechaCorte {set;get;}
    public List<ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe> itemsTransaccionCuentaParticipe {set;get;}
    public Decimal totalInversiones {set;get;}
    public String totalUnidadesInversiones {set;get;}
    public Decimal totalRetiros {set;get;}
    public String totalUnidadesRetiros {set;get;}
    public String fechaCorteMesAnteriorString {set;get;}
    public String saldoUnidadesMesAnterior {set;get;}
    public Decimal valorUnidadMesAnterior {set;get;}
    public String valorUnidadMesAnteriors {set;get;} 
    public String saldoTotalMesAnteriors {set;get;}       
    public Decimal saldoTotalMesAnterior {set;get;}
    public String saldoUnidadesFechaCorte {set;get;}
    public String valorUnidadFechaCortes {set;get;}    
    public Decimal valorUnidadFechaCorte {set;get;}
    public Decimal saldoTotalFechaCorte {set;get;}
    public String saldoTotalFechaCortes {set;get;}    
    public Decimal rendimientoFechaCorte {set;get;}
    public String rendimientoPeriodo {set;get;}    
    public String nombreProducto {set;get;}
    public String direccionQuito {set;get;}
    public String direccionGuayaquil {set;get;}
    public String ejecutivoCuenta {set;get;}
    public String emailANEFI {set;get;}
    public String nombreProductoParam {set;get;}
    public List<Movimiento> movimientos {set;get;}
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
    public static ANEFI_RequestsHandler requestHandler;
    public Date fechaIni {get;set;}
    public Date fechaFin {get;set;}
    
    
    public ANEFI_GenerarEstadoDeCuentaController(){
        clienteId =  ApexPages.CurrentPage().getParameters().get('clienteId');
        codigoProducto = ApexPages.CurrentPage().getParameters().get('codigoProducto');
        numeroCuentaParticipe = ApexPages.CurrentPage().getParameters().get('numeroCuentaParticipe'); 
        fechaDesde = ApexPages.CurrentPage().getParameters().get('fechaDesde');
        fechaCorte = ApexPages.CurrentPage().getParameters().get('fechaCorte');
        nombreProductoParam = ApexPages.CurrentPage().getParameters().get('nombreProducto');
        if(codigoProducto.equals('F001')){
            nombreProducto =  'Fondo De Inversión CP-1';   
        }else if(codigoProducto.equals('F002')){
            nombreProducto = 'Fondo De Inversión FS-2';
        }
        else if(codigoProducto.equals('F003')){
            nombreProducto = 'Fondo De Inversión ÓPTIMO';
        }
        else if(codigoProducto.equals('F004')){
            nombreProducto = 'Fondo De Inversión META';
        }
        else if(codigoProducto.equals('F005')){
            nombreProducto = 'Fondo De Inversión SEMILLA';
        }
        else{
            nombreProducto = nombreProductoParam;
        }      
        System.debug('fecha corte' + fechaCorte);
        System.debug('fecha fechaDesde' + fechaDesde);

        itemSaldoCuentaParticipeMesAnterior = new ANEFI_ServicesDTO.ItemSaldoCuentaParticipe();
        itemSaldoCuentaParticipeFechaCorte = new ANEFI_ServicesDTO.ItemSaldoCuentaParticipe();
        itemsTransaccionCuentaParticipe = new List<ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe>();
        totalInversiones = 0;        
        totalRetiros = 0;        
        movimientos = new List<Movimiento>();
        
        try{
            obtenerInformacionCliente();
            if(cliente != null){
                String nombreArchivo = 'Estado_De_Cuenta_'+ cliente.Name + '.pdf';
                Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+nombreArchivo); 
                obtenerParametrosANEFI();
                obtenerSaldosMesAnterior();
                obtenerSaldosFechaCorte();
                obtenerMovimientos();
                
                obtenerSaldos();
                obtenerRendimiento();
                List<ANEFI_ServicesDTO.ItemCuentaParticipe> consultarCuentasParticipeEnGestor = consultarCuentasParticipeEnGestor(clienteId,numeroCodigoParticipe);
                for(Integer i = 0;i<consultarCuentasParticipeEnGestor.size(); i ++ ){
                    if(consultarCuentasParticipeEnGestor[i].numeroCuenta ==numeroCuentaParticipe  ){
                     ejecutivoCuenta = consultarCuentasParticipeEnGestor[i].nombreTrader;
                     break;
                       
                    }
                }
                
                System.debug('consultarCuentasParticipeEnGestor' +  JSON.serialize(consultarCuentasParticipeEnGestor));
            }  
        }
        catch(Exception e){
            system.debug('Error en constructor de la clase Generar Estado de Cuenta: ' + e.getMessage());
        } 
    }
    
    /*Método para consultar la información del participe con el código de persona dado en Gestor*/
    public static List<ANEFI_ServicesDTO.ItemCuentaParticipe> consultarCuentasParticipeEnGestor(String clienteId, String codigoPersonaEnGestor){
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();        
        HttpResponse response = null;	
        ANEFI_ServicesDTO.CuentasParticipeOut cuentasParticipeOut = null;
        if(String.isBlank(codigoPersonaEnGestor) || String.isEmpty(codigoPersonaEnGestor))throw new GestionarParticipeGestorException('El código de persona en Gestor debe ser diferente de vacío');        
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);		
        if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación
            String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaCuentasParticipe');      
            if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de cuentas de partícipe');        
            URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', '-').
                replace('{codigoCliente}', codigoPersonaEnGestor);
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);         
            
            ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;    
            
            try {
                requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',null, clienteID); 
                response = requestHandlerResponse.response;
                system.debug('response: '+response.getStatusCode());
            } catch (Exception e) {
                throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
            }
            String responseBody = response.getBody();            
            Integer responseStatusCode = response.getStatusCode();  
            SysTEm.debug('response' + responseBody);
            if(responseStatusCode == 200){//El servicio retorno las cuentas de participe correctamente            
                cuentasParticipeOut = (ANEFI_ServicesDTO.CuentasParticipeOut)JSON.deserialize(responseBody, ANEFI_ServicesDTO.CuentasParticipeOut.class);            
            }
        }
        //insertar los logs
         
        if(cuentasParticipeOut != null){
            return cuentasParticipeOut.data;
        }else{
            return null;
        }
        
    }
    public void obtenerInformacionCliente(){
        List<Account> clientes = [Select Id, Name,Codigo_persona_en_Gestor__c,Owner.Name,Canton_direccion_de_trabajo__r.Nombre_canton__c,
                                  Canton_direccion_de_trabajo__r.Provincia__c, Calle_principal_direccion_trabajo__c,Numero_direccion_trabajo__c,
                                  RecordType.Name,Canton_direccion_domicilio__r.Nombre_canton__c,Canton_direccion_domicilio__r.Provincia__c,
                                  Calle_principal_direccion_domicilio__c,Referencia_direccion_domicilio__c 
                                  from Account Where Id =: clienteId];
        if(clientes.size() > 0){
            cliente = clientes.get(0); 
            numeroCodigoParticipe = cliente.Codigo_persona_en_Gestor__c;
            if(cliente.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
                clienteDireccion = cliente.Calle_principal_direccion_trabajo__c + ' ' + cliente.Numero_direccion_trabajo__c;
                cantonProvincia = cliente.Canton_direccion_de_trabajo__r.Nombre_canton__c + ' ' + cliente.Canton_direccion_de_trabajo__r.Provincia__c;
            }else if(cliente.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_NATURAL)){
                clienteDireccion = cliente.Calle_principal_direccion_domicilio__c + ' ' + cliente.Referencia_direccion_domicilio__c;
                cantonProvincia = cliente.Canton_direccion_domicilio__r.Nombre_canton__c + ' ' + cliente.Canton_direccion_domicilio__r.Provincia__c;
            }
        }        
    }
    public  void obtenerRendimiento(){
        ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario datos = new ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario();
		datos.codigoProducto  = codigoProducto;
        datos.codigoCliente = numeroCodigoParticipe;
        datos.codigoCuenta = numeroCuentaParticipe;
        datos.fechaDesde = fechaDesde;
        datos.fechaHasta = fechaCorte;   
        Decimal rendimiento = valorRendimiento(loginOUTDTO,configuracionGestorWeb, clienteId, datos, requestHandler);
        System.debug('rendimiento ' + rendimiento);
        rendimientoFechaCorte=  rendimiento;
    }
    public void obtenerSaldos(){
        ANEFI_GenerarEstadoDeCuentaController.Datos datosSaldos = new ANEFI_GenerarEstadoDeCuentaController.Datos();
        String jsonTest = '{"data": [ { "codigoProducto": "F001","nombreProducto": "FONDO DE INVERSION ADMINISTRADO DE CORTO PLAZO CP - UNO","numeroCuenta": "106701","saldosDiarios": [{"fecha": "2022-06-30","numeroUnidades": 0.71138512,"valorUnidad": 116.48647585,"valorSaldo": 82.87 }]}]}';
        requestHandler = new ANEFI_RequestsHandler(); 	
        //configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        //loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
        if(loginOUTDTO != null){//El servicio de autenticación respondió correctamente 
        ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario datos = new ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario();
		datos.codigoProducto  = codigoProducto;
        datos.codigoCliente = numeroCodigoParticipe;
        datos.codigoCuenta = numeroCuentaParticipe;
        Date fechaHastaDate =  Date.valueOf(fechaCorte).addDays(1); 
        String mes = (fechaHastaDate.Month() <= 9) ? '0'+String.valueOf(fechaHastaDate.Month()) : String.valueOf(fechaHastaDate.Month()) ;
        String dia = (fechaHastaDate.day() <= 9) ? '0'+String.valueOf(fechaHastaDate.day()) : String.valueOf(fechaHastaDate.day()) ;
        datos.fechaDesde = fechaDesde;
        datos.fechaHasta = fechaHastaDate.Year()  + '-' + mes + '-' + dia ;
        datosSaldos = !Test.isRunningTest() ? consultaSaldosCuenta(loginOUTDTO,configuracionGestorWeb, clienteId, datos, requestHandler) : (ANEFI_GenerarEstadoDeCuentaController.Datos)JSON.deserialize(jsonTest,ANEFI_GenerarEstadoDeCuentaController.Datos.class);
        Integer sizeSaldos = 0;
        Integer sizeDatosSaldos = 0;
        for(Integer i=0;i<datosSaldos.data.size();i++){
             System.debug('numeroCuenta' + datosSaldos.data[i].numeroCuenta );
             if(datosSaldos.data[i].codigoProducto == codigoProducto && datosSaldos.data[i].numeroCuenta == numeroCuentaParticipe ){
                 sizeSaldos = datosSaldos.data[i].saldosDiarios.size();
                 sizeDatosSaldos = i;
                 break;
             }   
        }
        saldoUnidadesMesAnterior = String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[0].numeroUnidades);
        
        valorUnidadMesAnteriors =  String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[0].valorUnidad);
        saldoTotalMesAnteriors = String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[0].valorSaldo);
            
		saldoUnidadesFechaCorte = String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].numeroUnidades);
        //valorUnidadFechaCorte = datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].valorUnidad;
        valorUnidadFechaCortes = String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].valorUnidad);
        //saldoTotalFechaCorte = datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].valorSaldo;
        saldoTotalFechaCortes = String.valueOf(datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].valorSaldo);
        System.debug('datos saldos ->' + datosSaldos);
        valorUnidadMesAnterior =  datosSaldos.data[sizeDatosSaldos].saldosDiarios[0].valorUnidad;      
        valorUnidadFechaCorte = datosSaldos.data[sizeDatosSaldos].saldosDiarios[sizeSaldos - 1].valorUnidad;   
        fechaIni = Date.valueOf(datos.fechaDesde);
        fechaFin = Date.valueOf(datos.fechaHasta);
        
        Integer cantidadDias = fechaFin.daysBetween(fechaIni);
        cantidadDias = (cantidadDias <0 ) ? cantidadDias * (-1) : cantidadDias;
        cantidadDias = cantidadDias -1;
        System.debug('fecha Ini'+fechaIni);
        System.debug('fecha Fin'+fechaFin);    
         
        Decimal valorRendimiento1  = (valorUnidadFechaCorte - valorUnidadMesAnterior) /valorUnidadMesAnterior;
        Decimal valorRendimiento2  =  valorRendimiento1 * 360;
        Decimal valorRendimiento3  = valorRendimiento2 / cantidadDias;            
        System.debug('valorRendimiento1'+valorRendimiento1);
        System.debug('valorRendimiento2'+valorRendimiento2); 
        System.debug('cantidadDias'+cantidadDias);  
        System.debug('valorRendimiento scale'+ valorRendimiento3.setScale(5));             
        System.debug('valorRendimiento3'+ (valorRendimiento3.setScale(5) * 100));  
        rendimientoPeriodo = String.valueOf( (valorRendimiento3.setScale(5) * 100));
        }
    }
    public void obtenerSaldosMesAnterior(){
        Date fechaCorteDate = Date.valueOf(fechaCorte).addDays(-30); 
        fechaCorteMesAnteriorString = fechaCorteDate.Year() + '-' + fechaCorteDate.Month() + '-' + fechaCorteDate.day();
        fechaCorteMesAnteriorString = fechaDesde;
        requestHandler = new ANEFI_RequestsHandler(); 	
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();                
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
        /*if(!String.isBlank(fechaCorte) && !String.isEmpty(fechaCorte)){            
            requestHandler = new ANEFI_RequestsHandler(); 	
            try{
                configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
                loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
                if(loginOUTDTO != null){//El servicio de autenticación respondió correctamente                	
                    Date fechaCorteDate = Date.valueOf(fechaCorte).addDays(-30);                    
                    fechaCorteMesAnteriorString = fechaCorteDate.Year() + '-' + fechaCorteDate.Month() + '-' + fechaCorteDate.day();
                    itemSaldoCuentaParticipeMesAnterior =  obtenerItemSaldoCuentaParticipe(fechaCorteMesAnteriorString);
                    saldoUnidadesMesAnterior = itemSaldoCuentaParticipeMesAnterior.saldoUnidades.setScale(8).toPlainString(); 
                    valorUnidadMesAnterior = itemSaldoCuentaParticipeMesAnterior.valorUnidad;
                    saldoTotalMesAnterior = itemSaldoCuentaParticipeMesAnterior.saldoTotal;
                }    
                
            }
            catch(Exception e){
                system.debug('Error obteniendo los saldos del mes anterior en la generación del estado de cuenta: ' + e.getMessage());
            }            
        }*/
    }
    
    public void obtenerSaldosFechaCorte(){        
        /*if(!String.isBlank(fechaCorte) && !String.isEmpty(fechaCorte)){      
            try{       
                itemSaldoCuentaParticipeFechaCorte =  obtenerItemSaldoCuentaParticipe(fechaCorte);  
                saldoUnidadesFechaCorte = itemSaldoCuentaParticipeFechaCorte.saldoUnidades.setScale(8).toPlainString();
                valorUnidadFechaCorte = itemSaldoCuentaParticipeFechaCorte.valorUnidad;
                saldoTotalFechaCorte = itemSaldoCuentaParticipeFechaCorte.saldoTotal;
                rendimientoFechaCorte = itemSaldoCuentaParticipeFechaCorte.rendimiento;
                
            }
            catch(Exception e){
                system.debug('Error obteniendo los saldos de la fecha de corte en la generación del estado de cuenta: ' + e.getMessage());
            }            
        }*/
    }
    /*
    public ANEFI_ServicesDTO.ItemSaldoCuentaParticipe obtenerItemSaldoCuentaParticipe(String fechaCorte){
        ANEFI_ServicesDTO.ItemSaldoCuentaParticipe itemSaldoCuentaParticipe = new ANEFI_ServicesDTO.ItemSaldoCuentaParticipe();
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = new ANEFI_ServicesDTO.MovimientosCuentaParticipeInput();
        ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut responseDataSaldosParticipeOut = null; 
        try{
            movimientosCuentaParticipeInput.codigoCliente = cliente.Codigo_persona_en_Gestor__c;
            movimientosCuentaParticipeInput.codigoProducto = codigoProducto;
            movimientosCuentaParticipeInput.fechaHasta = fechaCorte;
            movimientosCuentaParticipeInput.numeroCuenta = numeroCuentaParticipe;
            responseDataSaldosParticipeOut = ANEFI_Utilitarios.consultaSaldosCuentaParticipe(loginOUTDTO, configuracionGestorWeb, clienteId, movimientosCuentaParticipeInput, requestHandler);                    
            if(responseDataSaldosParticipeOut != null){
                List<ANEFI_ServicesDTO.ItemSaldoCuentaParticipe> itemsSaldoCuentaParticipe = responseDataSaldosParticipeOut.data.cuentasParticipe;
                System.debug('item SaldoCuentaParticipe: ' + itemsSaldoCuentaParticipe );
                if(itemsSaldoCuentaParticipe.size() > 0){
                    itemSaldoCuentaParticipe = itemsSaldoCuentaParticipe.get(0);
                }
            }
        }
        catch(Exception e){
            system.debug('Error obteniendo item de saldos de partícipe: ' + e.getMessage());
        }
        return itemSaldoCuentaParticipe;
    }    */
    
    public void guardarLogs(){
        //insertar los logs
        requestHandler.insertRequestLogs();
    }
    public static ANEFI_GenerarEstadoDeCuentaController.Datos consultaSaldosCuenta(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb,String clienteId, ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario dataSaldoDiario, ANEFI_RequestsHandler requestHandler ){
        ANEFI_GenerarEstadoDeCuentaController.Datos datosSaldos = new ANEFI_GenerarEstadoDeCuentaController.Datos();
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
        HttpResponse response = null;   
        String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('saldosDiariosPeriodo');      
        URLServicio = URLServicio.replace('{codigoCliente}', dataSaldoDiario.codigoCliente);
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> URLParams = new Map<String, String>();
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);  
        URLParams.put('fechaDesde',dataSaldoDiario.fechaDesde);
        URLParams.put('fechaHasta',dataSaldoDiario.fechaHasta);
        
        
        try {            
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
            response = requestHandlerResponse.response;       
        } catch (Exception e) {
            system.debug('No se pudo realizar la petición: ' + e.getMessage());
        }
        String responseBody = response.getBody();     
        System.debug('saldos body' + responseBody);
        Integer responseStatusCode = response.getStatusCode(); 
        datosSaldos = (ANEFI_GenerarEstadoDeCuentaController.Datos)JSON.deserialize(responseBody,ANEFI_GenerarEstadoDeCuentaController.Datos.class);                                   
        
        return datosSaldos;
    }
    public static Decimal valorRendimiento(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb,String clienteId, ANEFI_GenerarEstadoDeCuentaController.dataSaldosDiario dataSaldoDiario, ANEFI_RequestsHandler requestHandler){
		ANEFI_GenerarEstadoDeCuentaController.DatosRendimiento dt = new ANEFI_GenerarEstadoDeCuentaController.DatosRendimiento();
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
        HttpResponse response = null;   
        String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('valorRendimiento');      
        URLServicio = URLServicio.replace('{codigoProducto}', dataSaldoDiario.codigoProducto).replace('{codigoParticipe}', dataSaldoDiario.codigoCliente).
            replace('{cuentaParticipe}', dataSaldoDiario.codigoCuenta);
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> URLParams = new Map<String, String>();
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);  
        URLParams.put('fechaDesde',dataSaldoDiario.fechaDesde);
        URLParams.put('fechaHasta',dataSaldoDiario.fechaHasta);
        
        
        try {            
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
            response = requestHandlerResponse.response;       
        } catch (Exception e) {
            system.debug('No se pudo realizar la petición: ' + e.getMessage());
        }
        String responseBody = response.getBody();     
        System.debug('saldos' + responseBody);   
        dt =  (ANEFI_GenerarEstadoDeCuentaController.DatosRendimiento)JSON.deserialize(responseBody,ANEFI_GenerarEstadoDeCuentaController.DatosRendimiento.class);
        return dt.data.valorRendimiento;
    }
    public void obtenerMovimientos(){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = new ANEFI_ServicesDTO.MovimientosCuentaParticipeInput();
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = new ANEFI_ServicesDTO.MovimientosCuentaParticipeOut();
        movimientosCuentaParticipeInput.codigoCliente = cliente.Codigo_persona_en_Gestor__c;
        movimientosCuentaParticipeInput.codigoProducto = codigoProducto;
        Date fechaCorteDate = Date.valueOf(fechaCorte).addDays(-30); 
        movimientosCuentaParticipeInput.fechaDesde = fechaDesde;
        movimientosCuentaParticipeInput.fechaHasta = fechaCorte;
        movimientosCuentaParticipeInput.numeroCuenta = numeroCuentaParticipe;
        movimientosCuentaParticipeInput.pageNumber = 1;
        movimientosCuentaParticipeInput.pageSize = 50;
        movimientosCuentaParticipeInput.tipoTransaccion = '';   
        Decimal totalUnidadesRetirosTemp = 0;
        Decimal totalUnidadesInversionesTemp = 0;
        
        
        try{
            movimientosCuentaParticipeOut = obtenerMovimientosPorPagina(movimientosCuentaParticipeInput);  
            itemsTransaccionCuentaParticipe.addAll(movimientosCuentaParticipeOut.data);
            While(!String.isBlank(movimientosCuentaParticipeOut.links.next)){
                movimientosCuentaParticipeInput.pageNumber += 1;
                movimientosCuentaParticipeOut = obtenerMovimientosPorPagina(movimientosCuentaParticipeInput);
                itemsTransaccionCuentaParticipe.addAll(movimientosCuentaParticipeOut.data);
            } 
            
            for(ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe itemTransaccionCuentaParticipe : itemsTransaccionCuentaParticipe){
                //Rescates son registros donde el tipo de movimiento es igual a D 
                //Aportes son registros donde el tipo de movimiento es igual a C
                if(itemTransaccionCuentaParticipe.tipoMovimiento.equals('C')){//Es un aporte
                    totalInversiones += itemTransaccionCuentaParticipe.valorNeto;
                    totalUnidadesInversionesTemp += itemTransaccionCuentaParticipe.numeroUnidades;
                }else if(itemTransaccionCuentaParticipe.tipoMovimiento.equals('D')){//Es un rescate
                    totalRetiros += itemTransaccionCuentaParticipe.valorNeto;
                    totalUnidadesRetirosTemp += itemTransaccionCuentaParticipe.numeroUnidades;
                }
                
                Movimiento movimiento = new Movimiento();
                movimiento.fechaTransaccion = itemTransaccionCuentaParticipe.fechaTransaccion;
                movimiento.tipoMovimiento = itemTransaccionCuentaParticipe.tipoMovimiento.equals('C') ? 'Aporte' : 'Rescate';
                movimiento.valorNeto = itemTransaccionCuentaParticipe.valorNeto;
                movimiento.valorRetenciones = itemTransaccionCuentaParticipe.valorRetenciones;
                movimiento.numeroUnidades = itemTransaccionCuentaParticipe.numeroUnidades.setScale(8).toPlainString();
                movimientos.add(movimiento);
            }
            
            totalUnidadesRetiros = totalUnidadesRetirosTemp.setScale(8).toPlainString();
            totalUnidadesInversiones = totalUnidadesInversionesTemp.setScale(8).toPlainString();
        }
        catch(Exception e){
            system.debug('Error obteniendo movimientos de partícipe: ' + e.getMessage());
        }
        
    }
    
    public ANEFI_ServicesDTO.MovimientosCuentaParticipeOut obtenerMovimientosPorPagina(ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = new ANEFI_ServicesDTO.MovimientosCuentaParticipeOut();
        try{
            movimientosCuentaParticipeOut = ANEFI_Utilitarios.consultaMovimientosDeCuentaParticipe(loginOUTDTO, configuracionGestorWeb, clienteId, movimientosCuentaParticipeInput, requestHandler); 
        }
        catch(Exception e){
            system.debug('Error obteniendo movimientos por página de partícipe: ' + e.getMessage());
        }       
        
        return movimientosCuentaParticipeOut;
    }
    
    public void obtenerParametrosANEFI(){
        List<ANEFI_Parametros_Empresa__c> parametrosEmpresa = [Select Id,Name, Valor__c 
                                                               from ANEFI_Parametros_Empresa__c];        
        for(ANEFI_Parametros_Empresa__c parametroEmpresa: parametrosEmpresa){
            switch on parametroEmpresa.Name{
                when 'Direccion_Quito'{
                    direccionQuito = parametroEmpresa.Valor__c;
                }
                when 'Direccion_Guayaquil'{
                    direccionGuayaquil = parametroEmpresa.Valor__c;
                }
                when 'Email_ANEFI'{
                    emailANEFI = parametroEmpresa.Valor__c;
                }
                when else{
                    
                }
            }            
        }
    }    
    
    
    public class Movimiento{
        public String fechaTransaccion{get;set;}  
        public String tipoMovimiento{get;set;}
        public Decimal valorNeto{get;set;}
        public Decimal valorRetenciones{get;set;}
        public String numeroUnidades{get;set;}               
    }
    
    public List<Data> data;
    public class Datos{
        public List<Data> data;
        
    }
    public class DatosRendimiento {
        public Data data;
    }
    public class SaldosDiarios {
        public String fecha;
        public Double numeroUnidades;
        public Double valorUnidad;
        public Double valorSaldo;
    }
	 
    public class Data {
        public String codigoProducto;
        public String nombreProducto;
        public String numeroCuenta;
        public List<SaldosDiarios> saldosDiarios;
        public Decimal valorRendimiento;
    }
    public class dataSaldosDiario{
        public String codigoProducto;
        public String codigoCuenta;        
        public String codigoCliente;
        public String fechaDesde;
        public String fechaHasta;
    }
    
}