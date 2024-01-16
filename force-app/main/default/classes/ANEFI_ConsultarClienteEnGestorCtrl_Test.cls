@isTest
private class ANEFI_ConsultarClienteEnGestorCtrl_Test {

    @isTest static void consultarInformacionPersonaNaturalEnGestorTest() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.ConsultaPersonaNatural respuesta = ANEFI_ConsultarClienteEnGestorController.consultarInformacionPersonaNaturalEnGestor(cliente.id);
        System.assertNotEquals(null, respuesta ,'El callout retorno no retorno respuesta.');
        Test.stopTest();  
    }

    @isTest static void consultarInformacionPersonaJuridicaEnGestorTest() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.ConsultaPersonaJuridica respuesta = ANEFI_ConsultarClienteEnGestorController.consultarInformacionPersonaJuridicaEnGestor(cliente.id);
        System.assertNotEquals(null, respuesta ,'El callout retorno no retorno respuesta.');
        Test.stopTest();
    }
    
    @isTest static void consultarRelacionPaisTest() {
        ANEFI_Pais__c pais = ANEFI_MockupBuilderForTests.crearPais(true);
        Test.startTest();
        String id = ANEFI_ConsultarClienteEnGestorController.consultarRelacion('ANEFI_Pais__c', pais.Codigo_Pais__c);
        Test.stopTest();
        System.assertNotEquals(null, pais ,'No se encontro el pais.');
        System.assertEquals(pais.id ,id , 'Los identificadores no coinciden.');
    }
	
    @isTest static void consultarRelacionActividadEconomicaTest() {
        ANEFI_Actividad_Economica__c actividad = ANEFI_MockupBuilderForTests.crearActividadEconomica(true);
        Test.startTest();
        String id = ANEFI_ConsultarClienteEnGestorController.consultarRelacion('ANEFI_Actividad_Economica__c', actividad.Name);
        Test.stopTest();
        System.assertNotEquals(null, actividad ,'No se encontro la actividad.');
        System.assertEquals(actividad.id ,id , 'Los identificadores no coinciden.');
    }

    @isTest static void consultarRelacionCantonTest() {
        ANEFI_Canton__c canton = ANEFI_MockupBuilderForTests.crearCanton(true);
        Test.startTest();
        String id = ANEFI_ConsultarClienteEnGestorController.consultarRelacion('ANEFI_Canton__c', canton.Name);
        Test.stopTest();
        System.assertNotEquals(null, canton ,'No se encontro el canton.');
        System.assertEquals(canton.id ,id , 'Los identificadores no coinciden.');
    }

    @isTest static void consultarRelacionEntidadFinancieraTest() {
        ANEFI_Entidad_financiera__c entidad = ANEFI_MockupBuilderForTests.crearEntidadFinanciera(true);
        Test.startTest();
        String id = ANEFI_ConsultarClienteEnGestorController.consultarRelacion('ANEFI_Entidad_financiera__c', entidad.Name);
        Test.stopTest();
        System.assertNotEquals(null, entidad ,'No se encontro la entidad.');
        System.assertEquals(entidad.id ,id , 'Los identificadores no coinciden.');
    }

    @isTest static void consultarCuentasParticipeEnGestorTest() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ConsultarClienteEnGestorController.consultarCuentasParticipeEnGestor(cliente.id, '1028437');
        Test.stopTest();
    }

    @isTest static void consultarMovimientosCuentaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = ANEFI_MockupBuilderForTests.crearMovimientosCuentaParticipeInput();
        String movimientosCuentaInputString = JSON.serialize(movimientosCuentaParticipeInput);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.consultarMovimientosCuentaEnGestor(cliente.id, movimientosCuentaInputString);
        Test.stopTest();
    }
    
    @isTest static void consultarInformacionAdicionalCuentaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = ANEFI_MockupBuilderForTests.crearMovimientosCuentaParticipeInput();
        String movimientosCuentaInputString = JSON.serialize(movimientosCuentaParticipeInput);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.consultaInformacionAdicionalCuenta(cliente.id, movimientosCuentaInputString);
        Test.stopTest();
    }

	@isTest static void actualizarPersonaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Contact contactRl = new Contact();
        contactRL.FirstName = 'Prueba';
        contactRL.LastName = 'Apellido Prueba';
        contactRL.Email = 'prueba@gmail.com';
        contactRL.Enviado_a_Gestor__c = FALSE;
        contactRL.Fecha_de_nacimiento__c = Date.today();
        insert contactRL;
        SYstem.debug('contacto ' + contactRL);
        cliente.Representante_Legal__c = contactRL.Id;
        update cliente;
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());  
     
        
        ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c);
        Test.stopTest();
    }
    
    @isTest static void actualizarClienteConContactoEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteYContactoEnGestor(true);        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c);
        Test.stopTest();
    }
    
    @isTest static void actualizarClienteJuridicoEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridicoEnGestor(true);        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c);
        Test.stopTest();
    }
    
    @isTest static void actualizarClienteJuridicoEnGestorCorreo() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridicoEnGestor(true);        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestorCorreo(cliente.id, cliente.Codigo_persona_en_Gestor__c, cliente.Correo_electronico__c, 'S','S');
        Test.stopTest();
    }
    
    @isTest static void crearReferenciaBancariaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput = ANEFI_MockupBuilderForTests.crearReferenciaBancariaInput();
        String registroReferenciaBancariaInputString = JSON.serialize(registroReferenciaBancariaInput);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.registrarReferenciaBancariaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c, 'crearReferenciaBancaria', registroReferenciaBancariaInputString);
        Test.stopTest();
    }
    
    @isTest static void actualizarReferenciaBancariaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput = ANEFI_MockupBuilderForTests.crearReferenciaBancariaInput();
        String registroReferenciaBancariaInputString = JSON.serialize(registroReferenciaBancariaInput);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_ConsultarClienteEnGestorController.registrarReferenciaBancariaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c, 'actualizarReferenciaBancaria', registroReferenciaBancariaInputString);
        Test.stopTest();
    }
    
    @isTest static void obtenerNombresYApellidosCliente() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);        
        Test.startTest();
        ANEFI_SerializadorService.obtNombresApellidosClienteNatural(cliente.Name.Split(' '));
        Test.stopTest();
    }
    
    @isTest static void obtenerNombresYApellidosClienteSoloNombre() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNaturalSoloNombre(true);        
        Test.startTest();
        ANEFI_SerializadorService.obtNombresApellidosClienteNatural(cliente.Name.Split(' '));
        Test.stopTest();
    }
    
    @isTest static void detallesIntegracionGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Opportunity oportunidad = ANEFI_MockupBuilderForTests.crearOportunidad(true);  
        oportunidad.Estado_sincronizacion_Gestor__c = 'ERROR SINCRONIZACIÓN';
        update oportunidad;
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(oportunidad);
        //ANEFI_DetallesIntegracionGestorCC detallesIntegracionGestor = new ANEFI_DetallesIntegracionGestorCC(stdController);        
        Test.stopTest();
    }
    
    /*Método para probar la consulta por subcadena de entidades financieras desde el componente de creación de oportunidades de aporte*/
    @isTest static void findRecords(){        
        ANEFI_Entidad_financiera__c entidadFinanciera = ANEFI_MockupBuilderForTests.crearEntidadFinanciera(true);        
        Test.startTest();
        ANEFI_ConsultarClienteEnGestorController.findRecords('ENTIDAD001', 'ANEFI_Entidad_financiera__c', 'Name', 'F001');        
        Test.stopTest();
    }
    
    /*Método para probar la consulta de tipos de registro de oportunidad de acuerdo con el tipo de registro del cliente asociado*/
    @isTest static void obtenerTiposRegistroOportunidadPorCliente(){  
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);              
        Test.startTest();
        ANEFI_ConsultarClienteEnGestorController.obtenerTiposRegistroOportunidad(cliente.Id);   
        Test.stopTest();
    }
    
    /*Método para probar la consulta de tipos de registro de oportunidad*/
    @isTest static void obtenerTiposRegistroOportunidad(){                     
        Test.startTest();
        ANEFI_ConsultarClienteEnGestorController.obtenerTiposRegistroOportunidad(null);   
        Test.stopTest();
    }
    
    /*Método para probar la consulta de cliente Id por contacto*/
    @isTest static void obtenerClienteIdPorContacto(){                     
        Test.startTest();
        Contact contacto = ANEFI_MockupBuilderForTests.crearContacto(true);        
        ANEFI_ConsultarClienteEnGestorController.obtenerClienteId(contacto.Id);   
        Test.stopTest();
    }
    
    /*Método para probar la consulta de cliente Id*/
    @isTest static void obtenerClienteId(){                     
        Test.startTest();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);        
        ANEFI_ConsultarClienteEnGestorController.obtenerClienteId(cliente.Id);   
        Test.stopTest();
    }
    
    @isTest static void inputRegistroRepresentanteLegal(){
        Test.startTest();
        Contact contacto = ANEFI_MockupBuilderForTests.crearContacto(true);        
        ANEFI_GestionarParticipeGestor.inputRegistroRepresentanteLegal(contacto.Id);
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock()); 
        
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();
       	ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    	ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
        
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, contacto.Id, configuracionGestorWeb);        
       // ANEFI_GestionarParticipeGestor.crearPersonaRlEnGestor(requestHandler,loginOUTDTO,contacto.Id);
        Test.stopTest();
    }
    

    
    
    
}