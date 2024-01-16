/*
* Autor:        Jeffry Antonio Mejia Ocampos
* Fecha:        21/07/2022
* Ultima Mod:   22/07/2022
*/
@isTest
global class ANEFICondFirmasPNaturalController_Test {
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

        PageReference testPage = Page.ANEFICondicionesFirmasPNatural; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(Opp.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(Opp);     
        ANEFICondicionesFirmasPNaturalController ext = new ANEFICondicionesFirmasPNaturalController(sc);
    }

}