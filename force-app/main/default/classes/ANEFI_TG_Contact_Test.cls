/**
*Class Name: ANEFI_TG_Contact_Test.
*Description: Clase Test para el Trigger: ANEFI_TG_Contact y las clases: ANEFI_TG_ContactHandler, ANEFI_TG_ContactHelper.
*Created Date: 27/6/2023, 9:53 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 27/6/2023, 12:38 PM.
*/
@IsTest
public class ANEFI_TG_Contact_Test {
	@isTest static void executeTest() {
        Test.startTest();
        	Contact cont = ANEFI_UT_DataFactory.updateContact();
        Test.stopTest();   
    }
}