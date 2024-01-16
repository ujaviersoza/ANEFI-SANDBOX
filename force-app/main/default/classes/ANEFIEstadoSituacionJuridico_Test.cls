/**
 * @description       : 
 * @author            : Jeffry Mejia
 * @group             : 
 * @last modified on  : 11-05-2022
 * @last modified by  : Jeffry Mejia
**/
@isTest
public with sharing class ANEFIEstadoSituacionJuridico_Test {
    @isTest
    static void test01() {
        

        ANEFI_Actividad_Economica__c ActEco = new ANEFI_Actividad_Economica__c(
            Name = 'test'
        );
        ANEFI_Pais__c paisDirTrab = new ANEFI_Pais__c(
            Name = 'test'
        );
        Contact repLegal = new 	Contact(
            FirstName = '',
            MiddleName = '',
            LastName = '',
            email = '',
            Numero_de_identificacion__c = '',
            Rol_en_la_empresa__c = ''

        );
        ANEFI_Entidad_financiera__c entFinanciera = new ANEFI_Entidad_financiera__c(
            Name = 'test'
        );
        // Numero_de_identificacion__c, 
        // Actividad_Economica__r.Name, 
        
        // Pais_direccion_trabajo__r.Name, 
        // Provincia_direccion_trabajo__c, 
        // Calle_principal_direccion_trabajo__c, 
        // Interseccion_direccion_trabajo__c, 
        
        // Phone, 
        // Correo_electronico__c, 
        // Representante_Legal__r.FirstName, 
        // Representante_Legal__r.MiddleName, 
        // Representante_Legal__r.LastName, 
        // representante_Legal__r.email,
        // representante_Legal__r.Numero_de_identificacion__c,
        // representante_Legal__r.Rol_en_la_empresa__c,
        // Total_activos__c,
        // Total_pasivos__c,
        // Total_patrimonio__c,
        // Entidad_financiera__r.name,
        // Numero_de_cuenta_bancaria__c 
        Account Acc = new Account();
        Acc.PrimerNombre__c = 'Jorge';
        Acc.Name = 'Jorge Test';
        Acc.PrimerApellido__c = 'Prueba';
        Acc.Numero_de_identificacion__c = '9876543210';
        Acc.Actividad_Economica__c = ActEco.Id;
        Acc.Pais_direccion_trabajo__c = paisDirTrab.Id;
        // Acc.Provincia_direccion_trabajo__c = null;
        Acc.Calle_principal_direccion_trabajo__c = 'null';
        Acc.Interseccion_direccion_trabajo__c = 'null';
        Acc.Phone = '12121212';
        Acc.Representante_Legal__c = repLegal.Id;
        // Acc.Representante_Legal__r.MiddleName = null;
        // Acc.Representante_Legal__r.LastName = null;
        // Acc.representante_Legal__r.email = null;


        // Acc.representante_Legal__r.Numero_de_identificacion__c = null;
        // Acc.representante_Legal__r.Rol_en_la_empresa__c = null;
        Acc.Total_activos__c = 100.00;
        Acc.Total_pasivos__c = 100.00;
        Acc.Total_patrimonio__c = 100.00;
        Acc.Entidad_financiera__c = entFinanciera.Id;
        Acc.Numero_de_cuenta_bancaria__c = 'null';


        insert Acc;
        

        
        Opportunity Opp = new Opportunity(
            Name = 'Opportunidad Test',
            Producto_de_Interes__c = 'F002',
            // Numero_oportunidad__c = 9090,
            StageName='Contacto inicial', 
            Amount=500000, 
            CloseDate=Date.today(),
            AccountId=Acc.id 
            );
        insert Opp;
        
        PageReference testPage = Page.ANEFIEstadoSituacionJuridico; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(Opp.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
        ANEFIEstadoSituacionJuridico_Controller ext = new ANEFIEstadoSituacionJuridico_Controller(sc);
    }

    
}