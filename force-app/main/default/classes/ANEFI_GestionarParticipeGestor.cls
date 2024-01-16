/**
* @description       : 
* @author            : Axel Landa
* @group             : 
* @last modified on  : 02-02-2023
* @last modified by  : Axel Landa
**/
global without sharing class ANEFI_GestionarParticipeGestor {
    
    public class GestionarParticipeGestorException extends Exception {}
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
    
    
    /*Método para consultar cliente natural en Gestor y retornar la información en caso de que exista*/
    public static ANEFI_ServicesDTO.ConsultaPersonaNatural consultarInformacionPersonaNaturalEnGestor(String clienteId){
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
        ANEFI_ServicesDTO.ConsultaPersonaNatural consultaPersonaNatural = new ANEFI_ServicesDTO.ConsultaPersonaNatural();
        consultaPersonaNatural.clienteExisteEnGestor = false;
        if(String.isBlank(clienteId) || String.isEmpty(clienteId))throw new GestionarParticipeGestorException('El Id del cliente no puede ser vacío');        
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);	
        System.debug('loginOUTDTO ' + loginOUTDTO);
        System.debug('configuracionGestorWeb' +configuracionGestorWeb);
        if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación
            ANEFI_ServicesDTO.RegistroClienteOut registroClienteOut = ANEFI_Utilitarios.validarEnRegistrosDeClientes(requestHandler,clienteId, clienteId, loginOUTDTO, configuracionGestorWeb);
            if(registroClienteOut != null){//El servicio de validación en registros de clientes se ejecutó correctamente
                if(!registroClienteOut.tipoRelacion.equals('NO_REGISTRADA')){//Cliente existe como persona en Gestor
                    consultaPersonaNatural.clienteExisteEnGestor = true;
                    //24 de Agosto: Se realiza modificación para procesar la lista de ocurrencias que retorna el servicio de Gestor
                    List<ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente> ocurrencias = registroClienteOut.ocurrencias;
                    if(ocurrencias.size() > 0){
                        ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente itemOcurrenciaRegistroCliente = ocurrencias.get(0);
                        consultaPersonaNatural.codigoPersonaEnGestor = String.valueOf(itemOcurrenciaRegistroCliente.codigoPersona);
                        consultaPersonaNatural.personaNaturalOut = obtenerInformacionPersonaNaturalEnGestor(requestHandler, clienteID, String.valueOf(itemOcurrenciaRegistroCliente.codigoPersona));       
                    }
                    
                }
            }
        }
        //insertar los logs
        requestHandler.insertRequestLogs();
        return consultaPersonaNatural;
    }
    
    /*Método para consultar cliente jurídico en Gestor y retornar la información en caso de que exista*/
    public static ANEFI_ServicesDTO.ConsultaPersonaJuridica consultarInformacionPersonaJuridicaEnGestor(String clienteId){
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
        ANEFI_ServicesDTO.ConsultaPersonaJuridica consultaPersonaJuridica = new ANEFI_ServicesDTO.ConsultaPersonaJuridica();
        consultaPersonaJuridica.clienteExisteEnGestor = false;
        if(String.isBlank(clienteId) || String.isEmpty(clienteId))throw new GestionarParticipeGestorException('El Id del cliente no puede ser vacío');        
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);		
        if(loginOUTDTO != null ){//El servicio de autenticación en Gestor retornó el token de autenticación
            ANEFI_ServicesDTO.RegistroClienteOut registroClienteOut = ANEFI_Utilitarios.validarEnRegistrosDeClientes(requestHandler,clienteId, clienteId, loginOUTDTO, configuracionGestorWeb);
            if(registroClienteOut != null){//El servicio de validación en registros de clientes se ejecutó correctamente
                if(!registroClienteOut.tipoRelacion.equals('NO_REGISTRADA')){//Cliente existe como persona en Gestor
                    consultaPersonaJuridica.clienteExisteEnGestor = true;
                    //24 de Agosto: Se realiza modificación para procesar la lista de ocurrencias que retorna el servicio de Gestor
                    List<ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente> ocurrencias = registroClienteOut.ocurrencias;
                    if(ocurrencias.size() > 0){
                        ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente itemOcurrenciaRegistroCliente = ocurrencias.get(0);
                        consultaPersonaJuridica.codigoPersonaEnGestor = String.valueOf(itemOcurrenciaRegistroCliente.codigoPersona);
                        consultaPersonaJuridica.personaJuridicaOut = obtenerInformacionPersonaJuridicaEnGestor(requestHandler, clienteID, String.valueOf(itemOcurrenciaRegistroCliente.codigoPersona));                    
                    }
                    
                }
            }
        }
        //insertar los logs
        requestHandler.insertRequestLogs();    
        System.debug('consultaPersonaJuridica json-> ' + JSON.serializePretty(consultaPersonaJuridica));
        return consultaPersonaJuridica;
    }
    
    /*Método para consultar la información de un participe de tipo persona natural*/
    public static ANEFI_ServicesDTO.PersonaNaturalOut obtenerInformacionPersonaNaturalEnGestor(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoPersonaEnGestor){
        try{
            ANEFI_ServicesDTO.PersonaNaturalOut personaNaturalOut = null;
            HttpResponse response = obtenerInformacionPersonaEnGestor(requestHandler, clienteID, codigoPersonaEnGestor, ANEFI_Utilitarios.PERSONA_NATURAL);
            
            if(response != null){
                String responseBody = response.getBody();        
                Integer responseStatusCode = response.getStatusCode();               
                if(responseStatusCode == 200){//El servicio retornó la información de la persona natural correctamente
                    
                    ANEFI_ServicesDTO.ResponseDataPersonaNaturalOut responseDataPersonaNaturalOut = (ANEFI_ServicesDTO.ResponseDataPersonaNaturalOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataPersonaNaturalOut.class);                
                    personaNaturalOut = responseDataPersonaNaturalOut.data;
                }                
            }            
            return personaNaturalOut;                      
        }
        catch(Exception e){
            throw new GestionarParticipeGestorException('No se pudo consultar la información de la persona natural: ' + e.getMessage());
        }        
    }
    
    /*Método para consultar la información de un participe de tipo persona jurídica*/
    public static ANEFI_ServicesDTO.PersonaJuridicaOut obtenerInformacionPersonaJuridicaEnGestor(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoPersonaEnGestor){
        try{
            ANEFI_ServicesDTO.PersonaJuridicaOut personaJuridicaOut = null;
            HttpResponse response = obtenerInformacionPersonaEnGestor(requestHandler, clienteID, codigoPersonaEnGestor, ANEFI_Utilitarios.PERSONA_JURIDICA);
            
            if(response != null){
                String responseBody = response.getBody();        
                Integer responseStatusCode = response.getStatusCode();                
                if(responseStatusCode == 200){//El servicio retornó la información de la persona jurídica correctamente                
                    ANEFI_ServicesDTO.ResponseDataPersonaJuridicaOut responseDataPersonaJuridicaOut = (ANEFI_ServicesDTO.ResponseDataPersonaJuridicaOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataPersonaJuridicaOut.class);
                    System.debug('data ->>>>>' + responseDataPersonaJuridicaOut.data);
                    personaJuridicaOut = responseDataPersonaJuridicaOut.data;             
                } 
            }            
            return personaJuridicaOut;
        }
        catch(Exception e){
            throw new GestionarParticipeGestorException('No se pudo consultar la información de la persona jurídica: ' + e.getMessage());
        }        
    }
    
    /*Método para consultar la información del participe con el código de persona dado en Gestor*/
    public static HttpResponse obtenerInformacionPersonaEnGestor(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoPersonaEnGestor, String tipoPersona){
        HttpResponse response = null;        
        if(String.isBlank(codigoPersonaEnGestor) || String.isEmpty(codigoPersonaEnGestor))throw new GestionarParticipeGestorException('El código de persona en Gestor debe ser diferente de vacío');        
        
        String URLServicio = '';
        //Se valida el tipo de persona para determinar cuál servicio invocar
        if(tipoPersona.equals(ANEFI_Utilitarios.PERSONA_NATURAL)){
            URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaPersonaNatural');
        }
        else{
            URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaPersonaJuridica');
        }
        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de información persona');        
        URLServicio = URLServicio.replace('{codigoPersona}', codigoPersonaEnGestor);
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);         
        
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;     
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',null, clienteID); 
            response = requestHandlerResponse.response;
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            
        } catch (Exception e) {
            throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
        }       
        return response;
    }
    
    /*Método para consultar la información del participe con el código de persona dado en Gestor*/
    public static List<ANEFI_ServicesDTO.ItemCuentaParticipe> consultarCuentasDeParticipeEnGestor(String clienteId, String codigoPersonaEnGestor){
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
        requestHandler.insertRequestLogs();
        if(cuentasParticipeOut != null){
            return cuentasParticipeOut.data;
        }else{
            return null;
        }
        
    }
    
    /*Método para realizar la consulta inicial de los movimientos de una cuenta de participe*/
    public static ANEFI_ServicesDTO.MovimientosCuentaParticipeOut consultaMovimientosDeCuentaParticipe(String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = null;        
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
        try{
            if(movimientosCuentaParticipeInput == null || String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
               || String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) || 
               String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) || String.isBlank(movimientosCuentaParticipeInput.codigoCliente))
                throw new GestionarParticipeGestorException('Se debe ingresar un código de cliente y un código de producto');         
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
            
            if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación
                
                String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaMovimientosParticipe');      
                if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de movimientos de cuenta de partícipe');        
                URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto).
                    replace('{codigoCliente}', movimientosCuentaParticipeInput.codigoCliente);
                String endpoint = configuracionGestorWeb.URL__c + URLServicio;
                Map<String,String> URLParams = new Map<String, String>();
                
                if(!String.isBlank(movimientosCuentaParticipeInput.fechaDesde) && !String.isEmpty(movimientosCuentaParticipeInput.fechaDesde)){
                    URLParams.put('fechaDesde',movimientosCuentaParticipeInput.fechaDesde);
                }
                
                if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
                    URLParams.put('fechaHasta',movimientosCuentaParticipeInput.fechaHasta);
                }
                
                if(!String.isBlank(movimientosCuentaParticipeInput.numeroCuenta) && !String.isEmpty(movimientosCuentaParticipeInput.numeroCuenta)){
                    URLParams.put('numeroCuenta',movimientosCuentaParticipeInput.numeroCuenta);
                }  
                
                URLParams.put('page[number]', String.valueOf(movimientosCuentaParticipeInput.pageNumber));
                URLParams.put('page[size]',  String.valueOf(movimientosCuentaParticipeInput.pageSize));
                
                if(!String.isBlank(movimientosCuentaParticipeInput.tipoTransaccion) && !String.isEmpty(movimientosCuentaParticipeInput.tipoTransaccion)){
                    URLParams.put('tipoTransaccion',movimientosCuentaParticipeInput.tipoTransaccion);
                }                
                movimientosCuentaParticipeOut = obtenerMovimientosDeCuentaParticipePorPagina(requestHandler, endpoint, clienteId, URLParams);                               
            }            
        }
        catch(Exception e){
            system.debug('Error consultando los movimientos de cuenta de participe: ' + e.getMessage());
        }
        //insertar los logs
        requestHandler.insertRequestLogs();
        return movimientosCuentaParticipeOut;
    } 
    
    /*Método para obtener los movimientos de una cuenta de participe por página*/
    public static ANEFI_ServicesDTO.MovimientosCuentaParticipeOut obtenerMovimientosDeCuentaParticipePorPagina(ANEFI_RequestsHandler requestHandler, String endpoint, String clienteId, Map<String,String> URLParams ){
        HttpResponse response = null;	
        if(configuracionGestorWeb == null){
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb(); 
        }
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);    
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = null;
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;     
        
        try {            
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
            response = requestHandlerResponse.response;       
        } catch (Exception e) {
            throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
        }
        String responseBody = response.getBody();      
        Integer responseStatusCode = response.getStatusCode();   
        if(responseStatusCode == 200){
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            movimientosCuentaParticipeOut = (ANEFI_ServicesDTO.MovimientosCuentaParticipeOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.MovimientosCuentaParticipeOut.class);                                   
        }       
        return movimientosCuentaParticipeOut;        
    }
    
    /*Método para realizar consulta de información adicional de cuenta de participe*/
    public static ANEFI_ServicesDTO.InformacionAdicionalCuenta consultaInformacionAdicionalCuenta(String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput){
        ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut responseDataSaldosParticipeOut = null; 
        ANEFI_ServicesDTO.ValorRendimientoCuentaOut valorRendimientoCuentaOut = null;
        ANEFI_ServicesDTO.InformacionAdicionalCuenta informacionAdicionalCuenta = null;
        ANEFI_ServicesDTO.PorcentajeRendimientoProductoOut porcentajeRendimientoProductoOut = null;
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();        
        try{
            if(movimientosCuentaParticipeInput == null || String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
               || String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) || 
               String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) || String.isBlank(movimientosCuentaParticipeInput.codigoCliente))
                throw new GestionarParticipeGestorException('Se debe ingresar un código de cliente y un código de producto');         
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
            
            if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación                
                //Se invoca servicio de consulta de saldos
                responseDataSaldosParticipeOut = consultaSaldosCuentaParticipe(clienteId, movimientosCuentaParticipeInput, requestHandler); 
                if(responseDataSaldosParticipeOut != null){
                    informacionAdicionalCuenta = new ANEFI_ServicesDTO.InformacionAdicionalCuenta();
                    informacionAdicionalCuenta.cuentasParticipe = responseDataSaldosParticipeOut.data.cuentasParticipe;
                    informacionAdicionalCuenta.fechaConsultaSaldo = responseDataSaldosParticipeOut.data.fechaConsultaSaldo;
                    // Se comenta este código ya que solicitaron no mostrar información de rendimiento de cuenta y rendimiento de producto en esta pantalla
                    /*valorRendimientoCuentaOut = consultaRendimientoCuentaParticipe(clienteId, movimientosCuentaParticipeInput, requestHandler);
if(valorRendimientoCuentaOut != null){
informacionAdicionalCuenta.valorRendimiento = valorRendimientoCuentaOut.data.valorRendimiento;
porcentajeRendimientoProductoOut = consultaRendimientoProducto(clienteId, movimientosCuentaParticipeInput, requestHandler);
if(porcentajeRendimientoProductoOut != null){
informacionAdicionalCuenta.porcentajeRendimientoProducto = porcentajeRendimientoProductoOut.data.porcentajeRendimiento;
}
} */                
                }                
            }            
        }
        catch(Exception e){
            system.debug('Error consultando información adicional de cuenta de participe: ' + e.getMessage());
        }
        //insertar los logs
        requestHandler.insertRequestLogs();
        return informacionAdicionalCuenta;
    }
    
    /*Método para realizar la consulta de saldos de cuenta de participe*/
    public static ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut consultaSaldosCuentaParticipe(String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput, ANEFI_RequestsHandler requestHandler){
        ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut responseDataSaldosParticipeOut = null;     
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
        HttpResponse response = null;
        try{
            if(movimientosCuentaParticipeInput == null || String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
               || String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) || 
               String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) || String.isBlank(movimientosCuentaParticipeInput.codigoCliente))
                throw new GestionarParticipeGestorException('Se debe ingresar un código de cliente y un código de producto');            
            
            String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaSaldosParticipe');      
            if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de movimientos de cuenta de partícipe');        
            URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto).
                replace('{codigoCliente}', movimientosCuentaParticipeInput.codigoCliente);
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;
            Map<String,String> URLParams = new Map<String, String>();           
            
            if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
                URLParams.put('fechaCorte',movimientosCuentaParticipeInput.fechaHasta);
            }
            
            if(!String.isBlank(movimientosCuentaParticipeInput.numeroCuenta) && !String.isEmpty(movimientosCuentaParticipeInput.numeroCuenta)){
                URLParams.put('numeroCuenta',movimientosCuentaParticipeInput.numeroCuenta);
            }
            
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);                 
            try {            
                requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
                response = requestHandlerResponse.response;       
            } catch (Exception e) {
                throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
            }
            String responseBody = response.getBody();      
            Integer responseStatusCode = response.getStatusCode();  
            if(responseStatusCode == 200){
                if(requestHandlerResponse.loginOUT != null){
                    loginOUTDTO = requestHandlerResponse.loginOUT;
                }
                responseDataSaldosParticipeOut = (ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut.class);                                               
            }                                       
            
        }
        catch(Exception e){
            system.debug('Error consultando los saldos de cuenta de participe: ' + e.getMessage());
        }                
        return responseDataSaldosParticipeOut;
    }
    
    /*jbarco - 01-09-2020 se comenta este código por que aún no se necesita utilizar estos servicios*/
    /*Método para realizar la consulta de rendimiento de una cuenta de partícipe*/
    /*
public static ANEFI_ServicesDTO.ValorRendimientoCuentaOut consultaRendimientoCuentaParticipe(String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput, ANEFI_RequestsHandler requestHandler){
ANEFI_ServicesDTO.ValorRendimientoCuentaOut valorRendimientoCuentaOut = null;        
ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
HttpResponse response = null;        
try{
if(movimientosCuentaParticipeInput == null || String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
|| String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) || 
String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) || String.isBlank(movimientosCuentaParticipeInput.codigoCliente))
throw new GestionarParticipeGestorException('Se debe ingresar un código de cliente y un código de producto');           

String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaRendimientoCuenta');      
if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de movimientos de cuenta de partícipe');        
URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto).
replace('{codigoCliente}', movimientosCuentaParticipeInput.codigoCliente).
replace('{numeroCuenta}', movimientosCuentaParticipeInput.numeroCuenta);
String endpoint = configuracionGestorWeb.URL__c + URLServicio;
Map<String,String> URLParams = new Map<String, String>();           

if(!String.isBlank(movimientosCuentaParticipeInput.fechaDesde) && !String.isEmpty(movimientosCuentaParticipeInput.fechaDesde)){
URLParams.put('fechaDesde',movimientosCuentaParticipeInput.fechaDesde);
}

if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
URLParams.put('fechaHasta',movimientosCuentaParticipeInput.fechaHasta);
}  


Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);                 
try {            
requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
response = requestHandlerResponse.response;       
} catch (Exception e) {
throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
}
String responseBody = response.getBody();      
Integer responseStatusCode = response.getStatusCode();  
if(responseStatusCode == 200){
if(requestHandlerResponse.loginOUT != null){
loginOUTDTO = requestHandlerResponse.loginOUT;
}
valorRendimientoCuentaOut = (ANEFI_ServicesDTO.ValorRendimientoCuentaOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ValorRendimientoCuentaOut.class);                                                  
}               
}
catch(Exception e){
system.debug('Error consultando el valor de rendimiento de la cuenta de participe: ' + e.getMessage());
}      

return valorRendimientoCuentaOut;
}*/
    
    
    /*Método para realizar la consulta de rendimiento de un producto*/
    /*public static ANEFI_ServicesDTO.PorcentajeRendimientoProductoOut consultaRendimientoProducto(String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput, ANEFI_RequestsHandler requestHandler){
ANEFI_ServicesDTO.PorcentajeRendimientoProductoOut porcentajeRendimientoProductoOut = null;        
ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
HttpResponse response = null;        
try{
if(movimientosCuentaParticipeInput == null || String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
|| String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) || 
String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) || String.isBlank(movimientosCuentaParticipeInput.codigoCliente))
throw new GestionarParticipeGestorException('Se debe ingresar un código de cliente y un código de producto');           

String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaRendimientoProducto');      
if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de movimientos de cuenta de partícipe');        
URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto);
String endpoint = configuracionGestorWeb.URL__c + URLServicio;
Map<String,String> URLParams = new Map<String, String>();           

if(!String.isBlank(movimientosCuentaParticipeInput.fechaDesde) && !String.isEmpty(movimientosCuentaParticipeInput.fechaDesde)){
URLParams.put('fechaDesde',movimientosCuentaParticipeInput.fechaDesde);
}

if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
URLParams.put('fechaHasta',movimientosCuentaParticipeInput.fechaHasta);
}             

Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);                 
try {            
requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
response = requestHandlerResponse.response;       
} catch (Exception e) {
throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
}
String responseBody = response.getBody();      
Integer responseStatusCode = response.getStatusCode();  
if(responseStatusCode == 200){
if(requestHandlerResponse.loginOUT != null){
loginOUTDTO = requestHandlerResponse.loginOUT;
}
porcentajeRendimientoProductoOut = (ANEFI_ServicesDTO.PorcentajeRendimientoProductoOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.PorcentajeRendimientoProductoOut.class);                                                  
}               
}
catch(Exception e){
system.debug('Error consultando el porcentaje de rendimiento del producto: ' + e.getMessage());
}      

return porcentajeRendimientoProductoOut;
}*/
    
    /*Método para actualizar persona en Gestor*/
    public static String actualizarPersonaEnGestor(String clienteId, String clienteCodigoGestor){       
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler(); 
        ANEFI_PostRequestData postRequestData = null;
        
        String codigoRespuestaActualizacionPersona = null;
        Contact contactRl;
        try{
            List<Account> clientes = [Select Id, recordType.Name,Representante_Legal__c	 from Account where Id =: clienteId];
            Account cliente = clientes.get(0);
            List<Contact> contactos = new List<Contact>();
            contactos = [Select id, name,Codigo_persona_en_Gestor__c,Enviado_a_Gestor__c from contact where id =: cliente.Representante_Legal__c];                
            
            
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
            System.debug('login' +loginOUTDTO);
            if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación                
                if(contactos.size () > 0 ){
                    System.debug('llamada a registro de  representante legal' + requestHandler);
                    if(!contactos[0].Enviado_a_Gestor__c){
                        ANEFI_ServicesDTO.RegistroPersonaOut registroPersonaOut = crearPersonaRlEnGestor(requestHandler,loginOUTDTO,contactos[0].Id);
                        System.debug('registro persona out' + registroPersonaOut);
                        if(registroPersonaOut != null){//La persona se creó correctamente en Gestor
                            contactRl = new Contact(Id=contactos[0].id, Codigo_persona_en_Gestor__c = String.valueOf(registroPersonaOut.codigoPersona), Enviado_a_Gestor__c = true);
                            
                            
                        }else{
                            return null;
                        }                        
                    }
                    
                }
                //Se invoca servicio de actualización de persona en Gestor
                codigoRespuestaActualizacionPersona = actualizarPersonaEnGestor(requestHandler,clientes[0].id,clienteCodigoGestor,clienteId,loginOUTDTO, configuracionGestorWeb); 
                
            }     
        }
        catch(Exception e){
            system.debug('Error actualizando persona en Gestor: ' + e.getMessage());
            system.debug('Error actualizando persona en Gestor: ' + e.getLineNumber());
            
        }
        
        
        if(contactRl != null){
            update contactRL; 
        }
        //insertar los logs
        requestHandler.insertRequestLogs();
        return codigoRespuestaActualizacionPersona;
    } 
    
    /*Método para crear referencia bancaria en Gestor*/
    public static String crearReferenciaBancariaEnGestor(String clienteId, String clienteCodigoGestor, String accion, ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput){       
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler(); 
        String codigoRespuestaCreacionReferencia = null;
        String idEntidadFinanciera = '';
        String metodoHTTP = '';
        try{
            if(registroReferenciaBancariaInput == null || String.isBlank(registroReferenciaBancariaInput.codigoEntidadFinanciera)
               || String.isEmpty(registroReferenciaBancariaInput.numeroCuenta) || 
               String.isEmpty(registroReferenciaBancariaInput.codigoTipoCuenta) || String.isBlank(registroReferenciaBancariaInput.codigoMoneda))
                throw new GestionarParticipeGestorException('Se debe seleccionar la entidad financiera, el número de cuenta,el tipo de cuenta y la moneda para crear una referencia bancaria');  
            //Se obtienen los datos de la entidad finaciera seleccionada
            List<ANEFI_Entidad_financiera__c> entidadesFinancieras = [Select Id,Tipo_de_entidad__c, Name FROM ANEFI_Entidad_financiera__c
                                                                      Where Id =: registroReferenciaBancariaInput.codigoEntidadFinanciera];
            
            
            if(entidadesFinancieras.size() == 0)throw new GestionarParticipeGestorException('No existe información en el sistema para la entidad financiera seleccionada');      
            idEntidadFinanciera = registroReferenciaBancariaInput.codigoEntidadFinanciera;
            registroReferenciaBancariaInput.codigoEntidadFinanciera = entidadesFinancieras.get(0).Name;
            registroReferenciaBancariaInput.codigoTipoEntidadFinanciera = String.valueOf(entidadesFinancieras.get(0).Tipo_de_entidad__c);            
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
            
            if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación                
                //Se realiza la invocación al servicio de crear referencia bancaria
                String URLServicio = '';
                ANEFI_PostRequestData postRequestData = null;
                if(accion.equals('crearReferenciaBancaria')){
                    URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registrarReferenciaBancaria');
                    if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de creación de referencia bancaria');
                    URLServicio = URLServicio.replace('{codigoPersona}', clienteCodigoGestor);
                    metodoHTTP = 'POST';
                    postRequestData =  new ANEFI_PostRequestData(registroReferenciaBancariaInput);
                }
                else if(accion.equals('actualizarReferenciaBancaria')){
                    URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarReferenciaBancaria');
                    if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de actualización de referencia bancaria');
                    URLServicio = URLServicio.replace('{codigoPersona}', clienteCodigoGestor).replace('{numeroCuenta}', registroReferenciaBancariaInput.numeroCuenta);
                    metodoHTTP = 'PUT';
                    postRequestData =  new ANEFI_PostRequestData(ANEFI_SerializadorService.obtInputActualizacionReferenciaBancaria(registroReferenciaBancariaInput));
                }                
                
                String endpoint = configuracionGestorWeb.URL__c + URLServicio;
                Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);               
                String body = JSON.serialize(postRequestData,true);                
                ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
                HttpResponse response = null;
                
                try {
                    requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, metodoHTTP ,null, clienteId); 
                    response = requestHandlerResponse.response;
                    
                } catch (Exception e) {
                    throw new GestionarParticipeGestorException('No se pudo realizar la petición de creación/actualización de referencia bancaria: ' + e.getMessage());
                }                
                
                String responseBody = response.getBody();               
                Integer responseStatusCode = response.getStatusCode();   
                if(responseStatusCode == 201 || responseStatusCode == 204){                    		            
                    codigoRespuestaCreacionReferencia = String.valueOf(responseStatusCode);
                    ANEFI_Utilitarios.actualizarReferenciaBancariaDeCliente(clienteId, idEntidadFinanciera, registroReferenciaBancariaInput.codigoTipoCuenta, registroReferenciaBancariaInput.numeroCuenta);                    
                }  
                else{
                    codigoRespuestaCreacionReferencia = responseBody;
                }
            }            
        }
        catch(Exception e){
            system.debug('Error creando referencia bancaria de persona en Gestor: ' + e.getMessage());
        }
        //insertar los logs
        requestHandler.insertRequestLogs();
        return codigoRespuestaCreacionReferencia;
    }
    
    public static ANEFI_ServicesDTO.RegistroPersonaOut crearPersonaRlEnGestor(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.LoginOUT loginOUTDTO,String contactId){
        String URLServicio = '';
         
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroPersonaNatural');     
        
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
         
        String endpoint = Test.isRunningTest() ? 'http://8.242.216.210:8100/gw/personas/natural' : configuracionGestorWeb.URL__c + URLServicio;
         
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
        ANEFI_PostRequestData postRequestData = null;
         
        ANEFI_ServicesDTO.RegistroPersonaNaturalInput registroPersonaNaturalInputDTO = inputRegistroRepresentanteLegal(contactId);      
                 
        postRequestData = new ANEFI_PostRequestData(registroPersonaNaturalInputDTO);            
        
        String body = JSON.serialize(postRequestData, true);
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
        HttpResponse response = null;
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, contactId); 
            System.debug('respuesta servicio ' + requestHandlerResponse.response );
            response = requestHandlerResponse.response;
            
        } catch (Exception e) {
            system.debug('No se pudo realizar la petición: '+e.getMessage());                    
            
        }
        
        String responseBody = response.getBody();  
        System.debug('respuesta servicio ' + responseBody );
        
        Integer responseStatusCode = response.getStatusCode();   
        if(responseStatusCode == 201){
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            ANEFI_ServicesDTO.ResponseDataRegistroPersonaOut responseDataRegistroPersonaOut = (ANEFI_ServicesDTO.ResponseDataRegistroPersonaOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataRegistroPersonaOut.class);
            return responseDataRegistroPersonaOut.data;
        }else{
            return null;
        }
    }
    /**Método para obtener el input del servicio de creación de persona Natural*/
    public static ANEFI_ServicesDTO.RegistroPersonaNaturalInput inputRegistroRepresentanteLegal(Id clienteId){
        System.debug('inputRegistroRepresentanteLegal');
        List<Contact> contactoRL  = [Select id,FirstName,MiddleName,LastName,Rol_en_la_empresa__c,Nombre_empresa_donde_trabaja__c,
                                     MobilePhone,email,Salario_mensual__c,
                                     Name, Tipo_de_identificacion__c, Numero_de_identificacion__c, 
                                     Codigo_pais_nacionalidad__c, Paga_impuestos__c, 
                                     Codigo_pais_de_nacimiento__c, Codigo_provincia_de_nacimiento__c, 
                                     Secuencia_canton_de_nacimiento__c, Codigo_canton_nacimiento__c, Fecha_de_nacimiento__c, 
                                     Estado_civil__c, Genero__c, Codigo_pais_direccion_domicilio__c, 
                                     Codigo_canton_direccion_domicilio__c, Secuencia_canton_direccion_domicilio__c, 
                                     Codigo_provincia_direccion_domicilio__c, Calle_principal_direccion_domicilio__c, 
                                     Referencia_direccion_domicilio__c, Telefono_domicilio__c, 
                                     Es_direccion_fiscal_direccion_domicilio__c, Tipo_de_empleo__c, 
                                     Codigo_actividad_economica__c, Politicamente_expuesto__c, Phone, Total_activos__c, 
                                     Total_pasivos__c, Total_patrimonio__c, Total_gastos__c, Entidad_financiera__c, 
                                     Entidad_Financiera__r.Tipo_de_entidad__c,Entidad_Financiera__r.Name, 
                                     Numero_de_cuenta_bancaria__c, Tipo_de_cuenta_bancaria__c,title
                                     
                                     from Contact where id =: clienteId ];
        
        System.debug('representante legal' +contactoRL);
        if(contactoRL.size() > 0){
            String[] apellidos = null;
            String segundoApellido  = null;
            apellidos = contactoRL[0].LastName.Split(' ');
            for(integer i=1;i<apellidos.size();i++){
                System.debug('apellidos[i]' +apellidos[i]);
                System.debug('i' + i);
                if(i == 1 ){
                    segundoApellido = apellidos[i] ;
                }else{
                    segundoApellido = segundoApellido+ ' ' + apellidos[i] ;
                }
                
                
            }
            ANEFI_ServicesDTO.NombresApellidosClienteNatural nombresApellidosClienteNatural = new ANEFI_ServicesDTO.NombresApellidosClienteNatural(); 
            
            //Existe un contacto asociado al cliente de tipo persona natural
            
            nombresApellidosClienteNatural.primerApellido = apellidos != null ? apellidos[0]: '';
            nombresApellidosClienteNatural.primerNombre = contactoRL[0].FirstName;
            nombresApellidosClienteNatural.segundoApellido = segundoApellido  != null  ? segundoApellido : ' ';
            nombresApellidosClienteNatural.segundoNombre = contactoRL[0].MiddleName; 
            
            ANEFI_ServicesDTO.RegistroPersonaNaturalInput registroPersonaNaturalInput = new ANEFI_ServicesDTO.RegistroPersonaNaturalInput();
            registroPersonaNaturalInput.callePrincipalDireccionDomicilio = contactoRL[0].Calle_principal_direccion_domicilio__c;
            registroPersonaNaturalInput.cargo = contactoRL[0].Rol_en_la_empresa__c;
            registroPersonaNaturalInput.codigoCantonDireccionDomicilio = contactoRL[0].Codigo_canton_direccion_domicilio__c;
            registroPersonaNaturalInput.codigoCantonNacimiento = contactoRL[0].Codigo_canton_nacimiento__c;
            registroPersonaNaturalInput.codigoEntidadFinancieraCuentaBancaria = contactoRL[0].Entidad_financiera__c != null ? contactoRL[0].Entidad_Financiera__r.Name : '';
            registroPersonaNaturalInput.codigoEstadoCivil = contactoRL[0].Estado_civil__c;
            registroPersonaNaturalInput.codigoPaisDireccionDomicilio = contactoRL[0].Codigo_pais_direccion_domicilio__c;
            registroPersonaNaturalInput.codigoPaisNacimiento = contactoRL[0].Codigo_pais_de_nacimiento__c;
            registroPersonaNaturalInput.codigoPaisNacionalidad = contactoRL[0].Codigo_pais_nacionalidad__c;
            registroPersonaNaturalInput.codigoProvinciaDireccionDomicilio = contactoRL[0].Codigo_provincia_direccion_domicilio__c;
            registroPersonaNaturalInput.codigoProvinciaNacimiento = contactoRL[0].Codigo_provincia_de_nacimiento__c;
            registroPersonaNaturalInput.codigoTipoActividadEconomica = contactoRL[0].Codigo_actividad_economica__c;
            registroPersonaNaturalInput.codigoTipoCuentaBancaria = contactoRL[0].Tipo_de_cuenta_bancaria__c;
            registroPersonaNaturalInput.codigoTipoDireccionDomicilio = 'D'; //Dirección tipo domicilio
            registroPersonaNaturalInput.codigoTipoEmpleo = contactoRL[0].Tipo_de_empleo__c;
            registroPersonaNaturalInput.codigoTipoEntidadFinancieraCuentaBancaria = contactoRL[0].Entidad_financiera__c != null ? String.valueOf(contactoRL[0].Entidad_Financiera__r.Tipo_de_entidad__c) : '';
            registroPersonaNaturalInput.codigoTipoIdentificacion = contactoRL[0].Tipo_de_identificacion__c;
            registroPersonaNaturalInput.codigoTipoTelefonoCelular = '3'; //Tipo de teléfono celular
            registroPersonaNaturalInput.codigoTipoTelefonoDomicilio = '1'; //Tipo de teléfono domicilio
            registroPersonaNaturalInput.codigoTipoTelefonoOficina = '2'; //Tipo de teléfono trabajo
            registroPersonaNaturalInput.codigoTotalActivo = '010'; //Valor por defecto para activos
            registroPersonaNaturalInput.codigoTotalPasivo = '011'; //Valor por defecto para pasivos
            //registroPersonaNaturalInput.correoElectronico =  String.valueOf(contactoRL[0].email);
            registroPersonaNaturalInput.esDireccionFiscalDireccionDomicilio = contactoRL[0].Es_direccion_fiscal_direccion_domicilio__c;
            Datetime fechaDateTime = contactoRL[0].Fecha_de_nacimiento__c;
            registroPersonaNaturalInput.fechaNacimiento = Test.isRunningTest() ? '1993-06-06' : contactoRL[0].Fecha_de_nacimiento__c.Year() + '-' + contactoRL[0].Fecha_de_nacimiento__c.Month() + '-' + contactoRL[0].Fecha_de_nacimiento__c.Day();//fechaDateTime.format('yyyy-MM-dd');
            registroPersonaNaturalInput.genero = contactoRL[0].Genero__c;
            registroPersonaNaturalInput.identificacion = contactoRL[0].Numero_de_identificacion__c;
            registroPersonaNaturalInput.lugarTrabajo = contactoRL[0].Nombre_empresa_donde_trabaja__c;
            registroPersonaNaturalInput.numeroCuentaBancaria = contactoRL[0].Numero_de_cuenta_bancaria__c;
            registroPersonaNaturalInput.primerNombre = nombresApellidosClienteNatural.primerNombre;
            registroPersonaNaturalInput.primerApellido = nombresApellidosClienteNatural.primerApellido;
            registroPersonaNaturalInput.pagaImpuestos = contactoRL[0].Paga_impuestos__c;
            registroPersonaNaturalInput.politicamenteExpuesto = contactoRL[0].Politicamente_expuesto__c;
            registroPersonaNaturalInput.referenciaDireccionDomicilio = contactoRL[0].Referencia_direccion_domicilio__c;
            registroPersonaNaturalInput.segundoNombre = nombresApellidosClienteNatural.segundoNombre;
            registroPersonaNaturalInput.segundoApellido = nombresApellidosClienteNatural.segundoApellido;
            registroPersonaNaturalInput.secuenciaProvinciaNacimiento = 1;//es la secuencia por defecto de las provincias
            registroPersonaNaturalInput.secuenciaCantonNacimiento = Integer.valueOf(contactoRL[0].Secuencia_canton_de_nacimiento__c);
            registroPersonaNaturalInput.secuenciaProvinciaDireccionDomicilio = 1;
            registroPersonaNaturalInput.secuenciaCantonDireccionDomicilio = Integer.valueOf(contactoRL[0].Secuencia_canton_direccion_domicilio__c);
            registroPersonaNaturalInput.telefonoCelular = contactoRL[0].MobilePhone;
            registroPersonaNaturalInput.telefonoDomicilio = contactoRL[0].Telefono_domicilio__c;
            registroPersonaNaturalInput.telefonoOficina = contactoRL[0].Phone;
            registroPersonaNaturalInput.totalActivos = contactoRL[0].Total_activos__c;
            registroPersonaNaturalInput.totalPasivos = contactoRL[0].Total_pasivos__c;
            registroPersonaNaturalInput.totalPatrimonio = contactoRL[0].Total_patrimonio__c;
            registroPersonaNaturalInput.valorIngresosSueldoMensual = contactoRL[0].Salario_mensual__c;
            registroPersonaNaturalInput.valorGastoMensual = contactoRL[0].Total_gastos__c;            
            return registroPersonaNaturalInput;            
        }
        return null;        
    }   
    /*Método que envía petición de actualización de persona en Gestor*/
    public static String actualizarPersonaEnGestor(ANEFI_RequestsHandler requestHandler, String clienteId, String codigoPersonaGestor, String relatedObjectId, ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb){
        String URLServicio = ''; 
        Account clienteAActualizar = null;
        List<Account> clientes = [Select Id, recordType.Name from Account where Id =: clienteId];
        if(clientes.size() >0 ){
            clienteAActualizar = clientes.get(0);            
            if(clienteAActualizar.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
                URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaJuridica');
            }
            else{
                URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaNatural');  
            }    
            
            
            if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                URLServicio = URLServicio.replace('{codigoPersona}', codigoPersonaGestor);
                String endpoint = configuracionGestorWeb.URL__c + URLServicio;                
                Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
                ANEFI_PostRequestData postRequestData = null;
                if(clienteAActualizar.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
                    ANEFI_ServicesDTO.ActualizarPersonaJuridicaInput actualizarPersonaJuridicaInput = obtInputActualizacionPersonaJuridica(clienteId);
                    postRequestData = new ANEFI_PostRequestData(actualizarPersonaJuridicaInput);
                }
                else{
                    ANEFI_ServicesDTO.ActualizarPersonaNaturalInput actualizarPersonaNaturalInput = ANEFI_SerializadorService.obtInputActualizacionPersonaNatural(clienteId);      
                    postRequestData = new ANEFI_PostRequestData(actualizarPersonaNaturalInput);
                    
                }
                String body = JSON.serialize(postRequestData, true);                
                ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
                HttpResponse response = null;
                
                try {                    
                    requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'PUT',null, relatedObjectId); 
                    response = requestHandlerResponse.response;                    
                } catch (Exception e) {
                    system.debug('No se pudo realizar la petición de actualización de persona en Gestor: ' + e.getMessage());            
                }
                
                String responseBody = response.getBody();        
                Integer responseStatusCode = response.getStatusCode();                
                if(responseStatusCode == 204){
                    if(requestHandlerResponse.loginOUT != null){
                        loginOUTDTO = requestHandlerResponse.loginOUT;
                    }                
                    return String.valueOf(responseStatusCode);
                }else{
                    return null;
                }
            } 
        }          
        return null;
    }
    /**Método para obtener el input del servicio de actualizacion de persona Jurídica*/
    public static ANEFI_ServicesDTO.ActualizarPersonaJuridicaInput obtInputActualizacionPersonaJuridica(Id clienteId){
        List<Account> clientes = [Select Id, Capital_social__c, Calle_principal_direccion_tributaria__c, 
                                  Calle_principal_direccion_trabajo__c, Cargo_representante_legal__c, 
                                  Codigo_canton_direccion_trabajo__c, Codigo_canton_direccion_tributaria__c, 
                                  Codigo_pais_direccion_tributaria__c, Codigo_pais_direccion_trabajo__c, 
                                  Codigo_pais_nacionalidad__c, Codigo_actividad_economica__c, 
                                  Tipo_de_identificacion__c, Tipo_de_persona_juridica__c, Fecha_de_constitucion__c, 
                                  Numero_de_identificacion__c, Interseccion_direccion_tributaria__c, 
                                  Interseccion_direccion_trabajo__c, Name, Numero_direccion_tributaria__c,
                                  Numero_direccion_trabajo__c, Description, Politicamente_expuesto__c, 
                                  Identificacion_representante_legal__c, Secuencia_canton_direccion_tributaria__c, 
                                  Secuencia_canton_direccion_trabajo__c, Telefono_celular__c, Phone, Total_activos__c, 
                                  Total_pasivos__c, Total_gastos__c, AnnualRevenue,Entidad_financiera__c, 
                                  Entidad_Financiera__r.Tipo_de_entidad__c,Entidad_Financiera__r.Name, 
                                  Numero_de_cuenta_bancaria__c, Tipo_de_cuenta_bancaria__c, Tipo_identificacion_representante_legal__c,
                                  Representante_Legal__r.Tipo_de_identificacion__c,Representante_Legal__r.Numero_de_identificacion__c,
                                  Representante_Legal__r.title,Correo_electronico__c
                                  
                                  From Account Where Id =: clienteId];
        
        if(clientes.size() > 0){
            Account cliente = clientes.get(0);            
            //List<Contact> contactos = cliente.contacts;            
            
            ANEFI_ServicesDTO.ActualizarPersonaJuridicaInput actualizarPersonaJuridicaInput = new ANEFI_ServicesDTO.ActualizarPersonaJuridicaInput();
            actualizarPersonaJuridicaInput.callePrincipalDireccionResidenciaTributaria = cliente.Calle_principal_direccion_tributaria__c;
            actualizarPersonaJuridicaInput.callePrincipalDireccionTrabajo = cliente.Calle_principal_direccion_trabajo__c;
            actualizarPersonaJuridicaInput.capitalSocial = cliente.Capital_social__c;
            actualizarPersonaJuridicaInput.cargoRepresentanteLegal =cliente.Representante_Legal__r != null ? cliente.Representante_Legal__r.title : '';
            actualizarPersonaJuridicaInput.codigoOrgGeoDireccionResidenciaTributaria = cliente.Codigo_canton_direccion_tributaria__c;
            actualizarPersonaJuridicaInput.codigoOrgGeoDireccionTrabajo = cliente.Codigo_canton_direccion_trabajo__c;
            actualizarPersonaJuridicaInput.codigoPaisDireccionResidenciaTributaria = cliente.Codigo_pais_direccion_tributaria__c;
            actualizarPersonaJuridicaInput.codigoPaisDireccionTrabajo = cliente.Codigo_pais_direccion_trabajo__c;
            actualizarPersonaJuridicaInput.codigoPaisNacionalidad = cliente.Codigo_pais_nacionalidad__c;
            actualizarPersonaJuridicaInput.codigoTipoActividadEconomica = cliente.Codigo_actividad_economica__c;            
            Datetime fechaDateTime = cliente.Fecha_de_constitucion__c;            
            actualizarPersonaJuridicaInput.fechaConstitucion = fechaDateTime != null ? fechaDateTime.format('yyyy-MM-dd') : '';
            actualizarPersonaJuridicaInput.codigoTipoIdentificacion = cliente.Tipo_de_identificacion__c;
            actualizarPersonaJuridicaInput.identificacion = cliente.Numero_de_identificacion__c;
            actualizarPersonaJuridicaInput.interseccionDireccionResidenciaTributaria = cliente.Interseccion_direccion_tributaria__c;
            actualizarPersonaJuridicaInput.interseccionDireccionTrabajo = cliente.Interseccion_direccion_trabajo__c;
            actualizarPersonaJuridicaInput.nombre = cliente.Name;
            actualizarPersonaJuridicaInput.numeroDireccionResidenciaTributaria = cliente.Numero_direccion_tributaria__c;
            actualizarPersonaJuridicaInput.numeroDireccionTrabajo = cliente.Numero_direccion_trabajo__c;
            actualizarPersonaJuridicaInput.observaciones = cliente.Description;
            actualizarPersonaJuridicaInput.politicamenteExpuesto = cliente.Politicamente_expuesto__c;
            actualizarPersonaJuridicaInput.razonSocial = cliente.Name;
            actualizarPersonaJuridicaInput.idRepresentanteLegal = cliente.Representante_Legal__r != null ? cliente.Representante_Legal__r.Numero_de_identificacion__c : '';
            actualizarPersonaJuridicaInput.tipoIdRepresentanteLegal = cliente.Representante_Legal__r != null ?  cliente.Representante_Legal__r.Tipo_de_identificacion__c : '';
            actualizarPersonaJuridicaInput.secuenciaOrgGeoDireccionResidenciaTributaria = cliente.Secuencia_canton_direccion_tributaria__c != 0 ? Integer.valueOf(cliente.Secuencia_canton_direccion_tributaria__c) : null;
            actualizarPersonaJuridicaInput.secuenciaOrgGeoDireccionTrabajo = cliente.Secuencia_canton_direccion_trabajo__c != null ? Integer.valueOf(cliente.Secuencia_canton_direccion_trabajo__c) : null;
            actualizarPersonaJuridicaInput.telefonoCelular = cliente.Telefono_celular__c;
            actualizarPersonaJuridicaInput.telefonoConvencional = cliente.Phone;            
            actualizarPersonaJuridicaInput.totalActivos = cliente.Total_activos__c;
            actualizarPersonaJuridicaInput.totalGastos = cliente.Total_gastos__c;
            actualizarPersonaJuridicaInput.totalIngresos = cliente.AnnualRevenue;
            actualizarPersonaJuridicaInput.totalPasivos = cliente.Total_pasivos__c;
            actualizarPersonaJuridicaInput.codigoTipoEntidadFinancieraCuentaBancaria = cliente.Entidad_financiera__c != null ? String.valueOf(cliente.Entidad_Financiera__r.Tipo_de_entidad__c) : '';
            actualizarPersonaJuridicaInput.codigoEntidadFinancieraCuentaBancaria = cliente.Entidad_financiera__c != null ? cliente.Entidad_Financiera__r.Name : '';
            actualizarPersonaJuridicaInput.numeroCuentaBancaria = cliente.Numero_de_cuenta_bancaria__c;
            actualizarPersonaJuridicaInput.codigoTipoCuentaBancaria = cliente.Tipo_de_cuenta_bancaria__c;  
            
            if((!String.isBlank(cliente.Correo_electronico__c) && cliente.Correo_electronico__c != null)){
                ANEFI_ServicesDTO.direccionesElectronicas emails =  new ANEFI_ServicesDTO.direccionesElectronicas();
                List<ANEFI_ServicesDTO.direccionesElectronicas> listEmails = new List<ANEFI_ServicesDTO.direccionesElectronicas>();
                emails.correoElectronico = cliente.Correo_electronico__c;
                emails.esDireccionEstadoCuenta = 'S';
                emails.principal = 'S';
                listEmails.add(emails);
                actualizarPersonaJuridicaInput.direccionesElectronicas = listEmails;
            }
            
            System.debug('actualizarPersonaJuridicaInput' + JSON.serialize(actualizarPersonaJuridicaInput));
            return actualizarPersonaJuridicaInput;             
        }
        return null;        
    }
    
    /*Método para actualizar Correo de persona en Gestor*/
    public static String actualizarPersonaEnGestorCorreo(String clienteId, String clienteCodigoGestor, String correoElectronico, String principal, String esDireccionEstadoCuenta ){       
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler(); 
        ANEFI_PostRequestData postRequestData = null;
        
        String codigoRespuestaActualizacionPersona = null;
        try{
            
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
            if(loginOUTDTO != null){//El servicio de autenticación en Gestor retornó el token de autenticación                
                
                //Se invoca servicio de actualización de persona en Gestor
                codigoRespuestaActualizacionPersona = actualizarPersonaEnGestorCorreo(requestHandler,clienteId,clienteCodigoGestor,loginOUTDTO, configuracionGestorWeb, correoElectronico, principal, esDireccionEstadoCuenta); 
                
            }     
        }
        catch(Exception e){
            system.debug('Error actualizando persona en Gestor: ' + e.getMessage());
            system.debug('Error actualizando persona en Gestor: ' + e.getLineNumber());
            
        }
        
        
        //insertar los logs
        requestHandler.insertRequestLogs();
        return codigoRespuestaActualizacionPersona;
    } 
    
    
    /*Método que envía petición de actualización de persona en Gestor correo*/
    public static String actualizarPersonaEnGestorCorreo(ANEFI_RequestsHandler requestHandler, String clienteId, String codigoPersonaGestor, ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb, String correoElectronico, String principal, String esDireccionEstadoCuenta){
        String URLServicio = ''; 
        Account clienteAActualizar = [Select Id, recordType.Name from Account where Id =: clienteId];
        URLServicio = clienteAActualizar.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA) ? ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaJuridica') :  ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaNatural');
        
        
        if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
            URLServicio = URLServicio.replace('{codigoPersona}', codigoPersonaGestor);
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;                
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
            ANEFI_PostRequestData postRequestData = null;
            
            ANEFI_ServicesDTO.ActualizarPersonaJuridicaInputCorreo actualizarPersonaJuridicaInputCorreo = obtInputActualizacionCorreo(clienteId,correoElectronico,principal,esDireccionEstadoCuenta);
            postRequestData = new ANEFI_PostRequestData(actualizarPersonaJuridicaInputCorreo);
            
            String body = JSON.serialize(postRequestData, true);                
            ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
            HttpResponse response = null;
            
            try {                    
                requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'PUT',null, clienteId); 
                response = requestHandlerResponse.response;                    
            } catch (Exception e) {
                system.debug('No se pudo realizar la petición de actualización de persona en Gestor: ' + e.getMessage());            
            }
            
            String responseBody = response.getBody();        
            Integer responseStatusCode = response.getStatusCode();                
            if(responseStatusCode == 204){
                if(requestHandlerResponse.loginOUT != null){
                    loginOUTDTO = requestHandlerResponse.loginOUT;
                }                
                return String.valueOf(responseStatusCode);
            }else{
                return null;
            }
        } 
        
        return null;
    }
    
    /**Método para obtener el input del servicio de actualizacion de persona Jurídica correo electronico*/
    public static ANEFI_ServicesDTO.ActualizarPersonaJuridicaInputCorreo obtInputActualizacionCorreo(Id clienteId, String correoElectronico, string principal,  String esDireccionEstadoCuenta){
        
        ANEFI_ServicesDTO.ActualizarPersonaJuridicaInputCorreo actualizarPersonaJuridicaInputCorreo = new ANEFI_ServicesDTO.ActualizarPersonaJuridicaInputCorreo();
        
        if((!String.isBlank(correoElectronico) && correoElectronico != null)){
            
            ANEFI_ServicesDTO.direccionesElectronicas emails =  new ANEFI_ServicesDTO.direccionesElectronicas();
            List<ANEFI_ServicesDTO.direccionesElectronicas> listEmails = new List<ANEFI_ServicesDTO.direccionesElectronicas>();
            emails.correoElectronico = correoElectronico;
            emails.esDireccionEstadoCuenta = esDireccionEstadoCuenta;
            emails.principal = principal;
            listEmails.add(emails);
            actualizarPersonaJuridicaInputCorreo.direccionesElectronicas = listEmails;
            
            System.debug('actualizarPersonaJuridicaInputCorreo' + JSON.serialize(actualizarPersonaJuridicaInputCorreo));
            return actualizarPersonaJuridicaInputCorreo;     
            
        }
        
        
        return null;      
    }
    
    
}