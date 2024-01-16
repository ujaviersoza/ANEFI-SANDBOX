@isTest
public class OppTerrAssignLogicFilterTest {
    
	 //Método para probar la asignación de territorio a la oportunidad
    @isTest
    static void getOpportunityTerritory2AssignmentsTest(){
        
        Account account = new Account();
        account.Name = 'Cuenta prueba';
        insert account;
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.AccountId = account.Id;
        oportunidad.Amount = 100;
        oportunidad.CloseDate = Date.today();
        Oportunidad.Name = 'Oportunidad';
        Oportunidad.StageName = 'Nueva oportunidad';
        insert oportunidad;     
       
        
		List<Id> oportunidades = new List<Id>();
		oportunidades.add(oportunidad.Id);        
            
        
        Test.startTest();
        OppTerrAssignDefaultLogicFilter oppClase = new OppTerrAssignDefaultLogicFilter();
        oppClase.getOpportunityTerritory2Assignments(oportunidades);        
        Test.stopTest();
        
        
    }
}