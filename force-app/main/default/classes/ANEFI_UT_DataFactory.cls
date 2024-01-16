/**
*Class Name: ANEFI_UT_DataFactory.
*Description: Clase utilitaria para crear registros de prueba.
*Created Date: 16/5/2023, 11:43 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 11/7/2023, 08:30 AM.
*/
public class ANEFI_UT_DataFactory {
	public static User createUserManager() {
        Profile profile1 = [Select Id from Profile where name = 'System Administrator' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test01',
                              lastName = 'Test01',
                              email = uniqueName + '@test01' + orgId + '.org',
                              Username = uniqueName + '@test01' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
    
    public static User createUser() {
        User um = ANEFI_UT_DataFactory.createUserManager();
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test',
                              lastName = 'Test',
                              email = uniqueName + '@test' + orgId + '.org',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ManagerId = um.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
    
    public static User createUserPardot() {
        Profile profile1 = [Select Id from Profile where name = 'B2BMA Integration User'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'B2BMA',
                              lastName = 'Integration',
                              email = uniqueName + '@test02' + orgId + '.org',
                              Username = uniqueName + '@test02' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
    
    public static Lead createLead() {
        User us = ANEFI_UT_DataFactory.createUser();
        Lead ld; 
        System.runAs(us) { 
        	ld = new Lead(FirstName = 'Test', LastName = 'Lead', OwnerId = us.Id, ANEFI_Date_assignment__c = System.today() - 120, 
                          RecordTypeId = Lead.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Persona_Natural').getRecordTypeId(),
                          Company = 'Test Company', Tipo_de_identificacion__c = '1', Numero_de_identificacion__c = '1053258974');
        	Insert ld;
        }    
        return ld;   
    }
    
    public static Account createAccount() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc; 
        System.runAs(us) { 
            acc = new Account();
            acc.Name = 'Test Account'; 
            acc.OwnerId = us.Id;
            acc.Tipo_de_identificacion__c = '1';
            acc.Numero_de_identificacion__c = '1713175071';
            acc.Codigo_persona_en_Gestor__c = '785486';
            acc.Correo_electronico__c = 'testemail@gmail.com'; 
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Natural').getRecordTypeId();
            acc.PrimerNombre__c = 'Test';
            acc.SegundoNombre__c = 'Test';
            acc.PrimerApellido__c = 'Account';
            acc.SegundoApellido__c = 'Account';
            
            Insert acc;
        }    
        return acc;   
    }
    
    public static Account updateAccount() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount(); 
        System.runAs(us) { 
            acc.Numero_de_identificacion__c = '1713175071';
            Update acc;
        }    
        return acc;   
    }
    
    public static Account createAccountBusiness() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc; 
        System.runAs(us) {            
            acc = new Account();
            acc.Name = 'Test Account2'; 
            acc.OwnerId = us.Id;
            acc.Tipo_de_identificacion__c = '2';
            acc.Numero_de_identificacion__c = '1713175072456';
            acc.Codigo_persona_en_Gestor__c = '785487';
            acc.Correo_electronico__c = 'testemail2@gmail.com'; 
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Juridica').getRecordTypeId();
            
            Insert acc;
        }    
        return acc;   
    }
    
    public static Contact createContact() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        Contact cont; 
        System.runAs(us) { 
        	cont = new Contact(FirstName = 'Test', LastName = 'Contact', OwnerId = us.Id, Tipo_de_identificacion__c = '1', Numero_de_identificacion__c = '1713175071',
                              AccountId = acc.Id);
        	Insert cont;
        }    
        return cont;   
    }
    
    public static Contact updateContact() {
        User us = ANEFI_UT_DataFactory.createUserPardot();
        Contact cont = ANEFI_UT_DataFactory.createContact();
        System.runAs(us) { 
        	cont.Email = 'testcont@gmail.com';
        	Update cont;
        }    
        return cont;   
    }
    
    public static Opportunity createOpportunity() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 
        System.runAs(us) { 
        	opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                  CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                  RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                  get('Gestion_de_Cuentas').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                  Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                  ANEFI_Business_line__c = 'Fondos');
        	Insert opp;
        }    
        return opp;   
    }
    
    public static Opportunity createOpportunity2() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 
        System.runAs(us) { 
        	opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                  CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                  RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                  get('Gestion_de_Cuentas').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                  Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                  ANEFI_Business_line__c = 'Negocios Fiduciarios');
        	Insert opp;
        }    
        return opp;   
    }
    
    public static Opportunity createOpportunity3() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp;
        Opportunity opp2;
        System.runAs(us) { 
        	opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                  CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                  RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                  get('Gestion_de_Cuentas').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                  Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                  ANEFI_Business_line__c = 'Negocios Fiduciarios');
        	Insert opp;
            
            opp2 = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                  CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                  RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                  get('Gestion_de_Cuentas').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                  Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                  ANEFI_Business_line__c = 'Negocios Fiduciarios');
        	Insert opp2;
        }    
        return opp2;   
    }
    
    public static Opportunity updateOpportunity() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F001', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }
    
    public static Opportunity updateOpportunityBusiness() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccountBusiness();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F001', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }
    
    public static Opportunity updateOpportunityF002() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F002', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }
    
    public static Opportunity updateOpportunityF003() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F003', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }
    
    public static Opportunity updateOpportunityF004() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F004', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }
    
    public static Opportunity updateOpportunityF005() {
        User us = ANEFI_UT_DataFactory.createUser();
        Account acc = ANEFI_UT_DataFactory.createAccount();
        
        Opportunity opp; 

        System.runAs(us) {
            opp = new Opportunity(Name = 'Test Opportunity', OwnerId = us.Id, AccountId = acc.Id, StageName = 'No Gestionado', 
                                      CloseDate = System.Today() + 120, Amount = 1200, ANEFI_Date_assignment__c = System.today() - 120,
                                      RecordTypeId = Opportunity.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().
                                      get('Negocios_Fiduciarios').getRecordTypeId(), Sincronizado_en_Gestor__c = true, 
                                      Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK', ANEFI_Opportunity_conversion__c = true,
                                      ANEFI_Business_line__c = 'Fondos', Producto_de_Interes__c = 'F005', 
                                      ANEFI_New_OwnerId__c = us.Id);
            Insert opp;
            
            opp.StageName = 'Cerrada ganada';
            opp.ANEFI_Contract_followup__c = 'Elaboración de contratos';
            update opp;
        }
        return opp;   
    }

}