/**
*Class Name: ANEFI_TG_Lead_Test.
*Description: Clase Test para el Trigger: ANEFI_TG_Lead y las clases: ANEFI_TG_LeadHandler, ANEFI_TG_LeadHelper.
*Created Date: 7/7/2023, 22:23 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 11/7/2023, 08:39 AM.
*/
@IsTest
public class ANEFI_TG_Lead_Test {
        
	@isTest static void executeTest() {
        Test.startTest();
        	Lead cont = ANEFI_UT_DataFactory.createLead();
        Test.stopTest();   
    }
    
    @isTest static void executeTest2() {
        Test.startTest();
        	Lead cont = ANEFI_UT_DataFactory.createLead();
            Contact con = ANEFI_UT_DataFactory.createContact();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunityBusiness();
        Test.stopTest();   
    }
    
    @isTest static void executeTest3() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.createOpportunity();
        Test.stopTest();          
    }
    
    @isTest static void executeTest4() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.createOpportunity2();
        Test.stopTest();          
    }
    
    @isTest static void executeTest5() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.createOpportunity3();
        Test.stopTest();           
    }
    
    @isTest static void executeTest6() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunity();
        Test.stopTest();           
    }
    
    @isTest static void executeTest7() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunityF002();
        Test.stopTest();           
    }
    
    @isTest static void executeTest8() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunityF003();
        Test.stopTest();           
    }
    
    @isTest static void executeTest9() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunityF004();
        Test.stopTest();           
    }
    
    @isTest static void executeTest10() {
        Test.startTest();
            Opportunity opp = ANEFI_UT_DataFactory.updateOpportunityF005();
        Test.stopTest();           
    }
}