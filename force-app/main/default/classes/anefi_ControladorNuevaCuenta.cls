public without sharing class anefi_ControladorNuevaCuenta {

    @AuraEnabled
    public static List<PicklistOption> getRecordTypeAccount(){
        List<PicklistOption> listRecordType = new List<PicklistOption>();
        for(RecordType item: [Select Name, Id from RecordType Where sObjectType = 'Account' and isActive = true]){
            listRecordType.add(new PicklistOption(item.Id, item.Name));
        }
        return listRecordType;
    }
    
    
    public class PicklistOption{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
        PicklistOption(String value, String label){
            this.label = label;
            this.value = value;
        }
    }
}