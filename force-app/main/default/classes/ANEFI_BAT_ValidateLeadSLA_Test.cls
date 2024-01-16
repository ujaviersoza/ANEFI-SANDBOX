/**
*Class Name: ANEFI_BAT_ValidateLeadSLA_Test.
*Description: Clase Test para el Batch: ANEFI_BAT_ValidateLeadSLA.
*Created Date: 16/5/2023, 11:43 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 16/5/2023, 13:28 PM.
*/
@IsTest
public class ANEFI_BAT_ValidateLeadSLA_Test {
	@isTest static void executeTest() {
        Lead ld = ANEFI_UT_DataFactory.createLead();
        
        Test.startTest();
            ANEFI_BAT_ValidateLeadSLA obj = new ANEFI_BAT_ValidateLeadSLA();
            DataBase.executeBatch(obj); 
        Test.stopTest();   
    }
}