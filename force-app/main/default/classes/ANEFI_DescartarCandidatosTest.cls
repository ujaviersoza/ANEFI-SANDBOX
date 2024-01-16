@isTest
private class ANEFI_DescartarCandidatosTest {
// Dummy CRON expression: midnight on Abril 28.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 1 1 ? 2024';
    static testmethod void testScheduledJob() {
        
        /*// Create a lead record with a previous*/
        Lead lead = new Lead();
        lead.Status = 'Nuevo';
        lead.FirstName = 'Candidato';
        lead.LastName = '1';
        lead.Company = 'Empresa';
        insert lead;
        
        Datetime yesterday = Datetime.now().addDays(-91);
		Test.setCreatedDate(lead.Id, yesterday);
            
        Test.startTest();       
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new ANEFI_DescartarCandidatos());  
        
        // Verify the scheduled job has not run yet.
        List<Lead> lt = [SELECT Id 
            FROM Lead 
            WHERE status = 'Nuevo'];
        System.assertEquals(1, lt.size(), 'Candidatos abiertos');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
        // Now that the scheduled job has executed,
        // check that the lead was discard
        lt = [SELECT Id 
            FROM Lead 
            WHERE Status = 'Descartado'];
        System.assertEquals(1, 
            lt.size(), 
            'Candidato fue descartado');
    }
}