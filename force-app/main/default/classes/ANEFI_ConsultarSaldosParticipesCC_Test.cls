@isTest
public class ANEFI_ConsultarSaldosParticipesCC_Test {
    @isTest static void consultarSaldosCuentasDeParticipeTest() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput = new ANEFI_ServicesDTO.SaldosCuentasParticipeInput();
        saldosCuentasParticipeInput.codigoProducto = 'F001';
        saldosCuentasParticipeInput.fechaDesde = '2020-01-01';
        saldosCuentasParticipeInput.fechaHasta = '2020-01-31';
        saldosCuentasParticipeInput.pageNumber = 1;
        saldosCuentasParticipeInput.pageSize = 10;
        ANEFI_ConsultarSaldosCuentasParticipeCC.consultarSaldosCuentasDeParticipe(saldosCuentasParticipeInput);        
        Test.stopTest();  
    }
    
    @isTest static void consultarSaldosCuentasDeParticipeTodosTest() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        Account cliente = ANEFI_MockupBuilderForTests.crearClienteNatural(true);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput = new ANEFI_ServicesDTO.SaldosCuentasParticipeInput();
        saldosCuentasParticipeInput.codigoProducto = 'todos';
        saldosCuentasParticipeInput.fechaDesde = '2020-01-01';
        saldosCuentasParticipeInput.fechaHasta = '2020-01-31';
        saldosCuentasParticipeInput.pageNumber = 1;
        saldosCuentasParticipeInput.pageSize = 10;
        ANEFI_ConsultarSaldosCuentasParticipeCC.consultarSaldosCuentasDeParticipe(saldosCuentasParticipeInput);        
        Test.stopTest();  
    }
    
    @isTest static void enviarCorreoErrorGeneralTest() {  
        ANEFI_MockupBuilderForTests.crearUsuarioNotificacion();
        String endpointServicioGestor = '';
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(401);
        responseServicioGestor.setBody('prueba');
        responseServicioGestor.setStatus('Fallo');        
        String tipoDeError = ANEFI_Utilitarios.ERROR_GENERAL;
        String mensajeErrorInesperado = '';
        ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpointServicioGestor, responseServicioGestor,null, tipoDeError, mensajeErrorInesperado);
    }
    
    @isTest static void enviarCorreoErrorInesperadoTest() { 
        ANEFI_MockupBuilderForTests.crearUsuarioNotificacion();
        String endpointServicioGestor = '';
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(401);
        responseServicioGestor.setBody('prueba');
        responseServicioGestor.setStatus('Fallo');        
        String tipoDeError = ANEFI_Utilitarios.ERROR_INESPERADO;
        String mensajeErrorInesperado = 'Error inesperado';
        ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpointServicioGestor, responseServicioGestor,null, tipoDeError, mensajeErrorInesperado);
    }

    @isTest static void enviarCorreoErrorConflictoTest() { 
        ANEFI_MockupBuilderForTests.crearUsuarioNotificacion();
        String endpointServicioGestor = '';
        HttpResponse responseServicioGestor = new HttpResponse();
        responseServicioGestor.setStatusCode(401);
        responseServicioGestor.setBody('prueba');
        responseServicioGestor.setStatus('Fallo');        
        String tipoDeError = ANEFI_Utilitarios.ERROR_CONFLICTO;
        String mensajeErrorInesperado = 'Error inesperado';
        ANEFI_Utilitarios.enviarNotificacionFalloServicioGestor(endpointServicioGestor, responseServicioGestor,null, tipoDeError, mensajeErrorInesperado);
    }

}