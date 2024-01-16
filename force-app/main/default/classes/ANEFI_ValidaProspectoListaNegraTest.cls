@isTest
public class ANEFI_ValidaProspectoListaNegraTest {
	@TestSetup
    static void dataFactory(){
    	Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.Numero_de_identificacion__c = '0702078122';
        l.Tipo_de_identificacion__c = '1';
        l.Company = 'ANEFI';
        insert l;
        
        
    }
     
 	 @isTest
    static void crearCuentaEnGestorPersonaJuridicaTest(){        
           
        ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb = new ANEFI_Configuracion_Gestor_Web__c();
        configuracionGestorWeb.Clave__c = 'GESTORGE';
        configuracionGestorWeb.Gestor_Token_App__c = 'anefi';
        configuracionGestorWeb.Gestor_Token_Env__c = 'cHJ1ZWJh';
        configuracionGestorWeb.Instancia__c = 'PRUEBAS';
        configuracionGestorWeb.URL__c = 'http://8.242.216.210:8100/gestor-api-rest';
        configuracionGestorWeb.Usuario__c = '	GESTOR';
        insert configuracionGestorWeb;
         
        
        ANEFI_Configuracion_Gestor_Web__c configuracionGestorWebProduccion = new ANEFI_Configuracion_Gestor_Web__c();
        configuracionGestorWebProduccion.Clave__c = 'GESTORGE';
        configuracionGestorWebProduccion.Gestor_Token_App__c = 'anefi';
        configuracionGestorWebProduccion.Gestor_Token_Env__c = 'cHJ1ZWJh';
        configuracionGestorWebProduccion.Instancia__c = 'PRODUCCION';
        configuracionGestorWebProduccion.URL__c = 'http://8.242.216.210:8100/gestor-api-rest';
        configuracionGestorWebProduccion.Usuario__c = '	GESTOR';
        configuracionGestorWebProduccion.SetupOwnerId = UserInfo.getUserId();
        insert configuracionGestorWebProduccion; 
        
        ANEFI_API_Name__c registroPersonaJuridicaApi = new ANEFI_API_Name__c();
        registroPersonaJuridicaApi.Name = 'registroPersonaJuridica';
        registroPersonaJuridicaApi.URL_Name__c = '/gw/personas/juridica';
        insert registroPersonaJuridicaApi;
        
        ANEFI_API_Name__c registroPersonaNaturalApi = new ANEFI_API_Name__c();
        registroPersonaNaturalApi.Name = 'registroPersonaNatural';
        registroPersonaNaturalApi.URL_Name__c = '/gw/personas/natural';
        insert registroPersonaNaturalApi;
            
        ANEFI_API_Name__c loginApi = new ANEFI_API_Name__c();
        loginApi.Name = 'login';
        loginApi.URL_Name__c = '/nn/gw/autorizacion/login';
        insert loginApi;
        
        ANEFI_API_Name__c validacionRegistrosClienteApi = new ANEFI_API_Name__c();
        validacionRegistrosClienteApi.Name = 'validacionRegistrosCliente';
        validacionRegistrosClienteApi.URL_Name__c = '/gw/personas/validarRegistrosCliente';
        insert validacionRegistrosClienteApi;
        
        ANEFI_API_Name__c validacionListasNegrasApi = new ANEFI_API_Name__c();
        validacionListasNegrasApi.Name = 'validacionListasNegras';
        validacionListasNegrasApi.URL_Name__c = '/gw/personas/validarListasNegras';
        insert validacionListasNegrasApi;  
        List<Lead> leads = [Select Id, Name,Numero_de_identificacion__c
                                           from Lead ];
        
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';
        
        string validacionClienteResponse = '{"data": {"tipoRelacion": "NO_REGISTRADA",' + 
            				'"ocurrencias": []}}';
        
        string crearPersonaResponse = '{"data": {"codigoPersona": 1028437}}';
        
        string crearCuentaResponse = '{"data": {"numeroCuenta": 108064}}';
        
        string crearAporteResponse = '{"data": {"numeroTransaccion": 3107493}}';
        
        string crearNotificacionResponse = '[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Su notificación personalizada se procesó correctamente."}}]';
        
        ANEFI_SingleRequestMock mockAutenticacionResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         loginResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockListasNegrasResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         listasNegrasResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockValidacionClienteResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         validacionClienteResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockCrearPersonaResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearPersonaResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockCrearCuentaResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearCuentaResponse,
                                                         null);  
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearAporteResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockCrearNotificacionResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         crearNotificacionResponse,
                                                         null);
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarRegistrosCliente',mockValidacionClienteResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/juridica',mockCrearPersonaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);  
        List<String> lstIds = new List<String>();
        lstIds.add(leads.get(0).Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        ANEFI_ValidaProspectoListaNegra.validaProspecto(lstIds);
         Test.stopTest(); 
    }
}