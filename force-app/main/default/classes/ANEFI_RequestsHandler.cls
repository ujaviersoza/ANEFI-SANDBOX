/**
 * Clase que maneja todas las peticiones
 */
public class ANEFI_RequestsHandler {
    public class RequestsHandlerException extends Exception {}
    
    List<Request_Log__c> requestLogs;
    

    /**
     * Método constructor que inicializa la clase
     */
    public ANEFI_RequestsHandler(){
        requestLogs = new List<Request_Log__c>();
    }
    
    /**
     * Método que obtiene la lista de logs
     */
    public List<Request_Log__c> getRequestLogsList(){
        return this.requestLogs;
    }

    /**
     * Método que adiciona un nuevo log a la lista de requests
     */
    public List<Request_Log__c> addRequestLog(Request_Log__c requestLog){
        try {
            this.requestLogs.add(requestLog);
            return requestLogs;
        } catch (Exception e) {
            throw new RequestsHandlerException('No se pudo generar un nuevo log: '+e.getMessage());
        }
    }
    
    /**
     * Método que inserta los logs que se generaron
     */
    public Boolean insertRequestLogs(){
        Boolean hayError = false;
        try {
            Database.SaveResult[] sr = Database.insert(this.requestLogs, false);            
        } catch (Exception e) {
            throw new RequestsHandlerException('No se pudieron insertar los logs: '+e.getMessage());
        }
        return !hayError;
    }
    
    /*Método que se encarga de realizar la petición a Gestor y procesar su respuesta*/
    public ANEFI_ServicesDTO.RequestsHandlerResponse processRequest(String endpoint, String body, Map<String,String> headers, String method, Map<String,String> URLParams, Id relatedObjectId){
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = new ANEFI_ServicesDTO.RequestsHandlerResponse();
        try{
            HttpResponse response = logRequest(endpoint,  body, headers, method, URLParams);
        	requestHandlerResponse = processServiceResponse(endpoint, body, headers, method, URLParams, response, relatedObjectId);
        }
        catch(Exception e){
            throw new RequestsHandlerException('No se pudo realizar la petición en RequestsHandler: '+e.getMessage());
        }
        
        return requestHandlerResponse;
    }

	/**
     * Método que se encarga de generar el log del request
     */    
    public HttpResponse logRequest(String endpoint, String body, Map<String,String> headers, String method, Map<String,String> URLParams){
                
        System.debug('Se intenta realizar un log de una petición: '+endpoint+' : '+body);               
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String URLParamsLog = null;
        if(URLParams != null)
        {
            request.setEndpoint(buildURL(URLParams, endpoint));
            URLParamsLog = JSON.serialize(URLParams);
        }
        else {
            request.setEndpoint(endpoint);
        }
        //Método de la petición
        if(method == null) throw new RequestsHandlerException('El método de la petición no puede ser null');
        request.setMethod(method);
        //Si es null no se agregan headers
        String headersLog = null;
        if(headers != null)
        {
            request = addHeaders(headers, request);
            headersLog = JSON.serialize(headers);
        }
        if(body != null)
        {
            request.setBody(body);
        }
        HttpResponse response = null;
        request.setTimeout(120000);
        try {        
            response = http.send(request);
            
        } catch (Exception e) {            
            throw new RequestsHandlerException('No se pudo realizar la petición: '+e.getMessage());
        }
        try {
            Request_Log__c log = new Request_Log__c(Codigo_respuesta__c=String.valueOf(response.getStatusCode()),
            Mensaje_respuesta__c=response.getBody(), Endpoint_URL__c=endpoint, Headers_Peticion__c=headersLog,
            Body_peticion__c=body,Metodo_de_la_peticion__c=method, URL_Params__c=URLParamsLog);
            addRequestLog(log);            
        } catch (Exception e) {
            System.debug('No se pudo registrar el LOG de la petición: '+e.getMessage());
        }
          
        return response;
    }
    
    /**
     * Método que se encarga de generar el log del response
     */
    public void logResponse(String URL_MAP, String body, Map<String,String> headers, String method, String statusCode, String responseBody, Map<String,String> URLParams)
    {
        System.debug('Se intenta realizar un log de una respuesta '+responseBody);
        String endpoint = URL.getOrgDomainUrl().toExternalForm()+'/services/apexrest/'+URL_MAP;
        try {
            Request_Log__c log = new Request_Log__c(Codigo_respuesta__c=statusCode,
            Mensaje_respuesta__c=responseBody, Endpoint_URL__c=endpoint, Headers_Peticion__c=JSON.serialize(headers),
            Body_peticion__c=body,Metodo_de_la_peticion__c=method, URL_Params__c=JSON.serialize(URLParams));
            //Registrar LOG
            addRequestLog(log);
        } catch (Exception e) {
            throw new RequestsHandlerException('No se pudo registrar el LOG: '+e.getMessage());
        }
    }


    /**
     * Método que se encarga de agregar los Headers de la petición
     */
    public HttpRequest addHeaders(Map<String,String> headers,HttpRequest request)
    {
        if(headers == null) throw new RequestsHandlerException('No se pueden agregar headers a la petición: '+headers);
        for(String headerKey: headers.keySet())
        {
            request.setHeader(headerKey, headers.get(headerKey));
        }
        return request;
    }

    /**
     * Método que se encarga de agregar los parámetros de la petición
     */
    public String buildURL(Map<String,String> URLParams, String endpoint)
    {
        Boolean primerParam = true;
        String URL = endpoint;
        if(URLParams == null) return endpoint;
        for(String paramKey: URLParams.keySet())
        {
            if(primerParam)
            {
                primerParam = false;
                URL += '?' + paramKey + '='+URLParams.get(paramKey);
            }
            else {
                URL += '&' + paramKey + '='+URLParams.get(paramKey);
            }
        }
        return URL;
    }
    
    /**Método para procesar la respuesta de Gestor y hacer las acciones correspondientes*/
    public ANEFI_ServicesDTO.RequestsHandlerResponse processServiceResponse(String endpoint, String body, Map<String,String> headers, String method, Map<String,String> URLParams, HttpResponse response, Id relatedObjectId){        
        Integer responseStatusCode = response.getStatusCode();
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = new ANEFI_ServicesDTO.RequestsHandlerResponse();
        switch on responseStatusCode{
            when 200, 201, 204{ //Respuesta correcta
                requestHandlerResponse.response = response;
                requestHandlerResponse.loginOUT = null;
            }            
            when 400, 403,503,502{                
                /*Cuendo el tipo de error corresponde a alguno de los siguientes tipos: 
                 * Bad Request, 
                 * Forbidden (Usuario con rol de acceso limitado.),
                 * Conflict (Validaciones de negocio no superadas en las fuentes de datos.), 
				 * Service Unavailable*/                
                //Enviar notificación electrónica a los usuarios adicionados en el objeto usuarios a notificar
                ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpoint, response, relatedObjectId, ANEFI_Utilitarios.ERROR_GENERAL, null);
				requestHandlerResponse.response = response;
                requestHandlerResponse.loginOUT = null;                
            }
            when 401{
                //Unauthorized, puede ser por que se venció el token de autenticación o por que el token de autenticación 
                //es incorrecto, por tanto se autentica nuevamente en Gestor y se invoca el servicio
                ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
                requestHandlerResponse.loginOUT = ANEFI_Utilitarios.autenticarEnGestor(this, relatedObjectId, configuracionGestorWeb);                                    
                if(requestHandlerResponse.loginOUT != null){                    
                    if(headers.containsKey('Authorization')){
                        headers.remove('Authorization');
                        headers.put('Authorization', 'Bearer ' + requestHandlerResponse.loginOUT.accessToken);                        
                        requestHandlerResponse.response = logRequest(endpoint, body, headers, method, URLParams);
                    }                        
                }
            }            
            when 404{
                
            }  
            when 409{//validaciones de negocio  no superadas en la fuente de datos
                ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpoint, response, relatedObjectId, ANEFI_Utilitarios.ERROR_CONFLICTO, null);
				requestHandlerResponse.response = response;
                requestHandlerResponse.loginOUT = null;   
            }
            when else{//Se presentó algún error no identificador
                //Enviar notificación electrónica a los usuarios adicionados en el objeto usuarios a notificar
                ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpoint, response, relatedObjectId, ANEFI_Utilitarios.ERROR_GENERAL, null);
				requestHandlerResponse.response = response;
                requestHandlerResponse.loginOUT = null;    
            }
        }
        return requestHandlerResponse;
    }

}