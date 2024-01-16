/**
*Class Name: ANEFI_TG_OpportunityHandler.
*Description: Clase Handler para el trigger ANEFI_OportunidadTrigger.
*Created Date: 2/6/2023, 13:30 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 7/7/2023, 22:20 PM.
*/
public class ANEFI_TG_OpportunityHandler extends TriggerHandler {
    
    protected override void beforeInsert() {        
        ANEFI_TG_OpportunityHelper.assignRecordtypeLeadConversion(Trigger.new);
        ANEFI_TG_OpportunityHelper.validateOpportunities(Trigger.New);      
    }
        
    protected override void beforeDelete() {
        //ANEFI_TG_OpportunityHelper.syncInGestor(Trigger.new, (Map<Id,Opportunity>)Trigger.oldMap);
    }
    
    protected override void afterUpdate() {
        ANEFI_OpportunityHandler.createFileContractCPOpportunity(Trigger.new,Trigger.old); 
    	ANEFI_OpportunityHandler.createFilesOpportunity(Trigger.new,Trigger.old);  
    }
        
}