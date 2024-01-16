/**
*Class Name: ANEFI_TG_Lead.
*Description: Trigger para el objeto Prospecto.
*Created Date: 7/6/2023, 16:17 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 26/6/2023, 17:17 PM.
*/
trigger ANEFI_TG_Lead on Lead (before insert, after insert, before update, after update) { 
    new ANEFI_TG_LeadHandler().run();
}