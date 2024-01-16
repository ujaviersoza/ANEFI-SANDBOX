/*
* Autor:        Jeffry Antonio Mejia Ocampos
* Fecha:        07/07/2022
* Ultima Mod:   07/07/2022
*/


@isTest
global class ANEFIFormularioOLRController_Test {
    @TestSetup
    private static void makeData(){
        List<User> user_lst = new List<User>();
        user_lst.add(new User(
            LastName = 'prueba',
            Alias = 'prb2',
            UserName = 'alexis@anefi.com.test',
            CommunityNickname = '001alexis',
            EmailEncodingKey = 'ISO-8859-1',
            Email = 'alexis@anefi.com.test',
            TimeZoneSidKey = 'America/Chicago',
            LocaleSidKey =  'en_US',            
            ProfileId = [SELECT Id FROM Profile where name in  ('Administrador del sistema','System Administrator') limit 1 ].Id,
            LanguageLocaleKey = 'en_US',
            FederationIdentifier = 'admin01',
            IsActive = true
        ));
        insert user_lst;
    }
    @isTest
    static void test01() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
            
            
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464913';
            insert actividadEconomica;
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
                Numero_de_identificacion__c='0102013010'
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
            Acc.Actividad_Economica__c = actividadEconomica.Id;
            ACC.Correo_electronico__c = 'axel@anefi.com';
            System.debug('Acc:DATA: '+Acc);
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(),
                AccountId=Acc.id ,
                Oportunidad_es_Aporte__c = true,
                Producto_de_Interes__c = 'F001'
            );
            insert Opp;
            opp.Amount = 500;
            opp.Producto_de_Interes__c = 'F002';
            
            opp.StageName = 'Cerrada ganada';
            update opp;
            PageReference testPage = Page.ANEFIFormularioOLR; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(Opp.Id));
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
            ANEFIFormularioOLRController ext = new ANEFIFormularioOLRController(sc);
        }
    }
    @isTest
    static void test02() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
            
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
                Numero_de_identificacion__c='0102013010'
            ); 
            insert RepLegal;
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464914';
            insert actividadEconomica;    
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
                Representante_Legal__c = RepLegal.id,
                Actividad_Economica__c = actividadEconomica.Id,
                Correo_electronico__c = 'axel@anefi.com'
            );
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id,
                OwnerId = UserInfo.getUserId()
            );
            insert Opp;
            
            opp.Amount = 500;
            opp.Producto_de_Interes__c = 'F001';
            update opp;
            opp.Producto_de_Interes__c = 'F002';
            update opp;
            opp.Producto_de_Interes__c = 'F003';
            update opp;
            opp.Producto_de_Interes__c = 'F004';
            opp.StageName = 'Cerrada ganada';
            update opp;
            
            PageReference testPage = Page.ANEFIFormularioOLR; 
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(Opp.Id));
            
            ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
            ANEFIFormularioOLRController ext = new ANEFIFormularioOLRController(sc);
            //delete opp;
            
        }
    }
    
    @isTest
    static void test03() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
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
                Numero_de_identificacion__c='0102001301'
            ); 
            insert RepLegal;
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464914';
            insert actividadEconomica;    
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
                Representante_Legal__c = RepLegal.id,
                Actividad_Economica__c = actividadEconomica.Id,
                Correo_electronico__c = 'axel@anefi.com'
            );
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id,
                OwnerId = UserInfo.getUserId(),
                Sincronizado_en_Gestor__c = true,
                Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK'
            );
            insert Opp;
            try{
                delete opp;
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('No se pueden eliminar oportunidades sincronizadas en Gestor'));
            
            }
            
        } 
    }
    
     @isTest
    static void test04() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
            List<RecordType> RecType = [Select id,Name from RecordType where DeveloperName =: 'Persona_Natural' AND SobjectType =: 'Account' ];
            
            ANEFI_Pais__c Nac = new ANEFI_Pais__c(
                Name='Pais Prueba'
            );
            insert Nac;
            ANEFI_Canton__c DirCanton = new ANEFI_Canton__c(Name='Prueba');
            insert DirCanton;
            Contact RepLegal = new Contact(
                LastName='Joaquin Test',
                Rol_en_la_empresa__c='Ejecutivo / Analista',
                Numero_de_identificacion__c='0102013010'
            ); 
            insert RepLegal;
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464914';
            insert actividadEconomica;    
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
                Representante_Legal__c = RepLegal.id,
                Actividad_Economica__c = actividadEconomica.Id,
                Correo_electronico__c = 'axel@anefi.com'
            );
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id,
                OwnerId = UserInfo.getUserId(),
                Sincronizado_en_Gestor__c = true,
                Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK'
            );
            insert Opp;
            try{
                delete opp;
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('No se pueden eliminar oportunidades sincronizadas en Gestor'));
            
            }
            opp.Producto_de_Interes__c = 'F004';
            opp.StageName = 'Cerrada ganada';
            update opp;
        } 
    }
     @isTest
    static void test05() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
            List<RecordType> RecType = [Select id,Name from RecordType where DeveloperName =: 'Persona_Natural' AND SobjectType =: 'Account' ];
            
            ANEFI_Pais__c Nac = new ANEFI_Pais__c(
                Name='Pais Prueba'
            );
            insert Nac;
            ANEFI_Canton__c DirCanton = new ANEFI_Canton__c(Name='Prueba');
            insert DirCanton;
            Contact RepLegal = new Contact(
                LastName='Joaquin Test',
                Rol_en_la_empresa__c='Ejecutivo / Analista',
                Numero_de_identificacion__c='0100201301'
            ); 
            insert RepLegal;
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464914';
            insert actividadEconomica;    
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
                Representante_Legal__c = RepLegal.id,
                Actividad_Economica__c = actividadEconomica.Id,
                Correo_electronico__c = 'axel@anefi.com'
            );
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id,
                OwnerId = UserInfo.getUserId(),
                Sincronizado_en_Gestor__c = true,
                Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK'
            );
            insert Opp;
            try{
                delete opp;
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('No se pueden eliminar oportunidades sincronizadas en Gestor'));
            
            }
            opp.Producto_de_Interes__c = 'F003';
            opp.StageName = 'Cerrada ganada';
            update opp;
            List<Opportunity> listOppo = new List<Opportunity>();
            listOppo.add(opp);
            ANEFI_OpportunityHelper.createLicitudFondosFile(listOppo);
        } 
    }
     @isTest
    static void test06() {
        User usr = [select id,name from user where username  = 'alexis@anefi.com.test'];
        system.runAs(usr){
            List<RecordType> RecType = [Select id,Name from RecordType where DeveloperName =: 'Persona_Natural' AND SobjectType =: 'Account' ];
            
            ANEFI_Pais__c Nac = new ANEFI_Pais__c(
                Name='Pais Prueba'
            );
            insert Nac;
            ANEFI_Canton__c DirCanton = new ANEFI_Canton__c(Name='Prueba');
            insert DirCanton;
            Contact RepLegal = new Contact(
                LastName='Joaquin Test',
                Rol_en_la_empresa__c='Ejecutivo / Analista',
                Numero_de_identificacion__c='0102013010'
            ); 
            insert RepLegal;
            ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c ();
            
            actividadEconomica.name = 'G464914';
            insert actividadEconomica;    
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
                Representante_Legal__c = RepLegal.id,
                Actividad_Economica__c = actividadEconomica.Id,
                Correo_electronico__c = 'axel@anefi.com'
            );
            insert Acc;
            
            Opportunity Opp = new Opportunity(
                Name = 'Opportunidad Test',
                StageName='Contacto inicial', 
                Amount=500000, 
                CloseDate=Date.today(), 
                AccountId= Acc.id,
                OwnerId = UserInfo.getUserId(),
                Sincronizado_en_Gestor__c = true,
                Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK'
            );
            insert Opp;
            try{
                delete opp;
            }catch(Exception ex){
                System.assert(ex.getMessage().contains('No se pueden eliminar oportunidades sincronizadas en Gestor'));
            
            }
            opp.Producto_de_Interes__c = 'F001';
            opp.StageName = 'Cerrada ganada';
            update opp;
            List<Opportunity> listOppo = new List<Opportunity>();
            listOppo.add(opp);
            ANEFI_OpportunityHelper.createLicitudFondosFile(listOppo);
        } 
    }
}