/**
*Class Name: ANEFI_CuentaTrigger.
*Description: Trigger para el objeto Cuenta.
*Created Date: 8/6/2023, 15:50 PM.
*Created By: Bernardo Orellana.   
*Last Modified by: Intellect Systems 27/6/2023, 13:01 PM.
*/
trigger ANEFI_CuentaTrigger on Account (before insert, after insert, before update, after update, before delete) {    
    //Call to ANEFI_TG_AccountHandler
    new ANEFI_TG_AccountHandler().run();
}