import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class Anefi_seleccionadorTipoOportunidad extends NavigationMixin(LightningElement)  {
    @api clienteId;
    opcionesArray = [];
    valorSeleccionado = '';
    @track objectInfo;
    @track tipoRegistroSeleccionado;

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })    
    handleObjectInfo({error, data}) {
        if (data) {            
            const rtis = data.recordTypeInfos;                
            let tipoPersonNaturalId = Object.keys(rtis).find(rti => rtis[rti].name === 'Persona Natural');
            let tipoPersonaJurídicaId = Object.keys(rtis).find(rti => rtis[rti].name === 'Persona Jurídica');

            this.opcionesArray.push({ label: 'Persona Natural', value: tipoPersonNaturalId });
            this.opcionesArray.push({ label: 'Persona Jurídica', value: tipoPersonaJurídicaId });                      
        }
    }   

    handleChange(event){
        this.tipoRegistroSeleccionado = event.detail.value; 
        console.log(this.tipoRegistroSeleccionado);
    }

    handleNext(){

        let pageRef = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Opportunity",
                actionName: "new"
            },
            state: {
            }
        };
        const defaultFieldValues = {
            AccountId: "0011h00000kJIvAAAW",
            recordTypeId: "0121h000000drpEAAQ",
            Name: "Salesforce, #1 CRM"
        };
        pageRef.state.defaultFieldValues = encodeDefaultFieldValues(defaultFieldValues);
        pageRef.state.nooverride = '1';
        this[NavigationMixin.Navigate](pageRef);

        /*this[NavigationMixin.Navigate]({  
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: 'AccountId=' + this.clienteId,// + ',recordTypeId=' + this.tipoRegistroSeleccionado,
                nooverride: '1'
            }
        })*/
    }
    
}