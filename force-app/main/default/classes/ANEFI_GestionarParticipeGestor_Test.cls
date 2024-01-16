@isTest
private class ANEFI_GestionarParticipeGestor_Test {
    @isTest static void consultarInformacionPersonaNaturalEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
		Account clienteJuridico = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);
        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.ConsultaPersonaNatural respuesta = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaNaturalEnGestor(cliente.id);
        System.assertNotEquals(null, respuesta ,'El callout retorno no retorno respuesta.');
         
        
        //ANEFI_GestionarParticipeGestor.obtenerInformacionPersonaJuridicaEnGestor(requestHandler,cliente.id,'10563254');
        Test.stopTest();      
    }
     
	@isTest static void consultarInformacionPersonaJuridicaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
		Account clienteJuridico = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);
        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.ConsultaPersonaJuridica respuestaj = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(cliente.id);
        System.assertNotEquals(null, respuestaj,'El callout retorno no retorno respuesta.'); 
        
        
        //ANEFI_GestionarParticipeGestor.obtenerInformacionPersonaJuridicaEnGestor(requestHandler,cliente.id,'10563254');
        Test.stopTest();      
    }
    @isTest static void consultarCuentasDeParticipeEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
		Account clienteJuridico = ANEFI_MockupBuilderForTests.crearClienteJuridico(true);
        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        List<ANEFI_ServicesDTO.ItemCuentaParticipe> consu = ANEFI_GestionarParticipeGestor.consultarCuentasDeParticipeEnGestor(cliente.id,'121231213');
        System.debug('consu' + consu);
        System.assertNotEquals(null, consu,'El callout retorno no retorno respuesta.'); 
        
        
        //ANEFI_GestionarParticipeGestor.obtenerInformacionPersonaJuridicaEnGestor(requestHandler,cliente.id,'10563254');
        Test.stopTest();      
    }
     @isTest static void consultarMovimientosCuentaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInputs = ANEFI_MockupBuilderForTests.crearMovimientosCuentaParticipeInput();
        String movimientosCuentaInputString = JSON.serialize(movimientosCuentaParticipeInputs);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());    
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = null;
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = 
            (ANEFI_ServicesDTO.MovimientosCuentaParticipeInput)
        	JSON.deserialize(movimientosCuentaInputString, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput.class);             
         ANEFI_GestionarParticipeGestor.consultaMovimientosDeCuentaParticipe(cliente.id, movimientosCuentaParticipeInput);
       // ANEFI_ConsultarClienteEnGestorController.consultarMovimientosCuentaEnGestor(cliente.id, movimientosCuentaInputString);
        Test.stopTest();
    }
    @isTest static void consultarMovimientosCuentaEnGestorV1() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInputS = ANEFI_MockupBuilderForTests.crearMovimientosCuentaParticipeInput();
        String movimientosCuentaInputString = JSON.serialize(movimientosCuentaParticipeInputS);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        //ANEFI_ConsultarClienteEnGestorController.consultarMovimientosCuentaEnGestor(cliente.id, movimientosCuentaInputString);
         ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = 
            (ANEFI_ServicesDTO.MovimientosCuentaParticipeInput)
        	JSON.deserialize(movimientosCuentaInputString, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput.class);
        ANEFI_GestionarParticipeGestor.consultaInformacionAdicionalCuenta(Cliente.id, movimientosCuentaParticipeInput);
        Test.stopTest();
    }
    @isTest static void actualizarPersonaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);       
        Contact c = ANEFI_MockupBuilderForTests.crearContacto(true);
        c.accountId = cliente.id;
        c.Enviado_a_Gestor__c = false;
        c.Estado_civil__c = 'S';
        c.Numero_de_identificacion__c = '1714361901';
        c.Tipo_de_identificacion__c = '1';
        update c;
        cliente.Representante_Legal__c = c.Id;
        update cliente;
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_GestionarParticipeGestor.actualizarPersonaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c);
        ANEFI_GestionarParticipeGestor.obtInputActualizacionPersonaJuridica(cliente.id);
        ANEFI_GestionarParticipeGestor.inputRegistroRepresentanteLegal(c.id);
        Test.stopTest();
    }
    @isTest static void crearReferenciaBancariaEnGestor() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);
        ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInputs = ANEFI_MockupBuilderForTests.crearReferenciaBancariaInput();
        String registroReferenciaBancariaInputString = JSON.serialize(registroReferenciaBancariaInputs);
        Test.startTest();
        ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput = 
            (ANEFI_ServicesDTO.RegistroReferenciaBancariaInput)
        	JSON.deserialize(registroReferenciaBancariaInputString, ANEFI_ServicesDTO.RegistroReferenciaBancariaInput.class); 
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());        
        ANEFI_GestionarParticipeGestor.crearReferenciaBancariaEnGestor(cliente.id, cliente.Codigo_persona_en_Gestor__c, 'crearReferenciaBancaria', registroReferenciaBancariaInput);
        Test.stopTest();
    }
}