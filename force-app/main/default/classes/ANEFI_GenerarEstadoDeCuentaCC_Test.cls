@isTest
public class ANEFI_GenerarEstadoDeCuentaCC_Test {
    /*Método para probar la generación del estado de una cuenta asociada a un cliente natural*/
    @isTest static void generarEstadoCuentaClienteNatural() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        ANEFI_MockupBuilderForTests.inicializarANEFIParametrosEmpresa(); 

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteExistenteEnGestor(true);

       

        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ApexPages.currentPage().getParameters().put('clienteId',cliente.Id);
        ApexPages.currentPage().getParameters().put('codigoProducto','F001');
        ApexPages.currentPage().getParameters().put('numeroCuentaParticipe','106701');
        ApexPages.currentPage().getParameters().put('fechaCorte','2020-10-27');
        ApexPages.currentPage().getParameters().put('fechaDesde','2020-10-20');
        ApexPages.currentPage().getParameters().put('nombreProducto','Fondo de Inversión');  
        ANEFI_GenerarEstadoDeCuentaController generarEstadoDeCuentaController = new ANEFI_GenerarEstadoDeCuentaController();
        Test.stopTest();      
    }
    
     /*Método para probar la generación del estado de una cuenta asociada a un cliente jurídico*/
    @isTest static void generarEstadoCuentaClienteJuridico() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        ANEFI_MockupBuilderForTests.inicializarANEFIParametrosEmpresa(); 

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridicoEnGestor(true);


        Test.startTest();
                Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());

        ApexPages.currentPage().getParameters().put('clienteId',cliente.Id);
        ApexPages.currentPage().getParameters().put('codigoProducto','F001');
        ApexPages.currentPage().getParameters().put('numeroCuentaParticipe','106701');
        ApexPages.currentPage().getParameters().put('fechaCorte','2020-10-27');
        ApexPages.currentPage().getParameters().put('nombreProducto','Fondo de Inversión');  
        ANEFI_GenerarEstadoDeCuentaController generarEstadoDeCuentaController = new ANEFI_GenerarEstadoDeCuentaController();
        generarEstadoDeCuentaController.guardarLogs();
         
        Test.stopTest();      
    }
    
    /*Método para probar la generación del estado de una cuenta con producto diferente a Fondo*/
    @isTest static void generarEstadoCuentaFideicomiso() {
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        ANEFI_MockupBuilderForTests.inicializarANEFIParametrosEmpresa(); 

        Account cliente = ANEFI_MockupBuilderForTests.crearClienteJuridicoEnGestor(true);

        

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock());
        ANEFI_GenerarEstadoDeCuentaController.consultarCuentasParticipeEnGestor(cliente.Id,'106701');
        ApexPages.currentPage().getParameters().put('clienteId',cliente.Id);
        ApexPages.currentPage().getParameters().put('codigoProducto','Fideicomiso');
        ApexPages.currentPage().getParameters().put('numeroCuentaParticipe','106701');
        ApexPages.currentPage().getParameters().put('fechaCorte','2020-10-27');
        ApexPages.currentPage().getParameters().put('fechaDesde','2020-10-20');
        ApexPages.currentPage().getParameters().put('nombreProducto','Fondo de Inversión');  
        
        ANEFI_GenerarEstadoDeCuentaController generarEstadoDeCuentaController = new ANEFI_GenerarEstadoDeCuentaController();
        generarEstadoDeCuentaController.guardarLogs();
         
        Test.stopTest();      
    }

}