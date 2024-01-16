@isTest
public class ANEFI_SCH_ValidateLeadSLA_Test {
	static testMethod void myTestMethod() {         
        test.starttest();
            ANEFI_SCH_ValidateLeadSLA myClass = new ANEFI_SCH_ValidateLeadSLA();   
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched', chron, myClass);
        test.stopTest();
    }    
}