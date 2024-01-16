/*
* Autor:        Jeffry Antonio Mejia Ocampos
* Fecha:        21/07/2022
* Ultima Mod:   22/07/2022
*/
@isTest
global class ANEFICondicionesFirmasController_Test {
    @isTest
    static void test01() {
        
        Account Acc = new Account();
        Acc.PrimerNombre__c = 'Jorge';
        Acc.Name = 'Jorge Test';
        Acc.PrimerApellido__c = 'Prueba';
        Acc.Numero_de_identificacion__c = '9876543210';
        insert Acc;
        
        Opportunity Opp = new Opportunity(
            Name = 'Opportunidad Test',
            Producto_de_Interes__c = 'F002',
            StageName='Contacto inicial', 
            Amount=500000, 
            CloseDate=Date.today(),
            AccountId=Acc.id 
            );
        insert Opp;

        PageReference testPage = Page.ANEFICondicionesFirmas; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(Opp.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
        ANEFICondicionesFirmasController ext = new ANEFICondicionesFirmasController(sc);
        
        PageReference testPage2 = Page.ANEFIDeclaracionFATCAPNat; 
        Test.setCurrentPage(testPage2);
        testPage2.getParameters().put('Id', String.valueOf(Opp.Id));
        
        ApexPages.StandardController sc2 = new  ApexPages.StandardController(Opp);     
        ANEFIDeclaracionFatcaPN ext2 = new ANEFIDeclaracionFatcaPN(sc2);
        
         PageReference testPage3 = Page.ANEFIDeclaracionFATCAPJ; 
        Test.setCurrentPage(testPage3);
        testPage3.getParameters().put('Id', String.valueOf(Opp.Id));
        
        
        ApexPages.StandardController sc3 = new  ApexPages.StandardController(Opp);     
        ANEFIDeclaracionFatcaPJ ext3 = new ANEFIDeclaracionFatcaPJ(sc3);
        
    }

}