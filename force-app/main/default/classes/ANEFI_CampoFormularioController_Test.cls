@isTest
private class ANEFI_CampoFormularioController_Test {
    @isTest static void consultarPaisPorCodigoTest() {
        ANEFI_Pais__c paisTest = new ANEFI_Pais__c(Name = 'Pais Prueba', Codigo_Pais__c = '999');
        insert paisTest;
        Test.startTest();
        ANEFI_CampoFormularioController.RespuestaConsultaObjeto respuesta = ANEFI_CampoFormularioController.consultarObjetoPorCodigo('ANEFI_Pais__c', paisTest.Codigo_Pais__c);
        Test.stopTest();
        System.assertEquals(respuesta.id, paisTest.Id, 'Los paises no coinciden por su id');
        System.assertEquals(respuesta.nombre, paisTest.Name, 'Los paises no coinciden por su nombre');
    }

    @isTest static void consultarActividadEconomicaPorCodigoTest() {
        ANEFI_Actividad_Economica__c actividadTest = new ANEFI_Actividad_Economica__c(Name = '99999');
        insert actividadTest;
        Test.startTest();
        ANEFI_CampoFormularioController.RespuestaConsultaObjeto respuesta = ANEFI_CampoFormularioController.consultarObjetoPorCodigo('ANEFI_Actividad_Economica__c', actividadTest.Name);
        Test.stopTest();
        System.assertEquals(respuesta.id, actividadTest.Id, 'Las actividades no coinciden por su id');
        System.assertEquals(respuesta.nombre, actividadTest.Name, 'Las actividades no coinciden por su nombre');
    }

    @isTest static void consultarCantonPorCodigoTest() {
        ANEFI_Canton__c cantonTest = new ANEFI_Canton__c(Name = '9999', Nombre_canton__c = 'Canton Prueba');
        insert cantonTest;
        Test.startTest();
        ANEFI_CampoFormularioController.RespuestaConsultaObjeto respuesta = ANEFI_CampoFormularioController.consultarObjetoPorCodigo('ANEFI_Canton__c', cantonTest.Name);
        Test.stopTest();
        System.assertEquals(respuesta.id, cantonTest.Id, 'Los cantones no coinciden por su id');
        System.assertEquals(respuesta.nombre, cantonTest.Nombre_canton__c, 'Los cantones no coinciden por su nombre');
    }

    @isTest static void consultarEnttidadFinacieraPorCodigoTest() {
        ANEFI_Entidad_financiera__c entidadTest = new ANEFI_Entidad_financiera__c(Name = '99999');
        insert entidadTest;
        Test.startTest();
        ANEFI_CampoFormularioController.RespuestaConsultaObjeto respuesta = ANEFI_CampoFormularioController.consultarObjetoPorCodigo('ANEFI_Entidad_financiera__c', entidadTest.Name);
        Test.stopTest();
        System.assertEquals(respuesta.id, entidadTest.Id, 'La entidades no coinciden por su id');
        System.assertEquals(respuesta.nombre, entidadTest.Name, 'La entidades no coinciden por su nombre');
    }
}