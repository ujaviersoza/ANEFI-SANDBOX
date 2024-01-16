@isTest
public class ANEFI_CreaRescateTest {
    @TestSetup
    public static void makeData(){
        Account acc = new account(name = 'Pruea',PrimerNombre__c  = 's', SegundoNombre__c = 's', PrimerApellido__c = 's', SegundoApellido__c ='a',Correo_electronico__c = 'a@a.com', Tipo_de_identificacion__c = '1', Numero_de_identificacion__c = '1710083096');
        insert acc;
		ANEFI_Entidad_financiera__c entidad  = new ANEFI_Entidad_financiera__c  ();
		entidad.name = 'PICH';
        entidad.Nombre__c = 'PICH';
        insert entidad;
        entidad  = new ANEFI_Entidad_financiera__c  ();
		entidad.name = 'GUAY';
        entidad.Nombre__c = 'GUAY';
        insert entidad;
        ANEFI_Rescates_Programados__c  rescate = new ANEFI_Rescates_Programados__c();
        rescate.Anefi_Agencia__c = '01';
        rescate.Anefi_Codigo_Gestor_Participe__c = '958379';
        rescate.Anefi_CodigoMoneda__c = '1';
        rescate.Anefi_CodTipoTransaccion__c = 'PFP';
        rescate.Anefi_Entidad_Financiera_Destino__c = 'PICH';
        rescate.Anefi_Entidad_Financiera_Producto__c = 'GUAY';
        rescate.Anefi_Estado_Rescate__c = 'Activo';
        rescate.Anefi_Fecha_Ejecucion_Rescate__c = Date.today();
        rescate.Anefi_FechaEfectiva__c = '2020-02-02';
        rescate.Anefi_FormaDePago__c = 'TRANS';
        rescate.ANEFI_ManejaExcepcion__c = true;
        rescate.Anefi_MontoRescate__c = 10;
        rescate.Anefi_Numero_Cuenta_Gestor__c = '106701';
        rescate.Anefi_NumeroCuentaDestino__c = '2202816873';
        rescate.Anefi_NumeroCuentaProducto__c = '41259116';
        rescate.Anefi_Producto_Rescate__c = 'F001';
        rescate.ANEFI_Tipo_de_Rescate__c = 'PAR';
        rescate.Anefi_Tipo_Entidad_Financiera_Destino__c = '1';
        rescate.Anefi_Tipo_Entidad_Financiera_Producto__c = '1';
        rescate.Identificacion_Cuenta_Destino__c = 'asda';
        rescate.Titular_de_la_cuenta__c = 'preub';
        rescate.Anefi_Usuario_Creo_Rescate__c = UserInfo.getUserId();
        rescate.Anefi_CuentaRescate__c = acc.id;
        rescate.Tipo_Fondo__c = 'F001';
        rescate.Banco_Destino__c = 'PICH';
        rescate.Tipo_de_cuenta__C = 'Cheque';
        rescate.Name = 'Rescate cuenta ' +  acc.Name + ' mes ' + 'Junio' + ' año ' + '2020';
        insert rescate;
        ANEFI_MockupBuilderForTests.inicializarANEFIAPIName();
        ANEFI_MockupBuilderForTests.inicializarANEFIConfiguracionGestorWeb();
        

    }
    @isTest
    static void registraRescate(){
        List<ANEFI_Rescates_Programados__c> rescateConsulta = new List<ANEFI_Rescates_Programados__c>();
        rescateConsulta = [Select id,Anefi_Agencia__c,Anefi_CodigoMoneda__c,Anefi_FormaDePago__c,Anefi_CodTipoTransaccion__c, Anefi_CuentaRescate__c ,Anefi_Codigo_Gestor_Participe__c, Anefi_Entidad_Financiera_Destino__c,Anefi_Entidad_Financiera_Producto__c,
                           Anefi_Estado_Rescate__c, Banco_Destino__c,Anefi_FechaEfectiva__c,ANEFI_ManejaExcepcion__c,Anefi_MontoRescate__c,Anefi_NumeroCuentaDestino__c
                           ,Anefi_Numero_Cuenta_Gestor__c ,Anefi_NumeroCuentaProducto__c ,Anefi_Producto_Rescate__c ,Tipo_Fondo__c,Identificacion_Cuenta_Destino__c
                           ,ANEFI_Tipo_de_Rescate__c,Anefi_Tipo_Entidad_Financiera_Destino__c,Anefi_Tipo_Entidad_Financiera_Producto__c,Anefi_Usuario_Envio_Rescate__c
                           ,Titular_de_la_cuenta__c,ANEFI_Fecha_Envio_Rescate__c,Tipo_de_cuenta__C from ANEFI_Rescates_Programados__c where   Anefi_Estado_Rescate__c in ('Activo','Evento Creado','Con Error')];
        List<String> idRescate = new List<String>();
        idRescate.add(rescateConsulta[0].id);
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock()); 
        ANEFI_CreaRescate.creaRescate(idRescate);
        ANEFI_GestorHttpCalloutMock mockclass = new ANEFI_GestorHttpCalloutMock();
        mockclass.statusCode = 209;
        Test.setMock(HttpCalloutMock.class, mockclass); 
        ANEFI_CreaRescate.creaRescate(idRescate);
        
        ANEFI_CreaRescate.creaRescatePDF(rescateConsulta[0].Anefi_FechaEfectiva__c,rescateConsulta[0].Anefi_CuentaRescate__c,rescateConsulta[0].Tipo_Fondo__c,rescateConsulta[0].Anefi_NumeroCuentaProducto__c,rescateConsulta[0].ANEFI_Tipo_de_Rescate__c,rescateConsulta[0].Anefi_MontoRescate__c
                                        ,rescateConsulta[0].Identificacion_Cuenta_Destino__c,rescateConsulta[0].Titular_de_la_cuenta__c,rescateConsulta[0].Banco_Destino__C,rescateConsulta[0].Tipo_de_cuenta__C,rescateConsulta[0].Anefi_NumeroCuentaDestino__c);
        Test.stopTest();
       
        
    }
    @isTest
    static void  creaRescateProgramado(){
       List<ANEFI_Rescates_Programados__c> rescateConsulta = new List<ANEFI_Rescates_Programados__c>();
        rescateConsulta = [Select id,Anefi_Agencia__c,Anefi_CodigoMoneda__c,Anefi_FormaDePago__c,Anefi_CodTipoTransaccion__c, Anefi_CuentaRescate__c ,Anefi_Codigo_Gestor_Participe__c, Anefi_Entidad_Financiera_Destino__c,Anefi_Entidad_Financiera_Producto__c,
                           Anefi_Estado_Rescate__c, Anefi_FechaEfectiva__c,ANEFI_ManejaExcepcion__c,Anefi_MontoRescate__c,Anefi_NumeroCuentaDestino__c
                           ,Anefi_Numero_Cuenta_Gestor__c ,Anefi_NumeroCuentaProducto__c ,Anefi_Producto_Rescate__c ,Tipo_Fondo__c
                           ,ANEFI_Tipo_de_Rescate__c,Anefi_Tipo_Entidad_Financiera_Destino__c,Anefi_Tipo_Entidad_Financiera_Producto__c,Anefi_Usuario_Envio_Rescate__c
                           ,ANEFI_Fecha_Envio_Rescate__c,Anefi_Fecha_Ejecucion_Rescate__c from ANEFI_Rescates_Programados__c];
	ANEFI_CreaRescate.creaRescateProgramado( rescateConsulta[0].Anefi_Agencia__c,rescateConsulta[0].Anefi_CodigoMoneda__c,rescateConsulta[0].Anefi_FormaDePago__c,
                                            	rescateConsulta[0].Anefi_CodTipoTransaccion__c
                                               ,rescateConsulta[0].Anefi_CuentaRescate__c,
                                               rescateConsulta[0].Anefi_Codigo_Gestor_Participe__c,rescateConsulta[0].Anefi_Entidad_Financiera_Producto__c ,
                                            	rescateConsulta[0].Anefi_Entidad_Financiera_Destino__c,
                                               rescateConsulta[0].Anefi_FechaEfectiva__c,rescateConsulta[0].Anefi_Fecha_Ejecucion_Rescate__c,true, 100.00,
                                               rescateConsulta[0].Anefi_NumeroCuentaProducto__c,rescateConsulta[0].Anefi_NumeroCuentaDestino__c,rescateConsulta[0].Anefi_Numero_Cuenta_Gestor__c,
                                               rescateConsulta[0].Anefi_Producto_Rescate__c ,rescateConsulta[0].ANEFI_Tipo_de_Rescate__c ,  rescateConsulta[0].Anefi_Tipo_Entidad_Financiera_Destino__c, rescateConsulta[0].Anefi_Tipo_Entidad_Financiera_Destino__c,
                                               rescateConsulta[0].Anefi_Usuario_Envio_Rescate__c, '1', 0);    
    ANEFI_CreaRescate.creaRescateProgramado( rescateConsulta[0].Anefi_Agencia__c,rescateConsulta[0].Anefi_CodigoMoneda__c,rescateConsulta[0].Anefi_FormaDePago__c,
                                            	rescateConsulta[0].Anefi_CodTipoTransaccion__c
                                               ,rescateConsulta[0].Anefi_CuentaRescate__c,
                                               rescateConsulta[0].Anefi_Codigo_Gestor_Participe__c,rescateConsulta[0].Anefi_Entidad_Financiera_Producto__c ,
                                            	rescateConsulta[0].Anefi_Entidad_Financiera_Destino__c,
                                               rescateConsulta[0].Anefi_FechaEfectiva__c,rescateConsulta[0].Anefi_Fecha_Ejecucion_Rescate__c,true, 100.00,
                                               rescateConsulta[0].Anefi_NumeroCuentaProducto__c,rescateConsulta[0].Anefi_NumeroCuentaDestino__c,rescateConsulta[0].Anefi_Numero_Cuenta_Gestor__c,
                                               rescateConsulta[0].Anefi_Producto_Rescate__c ,rescateConsulta[0].ANEFI_Tipo_de_Rescate__c ,  rescateConsulta[0].Anefi_Tipo_Entidad_Financiera_Destino__c, rescateConsulta[0].Anefi_Tipo_Entidad_Financiera_Destino__c,
                                               rescateConsulta[0].Anefi_Usuario_Envio_Rescate__c, '2',3);        
    }
    @isTest
    static void consultaCuentas(){
        List<ANEFI_Rescates_Programados__c> rescateConsulta = new List<ANEFI_Rescates_Programados__c>();
        rescateConsulta = [Select id,Anefi_Agencia__c,Anefi_CodigoMoneda__c,Anefi_FormaDePago__c,Anefi_CodTipoTransaccion__c, Anefi_CuentaRescate__c ,Anefi_Codigo_Gestor_Participe__c, Anefi_Entidad_Financiera_Destino__c,Anefi_Entidad_Financiera_Producto__c,
                           Anefi_Estado_Rescate__c, Anefi_FechaEfectiva__c,ANEFI_ManejaExcepcion__c,Anefi_MontoRescate__c,Anefi_NumeroCuentaDestino__c
                           ,Anefi_Numero_Cuenta_Gestor__c ,Anefi_NumeroCuentaProducto__c ,Anefi_Producto_Rescate__c 
                           ,ANEFI_Tipo_de_Rescate__c,Anefi_Tipo_Entidad_Financiera_Destino__c,Anefi_Tipo_Entidad_Financiera_Producto__c,Anefi_Usuario_Envio_Rescate__c
                           ,ANEFI_Fecha_Envio_Rescate__c,Anefi_Fecha_Ejecucion_Rescate__c from ANEFI_Rescates_Programados__c];
        
        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock()); 
        
        ANEFI_CreaRescate.consultaCuentasReferenciaBancaria(rescateConsulta[0].Anefi_Codigo_Gestor_Participe__c,rescateConsulta[0].Anefi_CuentaRescate__c);
  		 Test.stopTest();
    
    }
     @isTest
    static void consultaCuentasBancarias(){
        List<ANEFI_Rescates_Programados__c> rescateConsulta = new List<ANEFI_Rescates_Programados__c>();
        rescateConsulta = [Select id,Anefi_Agencia__c,Anefi_CodigoMoneda__c,Anefi_FormaDePago__c,Anefi_CodTipoTransaccion__c, Anefi_CuentaRescate__c ,Anefi_Codigo_Gestor_Participe__c, Anefi_Entidad_Financiera_Destino__c,Anefi_Entidad_Financiera_Producto__c,
                           Anefi_Estado_Rescate__c, Anefi_FechaEfectiva__c,ANEFI_ManejaExcepcion__c,Anefi_MontoRescate__c,Anefi_NumeroCuentaDestino__c
                           ,Anefi_Numero_Cuenta_Gestor__c ,Anefi_NumeroCuentaProducto__c ,Anefi_Producto_Rescate__c 
                           ,ANEFI_Tipo_de_Rescate__c,Anefi_Tipo_Entidad_Financiera_Destino__c,Anefi_Tipo_Entidad_Financiera_Producto__c,Anefi_Usuario_Envio_Rescate__c
                           ,ANEFI_Fecha_Envio_Rescate__c,Anefi_Fecha_Ejecucion_Rescate__c from ANEFI_Rescates_Programados__c];
        
        
        Test.startTest();
        // Asociación del callout con el mock de la respuesta
        Test.setMock(HttpCalloutMock.class, new ANEFI_GestorHttpCalloutMock()); 
        
        ANEFI_CreaRescate.consultaCuentas(rescateConsulta[0].Anefi_Producto_Rescate__c,rescateConsulta[0].Anefi_CuentaRescate__c,true);
  		ANEFI_CreaRescate.consultaDatosMontosProducto(rescateConsulta[0].Anefi_Producto_Rescate__c,rescateConsulta[0].Anefi_CuentaRescate__c); 
        Test.stopTest();
    
    }
}