@isTest
public class ANEFI_RequestsHandler_Test {
	@TestSetup
    static void dataFactory(){
    	ANEFI_TestDataFactory.crearDatos();        
    }
    
    @isTest
    static void getRequestLogsListTest(){
        ANEFI_RequestsHandler requestsHandler = new ANEFI_RequestsHandler();
        requestsHandler.getRequestLogsList();
    }
    
    @isTest
    static void logResponseTest(){
        ANEFI_RequestsHandler requestsHandler = new ANEFI_RequestsHandler();
        String URL_MAP = 'http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login';
        String body = '{"data": {"codigoPersona": 1028437}}';
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type','application/json');
        String method = 'Get';
        String statusCode = '200'; 
        String responseBody = '{"data": {"codigoPersona": 1028437}}';
        Map<String,String> URLParams = new Map<String, String>();
        requestsHandler.logResponse(URL_MAP, body, headers, method, statusCode, responseBody, URLParams);
    }
    
    @isTest
    static void buildURLTest(){
        ANEFI_RequestsHandler requestsHandler = new ANEFI_RequestsHandler();
        String endpoint = 'http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/movimientos';        
        Map<String,String> URLParams = new Map<String, String>();
        URLParams.put('fechaDesde','2020-08-05');
        URLParams.put('fechaHasta','2020-08-05');
        requestsHandler.buildURL(URLParams, endpoint);
    }
    
    @isTest
    static void processRequestUnauthorizedTest(){
        ANEFI_RequestsHandler requestsHandler = new ANEFI_RequestsHandler();
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where recordType.Name = 'Persona Jurídica' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }
        String endpoint = 'http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras';        
        Map<String,String> URLParams = new Map<String, String>();
		String body = '{"data": {"identificacion": 1001001001,"nombre": "empresa"}}';
		Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type','application/json');
        headers.put('Gestor-Token-App', '');
        headers.put('Gestor-Token-Env', '');
        headers.put('Authorization', 'Bearer ' + '');
        HttpResponse response = new HttpResponse();
        response.setStatusCode(401);        
        String method = 'POST';
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';
        
        ANEFI_SingleRequestMock mockAutenticacionResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         loginResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockListasNegrasResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         listasNegrasResponse,
                                                         null);
         Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);  
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        requestsHandler.processServiceResponse(endpoint, body, headers, method, URLParams, response, oportunidad.Id);
        Test.stopTest(); 
    }
}