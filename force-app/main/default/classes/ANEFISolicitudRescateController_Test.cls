/*
    * Autor:        Jeffry Antonio Mejia Ocampos
    * Fecha:        20/07/2022
    * Ultima Mod:   22/07/2022
    */
    @isTest
    global class ANEFISolicitudRescateController_Test {
        @isTest
        static void test01() {

            Account cuentaRescate = new Account();
            cuentaRescate.Name = 'Test Rescate';
            cuentaRescate.PrimerApellido__c = 'Prueba';
            cuentaRescate.Numero_de_identificacion__c = '9876543210';
            insert cuentaRescate; 


            ANEFI_Rescates_Programados__c rescate = new ANEFI_Rescates_Programados__c();
            rescate.name = 'Teste Rescate';
            rescate.AccountId__c = cuentaRescate.Id+'';
            rescate.Anefi_FechaEfectiva__c= '2022-06-20';
            rescate.Tipo_Fondo__c = 'TOT';
            rescate.Anefi_NumeroCuentaProducto__c = '41259116';
            rescate.ANEFI_Tipo_de_Rescate__c ='TOT';
            rescate.Anefi_MontoRescate__c= 0.00;
            rescate.Identificacion_Cuenta_Destino__c='0401579206';
            rescate.Titular_de_la_cuenta__c= 'Teste Rescate';
            rescate.Banco_Destino__c = '';
            rescate.Tipo_de_cuenta__c= 'Persona Natural';
            rescate.Anefi_NumeroCuentaDestino__c= '2202816873';

            insert rescate;

            PageReference testPage = Page.ANEFISolicitudRescate; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(rescate.Id));
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(rescate);     
            ANEFISolicitudRescateController ext = new ANEFISolicitudRescateController(sc);

        }

    
    }