/**
*Class Name: ANEFI_TG_LeadHandler.
*Description: Clase Handler para el trigger ANEFI_TG_Lead.
*Created Date: 7/6/2023, 16:18 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 2/05/2024, 11:06 AM.
*/
public class ANEFI_TG_LeadHandler extends TriggerHandler {
    
    protected override void beforeInsert() {
    	ANEFI_TG_LeadHelper.validateDuplicates(Trigger.new);
    }
    
    protected override void beforeUpdate() {
        System.debug('before update lead');
    	ANEFI_TG_LeadHelper.validateDuplicates(Trigger.new, (Map<Id,Lead>)Trigger.oldMap);       
    }
    
}