import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Anefi_completarCliente extends LightningElement {

    @api camposFaltantes;
    @api clienteId;
    @track alertVisible = false;


    handleSubmit(event){        
        this.alertVisible = true;
    }

    handleSuccess(event){

        this.alertVisible = false;
        
        const correct = new CustomEvent('processnext', {
            detail: {
                proceedNexForm: true 
            }
        });

        this.dispatchEvent(correct);
                
    }

    handleError(event) {
        this.alertVisible = false;
        const errorDetail = event.detail;
        const alert = new ShowToastEvent({
            title: 'Error',
            message: errorDetail,
            variant: 'error'
        });
        this.dispatchEvent(alert);
        console.error('Error occurred:', errorDetail);
    }
    
}