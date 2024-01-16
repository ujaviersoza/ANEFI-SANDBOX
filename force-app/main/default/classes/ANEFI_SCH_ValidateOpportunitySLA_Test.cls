@isTest
public class ANEFI_SCH_ValidateOpportunitySLA_Test {
	static testMethod void myTestMethod() {         
        test.starttest();
            ANEFI_SCH_ValidateOpportunitySLA myClass = new ANEFI_SCH_ValidateOpportunitySLA();   
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched', chron, myClass);
        test.stopTest();
    }    
}