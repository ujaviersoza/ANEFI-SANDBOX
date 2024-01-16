/**
*Class Name: ANEFI_OportunidadTrigger_Test.
*Description: Clase Test para el Trigger: ANEFI_TG_Contact y las clases: ANEFI_TG_ContactHandler, ANEFI_TG_ContactHelper.
*Created Date: 7/7/2023, 14:20 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 7/7/2023, 22:17 PM.
*/
@IsTest
public class ANEFI_OportunidadTrigger_Test {
    
	@isTest static void executeTest() {
        Test.startTest();
        	Opportunity opp = ANEFI_UT_DataFactory.createOpportunity();
        Test.stopTest();   
    }
    
    @isTest static void executeTest2() {
        Test.startTest();
            Opportunity opp2 = ANEFI_UT_DataFactory.createOpportunity2();
        Test.stopTest();   
    }
    
    @isTest static void executeTest3() {
        Test.startTest();
            Opportunity opp3 = ANEFI_UT_DataFactory.createOpportunity3();
        Test.stopTest();   
    }
    
    /*Método para verificar que no se puede eliminar una oportunidad ya existente en Gestor*/
   	@isTest
	static void eliminarOportunidadSincronizadaEnGestorTest(){ 
        System.runAs(new User(Id = UserInfo.getUserId())) {
        	Opportunity oppSinc = ANEFI_UT_DataFactory.createOpportunity2();
            delete oppSinc;
        }
    } 
    
    @isTest static void executeTest4() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Opportunity opp4 = ANEFI_UT_DataFactory.updateOpportunity();
            ANEFI_OpportunityHelper.createFileContractFASOpportunity(opp4.Id);
            ANEFI_OpportunityHelper.createConditionAssignFileAccountPerson(opp4.Id);
        }
    }
    
    @isTest static void executeTest5() {
        Test.startTest();
            Opportunity opp5 = ANEFI_UT_DataFactory.updateOpportunityBusiness();
        Test.stopTest();   
    }
    
    @isTest static void executeTest6() {
        Test.startTest();
            Opportunity opp6 = ANEFI_UT_DataFactory.updateOpportunityF002();
        Test.stopTest();   
    }
    
    @isTest static void executeTest7() {
        Test.startTest();
            Opportunity opp7 = ANEFI_UT_DataFactory.updateOpportunityF003();
        Test.stopTest();   
    }
    
    @isTest static void executeTest8() {
        Test.startTest();
            Opportunity opp8 = ANEFI_UT_DataFactory.updateOpportunityF004();
        Test.stopTest();   
    }
    
    @isTest static void executeTest9() {
        Test.startTest();
            Opportunity opp9 = ANEFI_UT_DataFactory.updateOpportunityF005();
        Test.stopTest();   
    }
}