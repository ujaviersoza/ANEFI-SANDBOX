/**
*Class Name: ANEFI_TG_Contact.
*Description: Trigger para el objeto Contacto.
*Created Date: 12/6/2023, 10:40 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 26/6/2023, 17:19 PM.
*/
trigger ANEFI_TG_Contact on Contact (before insert, after insert, before update, after update) { 
    new ANEFI_TG_ContactHandler().run();
}