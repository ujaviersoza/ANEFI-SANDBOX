/**
*Class Name: ANEFI_OportunidadTrigger.
*Description: Trigger para el objeto Oportunidad.
*Created Date: 10/8/2020, 17:12 PM.
*Created By: Bernardo Orellana.   
*Last Modified by: Intellect Systems 7/7/2023, 22:20 PM.
*/
trigger ANEFI_OportunidadTrigger on Opportunity (before insert, after insert, before update, after update, before delete){    
    //Call to ANEFI_TG_OpportunityHandler
    new ANEFI_TG_OpportunityHandler().run();
}