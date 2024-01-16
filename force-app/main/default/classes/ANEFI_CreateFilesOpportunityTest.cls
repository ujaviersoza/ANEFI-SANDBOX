@isTest
public with sharing class ANEFI_CreateFilesOpportunityTest {
    @TestSetup
    static void makeData() {
        
        List<RecordType> RecType = [Select id, Name,DeveloperName from RecordType where DeveloperName =: 'Persona_Natural' AND SobjectType =: 'Account'  ];

        ANEFI_Pais__c Nac = new ANEFI_Pais__c(
            Name='Pais Prueba'
        );
        System.debug('Nac:DATA: '+Nac);
        insert Nac;
        ANEFI_Canton__c DirCanton = new ANEFI_Canton__c(Name='Prueba');
        insert DirCanton;
        Contact RepLegal = new Contact(
            LastName='Joaquin Test',
            Rol_en_la_empresa__c='Ejecutivo / Analista',
            Numero_de_identificacion__c='010201301'
        ); 
        insert RepLegal;
        System.debug('Rep:DATA: '+RepLegal);

        Account Acc = new Account();
        
        Acc.PrimerNombre__c = 'Jorge';
        Acc.Name = 'Jorge Test';
        Acc.PrimerApellido__c = 'Prueba';
        Acc.Nacionalidad__c = Nac.id;
        Acc.Estado_civil__c='S';
        Acc.Calle_principal_direccion_domicilio__c = 'Calle Domicilio';
        Acc.Calle_principal_direccion_trabajo__c = 'Calle Trabajo';
        Acc.Numero_direccion_trabajo__c = '0010012';
        Acc.Canton_direccion_de_trabajo__c = DirCanton.id;
        Acc.Canton_direccion_domicilio__c = DirCanton.id;
        Acc.Pais_direccion_domicilio__c  = Nac.id;
        Acc.Pais_direccion_trabajo__c  = Nac.id;
        Acc.Representante_Legal__c = RepLegal.id;
        acc.Numero_de_identificacion__c = '1310200744';
        acc.Tipo_de_identificacion__c = '1';
        acc.Correo_electronico__c  = 'axel.landa@test.com';
        System.debug('Acc:DATA: '+Acc);
        insert Acc;
        
        Opportunity Opp = new Opportunity(
            Name = 'Opportunidad Test',
            StageName='Contacto inicial', 
            Amount=500000, 
            CloseDate=Date.today(),
            AccountId=Acc.id ,
            Producto_de_Interes__c = 'F001'
            );
        insert Opp;

    }
    
    @isTest
    static void test01(){

        Opportunity opp = [Select id from Opportunity];
        ANEFI_CreateFilesOpportunity.createContractFilesOpportunity(opp.Id,'F001');
        ANEFI_CreateFilesOpportunity.createContractFilesOpportunity(opp.Id,'F002');
        ANEFI_CreateFilesOpportunity.createContractFilesOpportunity(opp.Id,'F003');
        ANEFI_CreateFilesOpportunity.createContractFilesOpportunity(opp.Id,'F004');
        ANEFI_CreateFilesOpportunity.createContractFilesOpportunity(opp.Id,'F005');
        ANEFI_CreateFilesOpportunity.createAccountPersonFilesOpportunity(opp.id,false);
        ANEFI_CreateFilesOpportunity.createAccountBusinessFilesOpportunity(opp.Id,false);
        ANEFI_CreateFilesOpportunity.createFileContractFASOpportunity(opp.Id);
        
        List<String> lstOpp =  new list<String>();
        lstOpp.add(opp.Id);

        ANEFI_CreateFilesOpportunity.createFiles(lstOpp);

        lstOpp =  new list<String>();
        Account acc = [Select id From Account];
        lstOpp.add(acc.Id);
        
        ANEFI_CreateFilesOpportunity.createFiles(lstOpp);

    }
}