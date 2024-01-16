/*Clase para invocar los servicios de creación de cuenta de participe en Gestor*/
public with sharing class ANEFI_CrearCuentaGestorQueueable implements Queueable,Database.AllowsCallouts {
    @testVisible
    private static Boolean doChainJob = true; //Esta propiedad se utiliza para evitar que cuando se ejecuten los test se generé error de jobs encadenados
	@TestVisible static Boolean makeCallout = true;// Esta propiedad se utiliza para evitar que se genere el error de uncommitted work pending en la ejecución de los tests
    public class CrearCuentaGestorQueueableException extends Exception {}
    
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
    public String oportunidadSerializada;
    
    public ANEFI_CrearCuentaGestorQueueable(String oportunidadSerializada){
        this.oportunidadSerializada = oportunidadSerializada;
    }
    
    public void execute(QueueableContext context){
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        try{
 			 if (makeCallout) ejecutarOperaciones(oportunidadDTO);	
                
        }
        catch(Exception e){
            System.debug('err execute->'+e.getLineNumber());
            System.debug('err execute ->'+e.getMessage());
            ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(null, null, oportunidadDTO.oportunidadId, ANEFI_Utilitarios.ERROR_INESPERADO, e.getMessage());            
        }
    }
    
    public static void ejecutarOperaciones(ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        //solo se ejecutan las operaciones si la oportunidad no se ha sincronizado completamente en Gestor 
 			//y el producto de interes es CP-1, FS-2, OPTIMO, META O SEMILLA
 			System.debug('Entro a ejecutar operaciones');
 			List<Opportunity> numeroTransaccionAporte = [Select Id, Numero_transaccion_aporte_en_gestor__c ,Producto_de_Interes__c
                                                                        from Opportunity where Id =: oportunidadDTO.oportunidadId];
             //oportunidadDTO.numeroTransaccionAporte == null               
            if(numeroTransaccionAporte.size() > 0 && (oportunidadDTO.codigoProducto.equals('F001') 
                                                                  || oportunidadDTO.codigoProducto.equals('F002')
                                                                  || oportunidadDTO.codigoProducto.equals('F003')
                                                                  || oportunidadDTO.codigoProducto.equals('F004')
                                                                  || oportunidadDTO.codigoProducto.equals('F005'))){               
                
                ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad = crearCuentaParticipeGestor(oportunidadDTO);
                System.debug('llamara a gestionar respuesta sincronizacion oportunidad En Gestor');

                gestionarRespuestaSincronizacionOportunidadEnGestor(respuestaSincronizacionOportunidad, oportunidadDTO);
                System.debug('salio de llamar a gestionar respuesta sincronizacion oportunidad En Gestor');
                        
                List<ContentDocumentLink> contentDocument = [select id ,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId =:oportunidadDTO.oportunidadId];
                List<ContentVersion> listContentVersion = new List<ContentVersion>();
                System.debug('contentDocument'+ contentDocument);
                if(contentDocument.size()>0){
                     listContentVersion = [Select Title from ContentVersion where ContentDocumentId=:contentDocument[0].ContentDocumentId and title in  ('Contrato de Incorporación Fondo Meta FM-3','Contrato de Incorporación CP-1','Contrato de Incorporación Fondo Seguro FS-2','Contrato de Incorporación Fondo de Inversión Óptimo','Contrato de Incorporación Fondo Seguro FS-5')];
                }
                if(listContentVersion.size()>0){
                  System.debug('eliminara contentDocument ');
                  delete contentDocument;                                                    
               	}    
                System.debug('llamara a createContractFilesOpportunity');                        
                ANEFI_OpportunityHelper.createContractFilesOpportunity(oportunidadDTO.oportunidadId,numeroTransaccionAporte[0].Producto_de_Interes__c);
            	System.debug('salio de llamara a createContractFilesOpportunity');
            }    
    }
    
    public static void gestionarRespuestaSincronizacionOportunidadEnGestor(ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        String tituloNotificacion = '';
        String mensajeNotificacion = '';
        try{
            System.debug('gestionarRespuestaSincronizacionOportunidadEnGestor');
            //Actualizar estado de sincronización de la oportunidad
            ANEFI_Utilitarios.actualizarEstadoSincronizacionOportunidad(oportunidadDTO.oportunidadId, respuestaSincronizacionOportunidad);
            if(respuestaSincronizacionOportunidad != null && respuestaSincronizacionOportunidad.errorEnSincronizacion){
                tituloNotificacion = 'Error sincronizando la oportunidad ' + oportunidadDTO.oportunidadNombre + ' en Gestor';
                mensajeNotificacion = 'La oportunidad '+ oportunidadDTO.oportunidadNombre + ' no se sincronizó correctamente en Gestor, por favor revise ' +
                    'su correo electrónico para conocer los detalles del error y los pasos a seguir.';                             
            }
            else{
                tituloNotificacion = 'Sincronización de la oportunidad ' + oportunidadDTO.oportunidadNombre + ' en Gestor';
                mensajeNotificacion = 'La oportunidad '+ oportunidadDTO.oportunidadNombre + ' se sincronizó correctamente en Gestor.';                  
            }            
            //Enviar notificación de escritorio solo en el caso de que no se este ejecutando clases de pruebas
            if(doChainJob) {
            	ANEFI_EnviarNotificacionQueueable enviarNotificacionError = new ANEFI_EnviarNotificacionQueueable(oportunidadDTO, tituloNotificacion, mensajeNotificacion);
            	System.enqueueJob(enviarNotificacionError);
            }
         }
        catch(Exception e){
            System.debug('err'+e.getLineNumber());
            System.debug('err'+e.getMessage());
             
            throw new CrearCuentaGestorQueueableException('Error gestionando la respuesta de sincronización de la oportunidad: '+ e.getMessage());
        }        
    }
    
     /**
     * Método que crea una cuenta en Gestor Web
     * @params Oportunidad
     */
    public static ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad crearCuentaParticipeGestor(ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
        ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad = new ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad();
        respuestaSincronizacionOportunidad.errorEnSincronizacion = true;
        respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras = false;        
        try {
            
            configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();            
            if(configuracionGestorWeb == null) throw new CrearCuentaGestorQueueableException('No se ha establecido la configuración de Gestor Web');            
            loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, oportunidadDTO.oportunidadId, configuracionGestorWeb);
            if(loginOUTDTO != null){//El servicio de autenticación se ejecutó correctamente
                //Validar persona en listas negras de Gestor
                System.debug('requestHandler1: '+JSON.serialize(requestHandler));
                System.debug('oportunidadDTO1: '+JSON.serialize(oportunidadDTO));
                if(!personaReportadaEnListasNegras(requestHandler, oportunidadDTO)){//Persona no reportada en listas negras
                    //Se valida si el cliente ya tiene código de persona en Gestor, esto quiere decir que ya se hizo un 
                    //intento de sincronización pero falló en algún punto del proceso o que es una nueva oportunidad para un
                    //producto diferente con un cliente ya sincronizado en Gestor
                    if(oportunidadDTO.codigoPersonaEnGestor != null){//ya existe código de persona en Gestor 
                        //02-09-2020 se invoca nuevo servicio de actualización de persona en Gestor
                        String codigoRespuestaActualizacionPersona = actualizarPersonaEnGestor(requestHandler, oportunidadDTO);
                        if(codigoRespuestaActualizacionPersona != null){
                             //Se valida si ya se tiene cuenta de participe
                            if(oportunidadDTO.numeroCuentaParticipe != null){//Ya existe cuenta de participe
                                //validar si ya se tiene el primer aporte
                                if(oportunidadDTO.numeroTransaccionAporte != null){//Ya se creó el primer aporte
                                    respuestaSincronizacionOportunidad.errorEnSincronizacion = false;
                                    respuestaSincronizacionOportunidad.codigoPersonaEnGestor = oportunidadDTO.codigoPersonaEnGestor;
                                    respuestaSincronizacionOportunidad.numeroCuentaParticipe = oportunidadDTO.numeroCuentaParticipe;
                                    respuestaSincronizacionOportunidad.numeroTransaccionAporte = oportunidadDTO.numeroTransaccionAporte;
                                    return respuestaSincronizacionOportunidad; 
                                }
                                else{
                                    //Se crea el primer aporte en Gestor
                                    respuestaSincronizacionOportunidad = crearPrimerAporteEnGestor(requestHandler, oportunidadDTO);                                
                                }                                                       
                            }
                            else{//Se crea la cuenta de participe y aporte en Gestor
                                respuestaSincronizacionOportunidad = crearCuentaParticipeYAporteEnGestor(requestHandler, oportunidadDTO);                                                      
                            } 
                        }
                                              
                    }else{
                        //validar si el cliente existe como persona en Gestor
                        //ANEFI_ServicesDTO.RegistroClienteOut registroClienteOut = validarEnRegistrosDeClientes(requestHandler, oportunidadDTO.clienteId, oportunidadDTO.oportunidadId);
                        ANEFI_ServicesDTO.RegistroClienteOut registroClienteOut = ANEFI_Utilitarios.validarEnRegistrosDeClientes(requestHandler,oportunidadDTO.clienteId, oportunidadDTO.oportunidadId, loginOUTDTO, configuracionGestorWeb);
                        if(registroClienteOut != null){//no se presentó error consumiendo el servicio
                            if(registroClienteOut.tipoRelacion.equals('NO_REGISTRADA')){//Cliente no existe como persona en Gestor
                                //Crear persona, cuenta de participe y aporte en Gestor
                                respuestaSincronizacionOportunidad = crearPersonaCuentaParticipeYAporteEnGestor(requestHandler,oportunidadDTO);                                                          
                            }else{//La persona ya se encuentra registrada en Gestor
                                //Crear cuenta de participe y aporte en Gestor
                                //24 de Agosto: se implementa modificación ya que modificaron el servicio para retornar una lista de ocurrencias con el número de identificación dado                                
                                List<ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente> ocurrencias = registroClienteOut.ocurrencias;
                                if(ocurrencias.size() > 0){
                                    ANEFI_ServicesDTO.ItemOcurrenciaRegistroCliente itemOcurrenciaRegistroCliente = ocurrencias.get(0); 
                                    oportunidadDTO.codigoPersonaEnGestor = itemOcurrenciaRegistroCliente !=  null ? itemOcurrenciaRegistroCliente.codigoPersona : null;
                                    //02-09-2020 se invoca nuevo servicio de actualización de persona en Gestor
                                    String codigoRespuestaActualizacionPersona = actualizarPersonaEnGestor(requestHandler, oportunidadDTO);
                                    if(codigoRespuestaActualizacionPersona != null){
                                    	respuestaSincronizacionOportunidad = crearCuentaParticipeYAporteEnGestor(requestHandler, oportunidadDTO);    
                                    }                                	
                                }                                                                
                            }                       
                        }
                    }                   
                }   
                else{
                    respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras = true;
                }
            }			          
            //insertar los logs
            requestHandler.insertRequestLogs();       
        } catch (Exception e) {
            System.debug('err'+e.getLineNumber());
            System.debug('err'+e.getMessage());
            requestHandler.insertRequestLogs();
            throw new CrearCuentaGestorQueueableException('Error en la sincronización de la oportunidad en Gestor: '+e.getMessage());
        }    
        return respuestaSincronizacionOportunidad;
    }
    
    /*Método para crear cuenta de participe y primer aporte en Gestor*/
    public static ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad crearCuentaParticipeYAporteEnGestor(ANEFI_RequestsHandler requestHandler,ANEFI_ServicesDTO.Oportunidad oportunidadDTO)
    {
        ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad = new ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad();
        respuestaSincronizacionOportunidad.errorEnSincronizacion = true; 
        respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras = false;
        respuestaSincronizacionOportunidad.codigoPersonaEnGestor = oportunidadDTO.codigoPersonaEnGestor;
        try{
            //Se crea la cuenta de participe
            ANEFI_ServicesDTO.RegistroCuentaParticipeOut registroCuentaParticipeOut = 
                crearCuentaParticipeEnGestor(requestHandler, oportunidadDTO);
            
            if(registroCuentaParticipeOut != null){//La cuenta de participe se creó correctamente
                oportunidadDTO.numeroCuentaParticipe = registroCuentaParticipeOut.numeroCuenta;                
                respuestaSincronizacionOportunidad.numeroCuentaParticipe = oportunidadDTO.numeroCuentaParticipe;
                //Se crea el primer aporte en Gestor
                ANEFI_ServicesDTO.RegistroAporteOut registroAporteOut =
                    crearRegistroAporteEnGestor(requestHandler, oportunidadDTO);                         
                if(registroAporteOut != null){//se creo el primer aporte correctamente
                    respuestaSincronizacionOportunidad.errorEnSincronizacion = false;                    
                    respuestaSincronizacionOportunidad.numeroTransaccionAporte = registroAporteOut.numeroTransaccion;
                    return respuestaSincronizacionOportunidad; 
                } 
            } 
        }
        catch(Exception e){            
            throw new CrearCuentaGestorQueueableException('Error en la creación de cuenta de participe y aporte en Gestor: '+e.getMessage());
        }        
        return respuestaSincronizacionOportunidad;
    } 
    
    /*Método para crear persona, cuenta de participe y primer aporte en Gestor*/
    public static ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad crearPersonaCuentaParticipeYAporteEnGestor(ANEFI_RequestsHandler requestHandler,ANEFI_ServicesDTO.Oportunidad oportunidadDTO)
    {
        ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad = new ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad();
        respuestaSincronizacionOportunidad.errorEnSincronizacion = true;
        respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras = false;
        try{
             //Crear persona en Gestor                                                       
            ANEFI_ServicesDTO.RegistroPersonaOut registroPersonaOut = crearPersonaEnGestor(requestHandler,oportunidadDTO);
            if(registroPersonaOut != null){//La persona se creó correctamente en Gestor
                oportunidadDTO.codigoPersonaEnGestor = registroPersonaOut.codigoPersona;
                respuestaSincronizacionOportunidad.codigoPersonaEnGestor = oportunidadDTO.codigoPersonaEnGestor;
                //Se crea la cuenta de participe
                ANEFI_ServicesDTO.RegistroCuentaParticipeOut registroCuentaParticipeOut = 
                    crearCuentaParticipeEnGestor(requestHandler, oportunidadDTO);                
                if(registroCuentaParticipeOut != null){//La cuenta de participe se creó correctamente
                    oportunidadDTO.numeroCuentaParticipe = registroCuentaParticipeOut.numeroCuenta;
                     respuestaSincronizacionOportunidad.numeroCuentaParticipe = oportunidadDTO.numeroCuentaParticipe;
                    //Se crea el primer aporte en Gestor
                    ANEFI_ServicesDTO.RegistroAporteOut registroAporteOut =
                        crearRegistroAporteEnGestor(requestHandler, oportunidadDTO);
                    if(registroAporteOut != null){//se creo el primer aporte correctamente
                        respuestaSincronizacionOportunidad.errorEnSincronizacion = false;                       
                        respuestaSincronizacionOportunidad.numeroTransaccionAporte = registroAporteOut.numeroTransaccion;
                        return respuestaSincronizacionOportunidad; 
                    } 
                } 
            } 
        }
        catch(Exception e){       
            System.debug('err'+e.getLineNumber());
            System.debug('err'+e.getMessage());         
            throw new CrearCuentaGestorQueueableException('Error en la creación de persona, cuenta de participe y aporte en Gestor: '+e.getMessage());
        }        
        return respuestaSincronizacionOportunidad;
    } 
    
    /*Método para crear persona, cuenta de participe y primer aporte en Gestor*/
    public static ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad crearPrimerAporteEnGestor(ANEFI_RequestsHandler requestHandler,ANEFI_ServicesDTO.Oportunidad oportunidadDTO)
    {
        ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad = new ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad();
        respuestaSincronizacionOportunidad.errorEnSincronizacion = true;
        respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras = false;
        respuestaSincronizacionOportunidad.codigoPersonaEnGestor = oportunidadDTO.codigoPersonaEnGestor;
        respuestaSincronizacionOportunidad.numeroCuentaParticipe = oportunidadDTO.numeroCuentaParticipe;
        try{
            //Se crea el primer aporte en Gestor
            ANEFI_ServicesDTO.RegistroAporteOut registroAporteOut =
                crearRegistroAporteEnGestor(requestHandler, oportunidadDTO);            
            if(registroAporteOut != null){//se creo el primer aporte correctamente
                respuestaSincronizacionOportunidad.errorEnSincronizacion = false;                
                respuestaSincronizacionOportunidad.numeroTransaccionAporte = registroAporteOut.numeroTransaccion;
                return respuestaSincronizacionOportunidad; 
            }
        }
        catch(Exception e){            
            throw new CrearCuentaGestorQueueableException('Error en la creación de persona, cuenta de participe y aporte en Gestor: '+e.getMessage());
        }        
        return respuestaSincronizacionOportunidad;
    }     
        
    /**
     * Método que envía petición de validación de persona en listas negras de GESTOR
     */
    public static Boolean personaReportadaEnListasNegras(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        System.debug('requestHandler2: '+JSON.serialize(requestHandler));
        System.debug('oportunidadDTO2: '+JSON.serialize(oportunidadDTO));
        String nombreCliente = '';
        String numeroIdentificacion = '';
		String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('validacionListasNegras');        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new CrearCuentaGestorQueueableException('No se ha definido la URL del servicio de validación en listas negras');        
		String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
        
        ANEFI_PostRequestData postRequestData = null;
        if(oportunidadDTO.tipoPersona.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
            ANEFI_ServicesDTO.ListasNegrasJuridicaInput listasNegrasJuridicaInputDTO = ANEFI_SerializadorService.obtInputListasNegrasPersonaJuridica(oportunidadDTO.clienteId); 
            postRequestData = new ANEFI_PostRequestData(listasNegrasJuridicaInputDTO);
            nombreCliente = '';
            numeroIdentificacion = listasNegrasJuridicaInputDTO.identificacion;
        }
        else{
            ANEFI_ServicesDTO.ListasNegrasNaturalInput listasNegrasNaturalInputDTO = ANEFI_SerializadorService.obtInputListasNegrasPersonaNatural(oportunidadDTO.clienteId);
            postRequestData = new ANEFI_PostRequestData(listasNegrasNaturalInputDTO);
            nombreCliente = '';
            numeroIdentificacion = listasNegrasNaturalInputDTO.identificacion;
        }
        String body = JSON.serialize(postRequestData,true);
        system.debug('body '+ body);
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
        HttpResponse response = null;
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, oportunidadDTO.oportunidadId); 
            response = requestHandlerResponse.response;
            
        } catch (Exception e) {
            throw new CrearCuentaGestorQueueableException('No se pudo realizar la petición: ' + e.getMessage());
        }
        
        String responseBody = response.getBody();        
        Integer responseStatusCode = response.getStatusCode();   
        if(responseStatusCode == 200){
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }			            
            ANEFI_ServicesDTO.ResponseDataListasNegrasOut responseDataListasNegrasOut = (ANEFI_ServicesDTO.ResponseDataListasNegrasOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataListasNegrasOut.class);            
            //Se procesar la respuesta del servicio de validación en listas negras
            return ANEFI_Utilitarios.existePersonaEnListasNegrasDeGestor(oportunidadDTO, responseDataListasNegrasOut.data, nombreCliente, numeroIdentificacion);   
            
        }else{
            return true;
        }
    }    
        
    /**
     * Método que envía petición de creación de persona en Gestor y retorna el código de la persona en caso de que 
     * se cree exitosamente o retornal null si el servicio retorna un error
     */
    public static ANEFI_ServicesDTO.RegistroPersonaOut crearPersonaEnGestor(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        
        String URLServicio = '';
        
        if(oportunidadDTO.tipoPersona.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
            URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroPersonaJuridica');
        }
        else{
            URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroPersonaNatural');  
        }        
		  System.debug('despuesde url por servicio');     
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new CrearCuentaGestorQueueableException('No se ha definido la URL del servicio de creación de persona en Gestor');        
		String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
        ANEFI_PostRequestData postRequestData = null;
        System.debug('se obtuvo headers generales');   
        System.debug('oportunidadDTO.tipoPersona' + oportunidadDTO.tipoPersona);
        System.debug('ANEFI_Utilitarios.PERSONA_JURIDICA' + ANEFI_Utilitarios.PERSONA_JURIDICA);
        if(oportunidadDTO.tipoPersona.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
            System.debug('entro aca input');
            ANEFI_ServicesDTO.RegistroPersonaJuridicaInput registroPersonaJuridicaInputDTO = ANEFI_SerializadorService.obtInputRegistroPersonaJuridica(oportunidadDTO.clienteId);
            System.debug('entro despues input');
            postRequestData = new ANEFI_PostRequestData(registroPersonaJuridicaInputDTO);
        }
        else{
            System.debug('entro aca input natural');
            ANEFI_ServicesDTO.RegistroPersonaNaturalInput registroPersonaNaturalInputDTO = ANEFI_SerializadorService.obtInputRegistroPersonaNatural(oportunidadDTO.clienteId);      
            System.debug('despues  input natural');
            postRequestData = new ANEFI_PostRequestData(registroPersonaNaturalInputDTO);
            
        }
        
        String body = JSON.serialize(postRequestData, true);
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
        HttpResponse response = null;
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, oportunidadDTO.oportunidadId); 
            response = requestHandlerResponse.response;
            
        } catch (Exception e) {
            throw new CrearCuentaGestorQueueableException('No se pudo realizar la petición: ' + e.getMessage());
        }
        
        String responseBody = response.getBody();        
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
    
    /**
     * Método que envía petición de creación de cuenta de participe en Gestor y retorna el número de cuenta 
     * en caso de que se cree exitosamente
     */
    public static ANEFI_ServicesDTO.RegistroCuentaParticipeOut crearCuentaParticipeEnGestor(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        String URLServicio = '';        
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroCuentaParticipe');        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new CrearCuentaGestorQueueableException('No se ha definido la URL del servicio de creación de cuenta de participe en Gestor');        
        URLServicio = URLServicio.replace('{codigoEmpresa}', '1').
            			replace('{codigoProducto}', oportunidadDTO.codigoProducto).
            			replace('{codigoCliente}', String.valueOf(oportunidadDTO.codigoPersonaEnGestor));
		String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        system.debug('endpoint: ' + endpoint);
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
        ANEFI_PostRequestData postRequestData = new ANEFI_PostRequestData(ANEFI_SerializadorService.obtInputRegistroCuentaParticipe(oportunidadDTO));        
        
        String body = JSON.serialize(postRequestData);
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
        HttpResponse response = null;
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, oportunidadDTO.oportunidadId); 
            response = requestHandlerResponse.response;
            
        } catch (Exception e) {
            throw new CrearCuentaGestorQueueableException('No se pudo realizar la petición: ' + e.getMessage());
        }
        
        String responseBody = response.getBody();        
        Integer responseStatusCode = response.getStatusCode();   
        if(responseStatusCode == 201){
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            ANEFI_ServicesDTO.ResponseDataRegistroCuentaParticipeOut responseDataRegistroPersonaOut = (ANEFI_ServicesDTO.ResponseDataRegistroCuentaParticipeOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataRegistroCuentaParticipeOut.class);
            return responseDataRegistroPersonaOut.data;
        }else{
        	return null;
        }
    }
    
    /**
     * Método que envía petición de creación de aporte en Gestor y retorna el número de transacción
     * en caso de que se cree exitosamente
     */
    public static ANEFI_ServicesDTO.RegistroAporteOut crearRegistroAporteEnGestor(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        ANEFI_ServicesDTO.RegistroAporteOut registroAporteOut = null;        
        try{
            registroAporteOut = ANEFI_Utilitarios.crearRegistroAporteEnGestor(loginOUTDTO, configuracionGestorWeb, requestHandler, oportunidadDTO);
        }
        catch(Exception e){
            system.debug('Error creando registro de aporte en Gestor: ' + e.getMessage());
        }
        return registroAporteOut;      
    }

	/**
     * Método que envía petición de actualización de persona en Gestor, retorna null si el servicio retorna un error
     */
    public static String actualizarPersonaEnGestor(ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){       
        return ANEFI_Utilitarios.actualizarPersonaEnGestor(requestHandler,oportunidadDTO.clienteId, String.valueOf(oportunidadDTO.codigoPersonaEnGestor), oportunidadDTO.oportunidadId, loginOUTDTO, configuracionGestorWeb);
    }    
    
}