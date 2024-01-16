import { LightningElement, track, api } from 'lwc';

import findRecords from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.findRecords';


export default class Anefi_customLookup extends LightningElement {
    @track records;
    @track error;
    @track selectedRecord;
    @api index;
    @api relationshipfield;
    @api iconName;
    @api objectName;
    @api searchfield;
    @api codigoProducto;
    @api nombreCampo;

    /*constructor(){
        super();
        this.iconname = "standard:account";
        this.objectName = 'Account';
        this.searchField = 'Name';
    }*/

    handleOnchange(event){
        //event.preventDefault();        
        const searchKey = event.detail.value;          
           
        //this.records = null;
        /* eslint-disable no-console */
        //console.log(searchKey);

        /* Call the Salesforce Apex class method to find the Records */
        if(searchKey && searchKey.length > 2){
            findRecords({
                searchKey : searchKey, 
                objectName : this.objectName, 
                searchField : this.searchfield,
                codigoProducto : this.codigoProducto
    
            })
            .then(result => {
                this.records = result;
                for(let i=0; i < this.records.length; i++){
                    const rec = this.records[i];
                    //this.records[i].Name = rec[this.searchfield];
                    this.records[i].Name = rec['Nombre__c'];
                }
                this.error = undefined;
                //console.log(' records ', this.records);
            })
            .catch(error => {
                this.error = error;
                this.records = undefined;
            });
        }      
        
        
    }
    handleSelect(event){
        const selectedRecordId = event.detail;
        console.log('selectedRecordId: ' + selectedRecordId);
        /* eslint-disable no-console*/
        this.selectedRecord = this.records.find( record => record.Id === selectedRecordId);
        /* fire the event with the value of RecordId for the Selected RecordId */
        const selectedRecordEvent = new CustomEvent(
            "selectedrec",
            {
                //detail : selectedRecordId
                detail : { recordId : selectedRecordId, index : this.index, relationshipfield : this.relationshipfield}
            }
        );
        this.dispatchEvent(selectedRecordEvent);
    }

    handleRemove(event){
        event.preventDefault();
        this.selectedRecord = undefined;
        this.records = undefined;
        this.error = undefined;
        /* fire the event with the value of undefined for the Selected RecordId */
        const selectedRecordEvent = new CustomEvent(
            "selectedrec",
            {
                detail : { recordId : undefined, index : this.index, relationshipfield : this.relationshipfield}
            }
        );
        this.dispatchEvent(selectedRecordEvent);
    }

}