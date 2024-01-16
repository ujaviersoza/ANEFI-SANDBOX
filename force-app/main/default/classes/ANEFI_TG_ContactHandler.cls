/**
*Class Name: ANEFI_TG_ContactHandler.
*Description: Clase Handler para el trigger ANEFI_TG_Contact.
*Created Date: 2/6/2023, 10:40 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 4/8/2023, 11:36 AM.
*/
public class ANEFI_TG_ContactHandler extends TriggerHandler {
    
    //public static Boolean doNotRunTrigger = false;

    /*public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }*/
    
    protected override void beforeInsert() {
    	ANEFI_TG_ContactHelper.validateDuplicates(Trigger.new);
    }
    
    /*protected override void afterUpdate() {
        if(doNotRunTrigger == false) {
			String user = UserInfo.getName();
            if(user == 'B2BMA Integration') {
            	ANEFI_TG_ContactHelper.createOppAccMan(Trigger.New);
            }    
        } 
    }*/
    
    protected override void beforeUpdate() {
    	ANEFI_TG_ContactHelper.validateDuplicates(Trigger.new, (Map<Id,Contact>)Trigger.oldMap);       
    }
    
}