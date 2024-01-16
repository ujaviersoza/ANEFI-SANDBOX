/*
    * Autor:        Jeffry Antonio Mejia Ocampos
    * Fecha:        07/07/2022
    * Ultima Mod:   07/07/2022
    */
    @isTest
    global class ANEFIContratoIncorpFSFS2Controller_Test {
        @isTest
        static void test01() {
            
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
            System.debug('Acc:DATA: '+Acc);
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(),
                AccountId=Acc.id 
                );
            insert Opp;
    
            PageReference testPage = Page.ANEFIContratoIncorpFSFS2; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(Opp.Id));
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
            ANEFIContratoIncorpFSFS2Controller ext = new ANEFIContratoIncorpFSFS2Controller(sc);
        }
        @isTest
        static void test02() {
    
            List<RecordType> RecType = [Select id,Name from RecordType where DeveloperName =: 'Persona_Juridica' AND SobjectType =: 'Account' ];
    
            ANEFI_Pais__c Nac = new ANEFI_Pais__c(
                Name='Pais Prueba'
            );
            insert Nac;
            ANEFI_Canton__c DirCanton = new ANEFI_Canton__c(Name='Prueba');
            insert DirCanton;
            Contact RepLegal = new Contact(
                LastName='Joaquin Test',
                Rol_en_la_empresa__c='Ejecutivo / Analista',
                Numero_de_identificacion__c='010201301'
            ); 
            insert RepLegal;
    
            Account Acc= new Account(
                Name= 'Jorge Prueba',
                Nacionalidad__c = Nac.id,
                Estado_civil__c='S',
                RecordTypeId = RecType[0].id,
                Calle_principal_direccion_domicilio__c = 'Calle Domicilio',
                Calle_principal_direccion_trabajo__c = 'Calle Trabajo',
                Numero_direccion_trabajo__c = '0010012',
                Canton_direccion_de_trabajo__c = DirCanton.id,
                Canton_direccion_domicilio__c = DirCanton.id,
                Pais_direccion_domicilio__c  = Nac.id,
                Pais_direccion_trabajo__c  = Nac.id,
                Representante_Legal__c = RepLegal.id
            );
            insert Acc;
    
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id
                );
            insert Opp;
            
            PageReference testPage = Page.ANEFIContratoIncorpFSFS2; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(Opp.Id));
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
            ANEFIContratoIncorpFSFS2Controller ext = new ANEFIContratoIncorpFSFS2Controller(sc);
    
            
        }
    
    }