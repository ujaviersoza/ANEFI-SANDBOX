@isTest
public class anefi_ControladorNuevaCuenta_Test {
    
     @isTest
    static void anefi_ControladorNuevaCuenta(){
        Test.startTest();
        List<anefi_ControladorNuevaCuenta.PicklistOption> listRecordType = anefi_ControladorNuevaCuenta.getRecordTypeAccount();
        System.assertNotEquals(listRecordType, null);
        Test.stopTest();
    }

}