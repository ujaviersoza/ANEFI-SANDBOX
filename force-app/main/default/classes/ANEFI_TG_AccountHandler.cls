/**
*Class Name: ANEFI_TG_AccountHandler.
*Description: Clase Handler para el trigger ANEFI_CuentaTrigger.
*Created Date: 8/6/2023, 15:50 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 2/08/2023, 14:44 PM.
*/
public class ANEFI_TG_AccountHandler extends TriggerHandler {
    
    protected override void beforeInsert() {        
    	ANEFI_TG_AccountHelper.validateDuplicates(Trigger.new);
        ANEFI_TG_AccountHelper.completeFieldsPersonAccount(Trigger.new);
    }
    
    protected override void beforeUpdate() {
    	ANEFI_TG_AccountHelper.validateDuplicates(Trigger.new, (Map<Id,Account>)Trigger.oldMap);       
    }
    
    protected override void beforeDelete() {
        ANEFI_TG_AccountHelper.syncInGestor(Trigger.new, (Map<Id,Account>)Trigger.oldMap);
    }    
    
}