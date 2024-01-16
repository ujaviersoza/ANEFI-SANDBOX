/**
*Class Name: ANEFI_CuentaTrigger_Test.
*Description: Clase Test para el Trigger: ANEFI_CuentaTrigger y las clases: ANEFI_TG_AccountHandler y ANEFI_TG_AccountHelper.
*Created Date: 10/8/2020, 17:12 PM.
*Created By: Bernardo Orellana.   
*Last Modified by: Intellect Systems 11/7/2023, 08:27 AM.
*/
@isTest
public class ANEFI_CuentaTrigger_Test {  
    
    @isTest static void executeTest() {
        Test.startTest();
            Account accUpdate = ANEFI_UT_DataFactory.updateAccount();
        Test.stopTest();   
    } 
    
    /*Método para verificar que no se puede eliminar un cliente ya existente en Gestor*/
   	@isTest
	static void eliminarClienteSincronizadoEnGestorTest(){ 
        System.runAs(new User(Id = UserInfo.getUserId())) {
        	Account accSinc = ANEFI_UT_DataFactory.createAccount();
            delete accSinc;
        }
    } 
}