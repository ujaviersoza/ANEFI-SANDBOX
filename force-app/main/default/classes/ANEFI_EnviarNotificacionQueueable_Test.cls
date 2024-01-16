@isTest
public class ANEFI_EnviarNotificacionQueueable_Test {
    @TestSetup
    static void dataFactory(){
    	ANEFI_TestDataFactory.crearDatos();        
    }
    
   	/*Método para probar la ejecución de la clase como un job*/
  	@isTest
    static void enviarNotificacionQueueableTest(){        
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
                        
        string crearNotificacionResponse = '[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Su notificación personalizada se procesó correctamente."}}]';        
        
        ANEFI_SingleRequestMock mockCrearNotificacionResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         crearNotificacionResponse,
                                                         null);
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);        
        
        ANEFI_EnviarNotificacionQueueable.makeCallout = false;               
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_EnviarNotificacionQueueable enviarNotificacionError = new ANEFI_EnviarNotificacionQueueable(oportunidadDTO, 'Notificación sincronización oportunidad', 'Sincronización oportunidad');
        System.enqueueJob(enviarNotificacionError);       
        Test.stopTest();       
    }
	
    /*Método para probar la creación de notificación personalizada*/
  	@isTest
    static void enviarNotificacionTest(){        
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
                        
        string crearNotificacionResponse = '[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Su notificación personalizada se procesó correctamente."}}]';        
        
        ANEFI_SingleRequestMock mockCrearNotificacionResp = new ANEFI_SingleRequestMock(200,
                                                         'OK',
                                                         crearNotificacionResponse,
                                                         null);
        
        Map<String, HttpCalloutMock> endpointsTestResp =
                                   new Map<String,HttpCalloutMock>();
        
        endpointsTestResp.put(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction',mockCrearNotificacionResp);
 
        HttpCalloutMock multiCalloutMock = new ANEFI_MultiRequestMock(endpointsTestResp);        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidad);
        ANEFI_ServicesDTO.Oportunidad oportunidadDTO = (ANEFI_ServicesDTO.Oportunidad)
           											JSON.deserialize(oportunidadSerializada, ANEFI_ServicesDTO.Oportunidad.class);
        ANEFI_Utilitarios.crearNotificacionSincronizacionOportunidad(oportunidadDTO, 'Sincronización oportundidad', 'Oportunidad Sincronizada');     
        Test.stopTest();       
    }

}