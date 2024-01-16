public class ANEFI_ValidaProspectoListaNegra {
    @InvocableMethod()
    public static List<String> validaProspecto(List<String> lstIdProspecto){
        List<String> lstRespuesta = new List<String>();
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
        ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
        ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb(); 
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler,lstIdProspecto.get(0), configuracionGestorWeb);
        
        String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('validacionListasNegras');  
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
        
        ANEFI_PostRequestData postRequestData = null;
        
        ANEFI_ServicesDTO.ListasNegrasJuridicaInput listasNegrasJuridicaInputDTO = obtInputListasNegrasPersonaJuridica(lstIdProspecto.get(0));
        System.debug('listasNegrasJuridicaInputDTO' + listasNegrasJuridicaInputDTO);
        postRequestData = new ANEFI_PostRequestData(listasNegrasJuridicaInputDTO);
        String body = JSON.serialize(postRequestData,true);
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
        HttpResponse response = null; 
        requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, lstIdProspecto.get(0));
        response = requestHandlerResponse.response;
        String responseBody = response.getBody();        
        Integer responseStatusCode = response.getStatusCode(); 
        system.debug(responseBody);
		system.debug(responseStatusCode);
        ANEFI_ServicesDTO.ResponseDataListasNegrasOut responseDataListasNegrasOut = (ANEFI_ServicesDTO.ResponseDataListasNegrasOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataListasNegrasOut.class); 
        Boolean estaPersonaEnListasNegras = responseDataListasNegrasOut.data.personaReportada;
        for(ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra itemOcurrenciaPersonaListaNegra : responseDataListasNegrasOut.data.ocurrencias){
            if(itemOcurrenciaPersonaListaNegra.accion.equals(ANEFI_Utilitarios.ACCION_BLOQUEAR)){
                estaPersonaEnListasNegras = true;
                break;
            }
        }
        String respuesta = estaPersonaEnListasNegras ? 'NotOK' : 'OK';
        lstRespuesta.add(respuesta);
        system.debug(estaPersonaEnListasNegras);
        return lstRespuesta;
    }
    public static ANEFI_ServicesDTO.ListasNegrasJuridicaInput obtInputListasNegrasPersonaJuridica(Id clienteId){
        List<Lead> clientes = [Select Id, Name, Numero_de_identificacion__c From Lead Where Id =: clienteId];
        if(clientes.size() > 0){
            ANEFI_ServicesDTO.ListasNegrasJuridicaInput listasNegrasJuridicaInputDTO = new ANEFI_ServicesDTO.ListasNegrasJuridicaInput();
            listasNegrasJuridicaInputDTO.identificacion = clientes.get(0).Numero_de_identificacion__c;
            //14 de Septiembre, se comenta esta línea ya que las personas de ANEFI solicitan que solo se envíe número de identifación también para personas jurídicas
            //listasNegrasJuridicaInputDTO.nombre = clientes.get(0).Name;
            return listasNegrasJuridicaInputDTO;            
        }
        return null;        
    }
}