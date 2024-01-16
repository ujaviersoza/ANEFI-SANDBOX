@isTest
public class ANEFI_CrearCuentaGestorQueueable_Test {
	@TestSetup
    static void dataFactory(){
    	ANEFI_TestDataFactory.crearDatos();        
    }

     /*Método para probar la sincronización de una oportunidad para persona jurídica en Gestor*/
  @isTest
    static void crearCuentaEnGestorPersonaJuridicaTest(){        
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
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar la invocación de la clase como un Job*/
   @isTest
    static void ejecutarOperacionesTest(){  
    	Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }
        
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();        
        ApexPages.StandardController sc = new ApexPages.StandardController(oportunidad);   
        ANEFI_DetallesIntegracionGestorCC controller = new ANEFI_DetallesIntegracionGestorCC(sc);
        controller.sincronizarOportunidadEnGestor();
        Test.stopTest(); 
        
    }
    
    /*Método para probar la sincronización de una oportunidad para persona natural en Gestor*/
  @isTest
    static void crearCuentaEnGestorPersonaNaturalTest(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where recordType.Name = 'Persona Natural' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }
        
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
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/natural',mockCrearPersonaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
   	/*Método para probar la sincronización de una oportunidad con código de persona en Gestor*/
   	@isTest
    static void sincronizarClienteConCodigoPersonaTest(){        
        Opportunity oportunidad = null; 
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where Name = 'Oportunidad Gestor' ];      
        
             
        if(oportunidades.size() > 0){
            
            oportunidad = oportunidades.get(0);            
            oportunidadDTO.oportunidadId = oportunidad.Id;
        	oportunidadDTO.tipoPersona = 'Persona Natural';
        	oportunidadDTO.clienteId = oportunidad.AccountId;             
            oportunidadDTO.propietarioId = oportunidad.OwnerId;
            oportunidadDTO.oportunidadNombre = oportunidad.Name;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('1028437') ;
            oportunidadDTO.numeroCuentaParticipe = null;
            oportunidadDTO.codigoProducto = oportunidad.Producto_de_Interes__c;
            oportunidadDTO.codigoTrader = oportunidad.Trader__c;
            oportunidadDTO.codigoCuentaContable = ANEFI_Utilitarios.CODIGO_CUENTA_CONTABLE;
            oportunidadDTO.complementarios = oportunidad.Complementarios__c;
            oportunidadDTO.transaccionCooparticipe = oportunidad.Transaccion_cooparticipe__c;
            oportunidadDTO.numeroTransaccionAporte = null;
            oportunidadDTO.fechaEfectiva = String.valueOf(oportunidad.Fecha_efectiva_primer_aporte__c);
            oportunidadDTO.numeroDocumento = oportunidad.Numero_documento_deposito__c;
            oportunidadDTO.codigoTipoFormaPago = oportunidad.Forma_de_Pago__c;
            oportunidadDTO.codigoMoneda = oportunidad.Moneda__c;
            oportunidadDTO.codigoTipoEntidadFondo = '1';
            oportunidadDTO.codigoEntidadFondo = oportunidad.Codigo_entidad_financiera__c;
            oportunidadDTO.numeroCuentaFondo = oportunidad.Numero_de_cuenta_fondo__c;
            oportunidadDTO.monto = oportunidad.Amount;            
        }
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';
        
        string validacionClienteResponse = '{"data": {"tipoRelacion": "NO_REGISTRADA",' + 
            				'"ocurrencias": []}}';
                        
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
        
        ANEFI_SingleRequestMock mockActualizarPersonaResp = new ANEFI_SingleRequestMock(204,
                                                         'No Content',
                                                         '',
                                                         null);
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarRegistrosCliente',mockValidacionClienteResp);        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/1028437/natural',mockActualizarPersonaResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);     
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        try{
            delete oportunidad;
        }
        catch(Exception e){
            
        }
        Test.stopTest();       
    }
    
    /*Método para probar la sincronización de una oportunidad con código de persona y número de cuenta de partícipe*/
   	@isTest
    static void sincronizarClienteConNumeroDeCuentaTest(){        
        Opportunity oportunidad = null; 
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where Name = 'Oportunidad Gestor' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
            oportunidadDTO.oportunidadId = oportunidad.Id;
        	oportunidadDTO.tipoPersona = 'Persona Natural';
        	oportunidadDTO.clienteId = oportunidad.AccountId; 
            oportunidadDTO.propietarioId = oportunidad.OwnerId;
            oportunidadDTO.oportunidadNombre = oportunidad.Name;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('1028437') ;
            oportunidadDTO.numeroCuentaParticipe = '108064';
            oportunidadDTO.codigoProducto = oportunidad.Producto_de_Interes__c;
            oportunidadDTO.codigoTrader = oportunidad.Trader__c;
            oportunidadDTO.codigoCuentaContable = ANEFI_Utilitarios.CODIGO_CUENTA_CONTABLE;
            oportunidadDTO.complementarios = oportunidad.Complementarios__c;
            oportunidadDTO.transaccionCooparticipe = oportunidad.Transaccion_cooparticipe__c;
            oportunidadDTO.numeroTransaccionAporte = null;
            oportunidadDTO.fechaEfectiva = String.valueOf(oportunidad.Fecha_efectiva_primer_aporte__c);
            oportunidadDTO.numeroDocumento = oportunidad.Numero_documento_deposito__c;
            oportunidadDTO.codigoTipoFormaPago = oportunidad.Forma_de_Pago__c;
            oportunidadDTO.codigoMoneda = oportunidad.Moneda__c;
            oportunidadDTO.codigoTipoEntidadFondo = '1';
            oportunidadDTO.codigoEntidadFondo = oportunidad.Codigo_entidad_financiera__c;
            oportunidadDTO.numeroCuentaFondo = oportunidad.Numero_de_cuenta_fondo__c;
            oportunidadDTO.monto = oportunidad.Amount;            
        }
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';
        
        string validacionClienteResponse = '{"data": {"tipoRelacion": "NO_REGISTRADA",' + 
            				'"ocurrencias": []}}';    
        
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
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearAporteResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockCrearNotificacionResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         crearNotificacionResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockActualizarPersonaResp = new ANEFI_SingleRequestMock(204,
                                                         'No Content',
                                                         '',
                                                         null);
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarRegistrosCliente',mockValidacionClienteResp);        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/1028437/natural',mockActualizarPersonaResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);     
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    } 
    
    /*Método para probar la sincronización con un error en el servicio de autenticación*/
   	@isTest
    static void sincronizarClienteConErrorTest(){        
        Opportunity oportunidad = null;  
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where recordType.Name = 'Persona Natural' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);                       
        }
        
        string loginResponse = '{"errors": [{"status": "400",' + 
            				'"title": "Invalid parameter",'+
            				'"detail": "Ambiente de operacion invalido. Verifique que los headers Gestor-Token-App y Gestor-Token-Env tengan los valores correctos."'+
            				'}]}';     
        
        ANEFI_SingleRequestMock mockAutenticacionResp = new ANEFI_SingleRequestMock(400,
                                                         'Bad Request',
                                                         loginResponse,
                                                         null);        
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);        
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);     
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
   /*Método para probar la sincronización de una oportunidad con el cliente asociado ya existente en Gestor*/
   @isTest
    static void sincronizarClienteYaExistenteTest(){        
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
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';      
        
        string validacionClienteResponse = '{"data": {"tipoRelacion": "CLIENTE",' + 
            '"ocurrencias": [{"codigoPersona": 1028437,"participe": "SIN_PORTAL","fideicomitente": "NO","beneficiario": "NO"}]}}';
        
        string crearCuentaResponse = '{"data": {"numeroCuenta": 108064}}';
        
        string crearAporteResponse = '{"data": {"numeroTransaccion": 3107493}}';        
        
        
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
        
        ANEFI_SingleRequestMock mockCrearCuentaResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearCuentaResponse,
                                                         null);  
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearAporteResponse,
                                                         null);      
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarRegistrosCliente',mockValidacionClienteResp);        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);        
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_SerializadorService.obtInputActualizacionPersonaJuridica(oportunidad.AccountId);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar la sincronización de una oportunidad con el cliente reportado en listas negras de Gestor*/
   @isTest
    static void sincronizarClienteReportadoEnListasNegrasTest(){        
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
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": true,' + 
            				'"ocurrencias": [{"nombreLista":"OBSERVADOS PROCURADURIA 2017",'+
            				'"mensaje":"CONSULTAR CON EL OFICIAL DE CUMPLIMIENTO QUE ES JULIO LLERENA",'+
            				'"codigoLista":"17","accion":"BLO"}]}}';       
        
        
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
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar que no es posible eliminar una oportunidad sincronizada en Gestor*/
   @isTest
    static void eliminarOportunidadSincronizadaEnGestorTest(){        
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
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"data": {"personaReportada": false,' + 
            				'"ocurrencias": []}}';
        
        string validacionClienteResponse = '{"data": {"tipoRelacion": "CLIENTE",' + 
            '"ocurrencias": [{"codigoPersona": 1028437,"participe": "SIN_PORTAL","fideicomitente": "NO","beneficiario": "NO"}]}}';
        
        string crearCuentaResponse = '{"data": {"numeroCuenta": 108064}}';
        
        string crearAporteResponse = '{"data": {"numeroTransaccion": 3107493}}';        
        
        
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
        
        ANEFI_SingleRequestMock mockCrearCuentaResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearCuentaResponse,
                                                         null);  
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         crearAporteResponse,
                                                         null);      
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarRegistrosCliente',mockValidacionClienteResp);        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);        
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        try{
            delete oportunidad;
        }
        catch(Exception e){
            
        }
        Test.stopTest();       
    }
    
     /*Método para probar la sincronización de una oportunidad con el cliente reportado en listas negras de Gestor*/
   @isTest
    static void sincronizarClienteConErrorDeValidacionesNegocioTest(){        
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
        
        string loginResponse = '{"data": {"tokenType": "bearer",' + 
            				'"accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCIsXCJyb2xcIjpcIlNVUEVSXCIsXCJlc3RhZG9DbGF2ZVwiOlwiVkFMSURBXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.sQzOaM5mwyUrPXTZtti5uxnfnNxc1vfmar_gXMzT5w0",'+
            				'"expiresIn": 7200,"refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiR0VTVE9SXCJ9IiwiZXhwIjoxNTk2NDk2NjkxLCJpYXQiOjE1OTY0ODk0OTF9.q2VVUmok8wZ3eM8TSt6YxlaHa0XTWubzwIBoDwMvSeg",'+
            				'"estadoClave": "VALIDA"}}';
        
        string listasNegrasResponse = '{"errors":[{"id":"12522","status":"error","code":"01",'+
            '"source":{"pointer": "1","parameter":"parameter"},"title": "title","detail": "string"}]}';       
        
        
        ANEFI_SingleRequestMock mockAutenticacionResp = new ANEFI_SingleRequestMock(201,
                                                         'Created',
                                                         loginResponse,
                                                         null);
        
        ANEFI_SingleRequestMock mockListasNegrasResp = new ANEFI_SingleRequestMock(409,
                                                         'Conflict',
                                                         listasNegrasResponse,
                                                         null);           
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login',mockAutenticacionResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/validarListasNegras',mockListasNegrasResp);          
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar el envío de mensaje de error de tipo conflicto en la consulta de información de cliente en Gestor*/
   	@isTest
    static void validarEnvioMensajeErrorConflictoConsultandoClienteTest(){
        Account cliente = [Select Id, Name from Account limit 1];
        String endpointServicioGestor = 'http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login';
        String tipoDeError = ANEFI_Utilitarios.ERROR_CONFLICTO;
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(400);
        responseServicioGestor.setStatus('Error');
        responseServicioGestor.setBody('Error');
        
       	ANEFI_Utilitarios.obtCorreoErrorConsultandoClienteEnGestor(endpointServicioGestor, responseServicioGestor, cliente.Id, tipoDeError, null);
    }
    
    /*Método para probar el envío de mensaje de error de tipo general en la consulta de información de cliente en Gestor*/
   	@isTest
    static void validarEnvioMensajeErrorGeneralConsultandoClienteTest(){
        Account cliente = [Select Id, Name from Account limit 1];
        String endpointServicioGestor = 'http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login';
        String tipoDeError = ANEFI_Utilitarios.ERROR_GENERAL;
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(400);
        responseServicioGestor.setStatus('Error');
        responseServicioGestor.setBody('Error');
        
       	ANEFI_Utilitarios.obtCorreoErrorConsultandoClienteEnGestor(endpointServicioGestor, responseServicioGestor, cliente.Id, tipoDeError, null);
    }
    
    /*Método para probar el envío de mensaje de error de tipo inesperado en la consulta de información de cliente en Gestor*/
   	@isTest
    static void validarEnvioMensajeErrorInesperadoConsultandoClienteTest(){
        Account cliente = [Select Id, Name from Account limit 1];
        String endpointServicioGestor = 'http://8.242.216.210:8100/gestor-api-rest/nn/gw/autorizacion/login';
        String tipoDeError = ANEFI_Utilitarios.ERROR_INESPERADO;
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(400);
        responseServicioGestor.setStatus('Error');
        responseServicioGestor.setBody('Error');
        
       	ANEFI_Utilitarios.obtCorreoErrorConsultandoClienteEnGestor(endpointServicioGestor, responseServicioGestor, cliente.Id, tipoDeError, 'Error inesperado');
    }
    
    /*Método para probar la sincronización de una oportunidad para persona natural con contacto en Gestor*/
   @isTest
    static void crearCuentaEnGestorPersonaNaturalConContactoTest(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where recordType.Name = 'Persona Natural' AND Name = 'Milena Perez - CP-1' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }
        
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
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/natural',mockCrearPersonaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar la sincronización de una oportunidad para persona natural con nombre completo en Gestor*/
   @isTest
    static void crearCuentaEnGestorPersonaNaturalConNombreCompletoTest(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name,AccountId,Amount,CloseDate,Producto_de_Interes__c,Fecha_efectiva_primer_aporte__c,
                                           Entidad_financiera__c, StageName, Firmo_el_contrato__c, Cliente_hizo_el_pago__c,
                                           Se_recopilo_nombramiento__c, Se_recopilo_RUC__c,Trader__c, Complementarios__c,
                                           Transaccion_cooparticipe__c, Numero_documento_deposito__c, Forma_de_Pago__c,Moneda__c, 
                                           recordTypeId, OwnerId, Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
                                           Numero_transaccion_aporte_en_gestor__c, Codigo_tipo_entidad_financiera__c,
                                           Codigo_entidad_financiera__c,Numero_de_cuenta_fondo__c
                                           from Opportunity where recordType.Name = 'Persona Natural' AND Name = 'Ricardo Andres Salazar Moreno - CP-1' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }
        
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
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/personas/natural',mockCrearPersonaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe',mockCrearCuentaResp);
        endpointsTestResp.put('http://8.242.216.210:8100/gestor-api-rest/gw/empresas/1/productos/F001/participes/1028437/cuentasParticipe/108064/aportes',mockCrearAporteResp);
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock =
                                   new ANEFI_MultiRequestMock(endpointsTestResp);        
        
                       
        ANEFI_CrearCuentaGestorQueueable.doChainJob = false;
        ANEFI_CrearCuentaGestorQueueable.makeCallout = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);             
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_CrearCuentaGestorQueueable.ejecutarOperaciones(oportunidadDTO);
        Test.stopTest();       
    }
    
    /*Método para probar la actualización de una oportunidad cuando no se sincroniza correctamente*/
    @isTest
    static void validarActualizacionOportunidadConErrorTest(){  
    	Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name from Opportunity where Name = 'Oportunidad - CP-1' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
        }        
        
        Test.startTest();        
        ApexPages.StandardController sc = new ApexPages.StandardController(oportunidad);   
        ANEFI_DetallesIntegracionGestorCC controller = new ANEFI_DetallesIntegracionGestorCC(sc);        
        Test.stopTest(); 
        
    }
    
    @isTest static void enviarNotificacionFalloServicioGestor() {        
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNaturalSoloNombre(true);        
        Test.startTest();
        String endpointServicioGestor = '';
        HttpResponse HttpResponse = new HttpResponse();
        HttpResponse.setBody('prueba');
        HttpResponse.setStatus('Prueba');
        HttpResponse.setStatusCode(401);
        ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpointServicioGestor,HttpResponse, cliente.Id, ANEFI_Utilitarios.ERROR_INESPERADO, 'Error consumiendo servicio');        
        Test.stopTest();
    }
    
    @isTest static void enviarNotificacionErrorInesperadoGestor() {        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);        
        Test.startTest();
        String endpointServicioGestor = '';
        HttpResponse HttpResponse = new HttpResponse();
        HttpResponse.setBody('prueba');
        HttpResponse.setStatus('Prueba');
        HttpResponse.setStatusCode(401);
        ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpointServicioGestor,HttpResponse, oportunidad.Id, ANEFI_Utilitarios.ERROR_INESPERADO, 'Error consumiendo servicio');        
        Test.stopTest();
    }
    
    @isTest static void procesarRespuestaValidacionListasNegras() {        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);        
        Test.startTest();
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
        oportunidadDTO.oportunidadId = oportunidad.Id;
        oportunidadDTO.propietarioId = oportunidad.OwnerId;
        oportunidadDTO.clienteId = oportunidad.AccountId;
        oportunidadDTO.oportunidadNombre = oportunidad.Name;
        
        ANEFI_ServicesDTO.ListasNegrasOut listasNegrasOut = new ANEFI_ServicesDTO.ListasNegrasOut();
        listasNegrasOut.personaReportada = true;
        List<ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra> ocurrencias = new List<ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra>();
        ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra ocurrencia = new ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra();
        ocurrencia.accion = 'ALE';
        ocurrencia.codigoLista = '';
        ocurrencia.mensaje = '';
        ocurrencia.nombreLista = '';
        ocurrencias.add(ocurrencia);     
        listasNegrasOut.ocurrencias = ocurrencias;
        ANEFI_Utilitarios.existePersonaEnListasNegrasDeGestor(oportunidadDTO, listasNegrasOut, 'Prueba', '1212121');        
        Test.stopTest();
    }  
    
    @isTest static void probarMetodosClaseSerializador() {        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);        
        Test.startTest();        
        ANEFI_SerializadorService.obtInputActualizacionReferenciaBancaria(null);
        ANEFI_SerializadorService.obtInputRegistroAporte(null);
        ANEFI_SerializadorService.obtInputRegistroCuentaParticipe(null);
        ANEFI_SerializadorService.obtInputValidacionRegistroCliente(null);
        ANEFI_SerializadorService.obtNombresApellidosClienteNatural(null);        
                
        Test.stopTest();
    }
    
    
    @isTest static void crearCuentaParticipeEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler;        
        Test.startTest();
        try{
          	ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
          	oportunidadDTO.oportunidadId = oportunidad.Id;
          	oportunidadDTO.clienteId = oportunidad.AccountId;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('102834');
            oportunidadDTO.codigoProducto = oportunidad.Producto_de_Interes__c;
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';
            
              ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
              ANEFI_CrearCuentaGestorQueueable.crearCuentaParticipeEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    }
    
    @isTest static void crearAporteEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler;        
        Test.startTest();
        try{
            ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
            oportunidadDTO.oportunidadId = oportunidad.Id;
            oportunidadDTO.clienteId = oportunidad.AccountId;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('102834');
            oportunidadDTO.codigoProducto = oportunidad.Producto_de_Interes__c;
            oportunidadDTO.numeroCuentaParticipe = '103421';
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';
            
            ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
            ANEFI_CrearCuentaGestorQueueable.crearRegistroAporteEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    }
    
     @isTest static void crearPrimerAporteEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler;        
        Test.startTest();
        try{
            ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
            oportunidadDTO.oportunidadId = oportunidad.Id;
            oportunidadDTO.clienteId = oportunidad.AccountId;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('102834');
            oportunidadDTO.codigoProducto = oportunidad.Producto_de_Interes__c;
            oportunidadDTO.numeroCuentaParticipe = '103421';
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';          
            
            ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
            ANEFI_CrearCuentaGestorQueueable.crearPrimerAporteEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    }    
    
    
     @isTest static void crearPersonaEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler;        
        Test.startTest();
        try{
            String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad); 
            ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
                                 
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';          
            
            ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
            ANEFI_CrearCuentaGestorQueueable.crearPersonaEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    } 
    
    
     @isTest static void crearPersonaYAporteEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler;        
        Test.startTest();
        try{
            String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad); 
            ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
                                 
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';          
            
            ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
            ANEFI_CrearCuentaGestorQueueable.personaReportadaEnListasNegras(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    } 
    
    @isTest static void crearAporteConErrorEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
        ANEFI_RequestsHandler requestHandler = New ANEFI_RequestsHandler(); 
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
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(401,
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
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
            oportunidadDTO.oportunidadId = oportunidad.Id;
            oportunidadDTO.clienteId = oportunidad.AccountId;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('1028437');
            oportunidadDTO.codigoProducto = 'F001';
            oportunidadDTO.numeroCuentaParticipe = '108064';
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';
            
            ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
            ANEFI_CrearCuentaGestorQueueable.crearRegistroAporteEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    }
    
    @isTest static void crearCuentaParticipeConErrorEnGestor(){        
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);
       ANEFI_RequestsHandler requestHandler = New ANEFI_RequestsHandler(); 
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
        
        ANEFI_SingleRequestMock mockCrearCuentaResp = new ANEFI_SingleRequestMock(401,
                                                         'Created',
                                                         crearCuentaResponse,
                                                         null);  
        
        ANEFI_SingleRequestMock mockCrearAporteResp = new ANEFI_SingleRequestMock(401,
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
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
          	ANEFI_ServicesDTO.Oportunidad oportunidadDTO = new ANEFI_ServicesDTO.Oportunidad();
          	oportunidadDTO.oportunidadId = oportunidad.Id;
          	oportunidadDTO.clienteId = oportunidad.AccountId;
            oportunidadDTO.codigoPersonaEnGestor = Integer.valueOf('1028437');
            oportunidadDTO.codigoProducto = 'F001';
            ANEFI_CrearCuentaGestorQueueable.configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
            ANEFI_ServicesDTO.LoginOUT loginOUT = new ANEFI_ServicesDTO.LoginOUT();
            loginOUT.accessToken = '1212121';
            loginOUT.estadoClave = 'valida';
            
              ANEFI_CrearCuentaGestorQueueable.loginOUTDTO = loginOUT;
              ANEFI_CrearCuentaGestorQueueable.crearCuentaParticipeEnGestor(requestHandler, oportunidadDTO);  
        } 
        catch(Exception e){
            
        }              
                
        Test.stopTest();
    }
       
}