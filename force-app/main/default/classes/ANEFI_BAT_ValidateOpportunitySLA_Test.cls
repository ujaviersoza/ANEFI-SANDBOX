/**
*Class Name: ANEFI_BAT_ValidateOpportunitySLA_Test.
*Description: Clase Test para el Batch: ANEFI_BAT_ValidateOpportunitySLA.
*Created Date: 5/6/2023, 17:25 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 6/6/2023, 09:29 AM.
*/
@IsTest
public class ANEFI_BAT_ValidateOpportunitySLA_Test {
	@isTest static void executeTest() {
        Opportunity opp = ANEFI_UT_DataFactory.createOpportunity();
        
        Test.startTest();
            ANEFI_BAT_ValidateOpportunitySLA obj = new ANEFI_BAT_ValidateOpportunitySLA();
            DataBase.executeBatch(obj); 
        Test.stopTest();   
    }
}