import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';

import consultarObjetoPorCodigo from '@salesforce/apex/ANEFI_CampoFormularioController.consultarObjetoPorCodigo';

export default class Anefi_campoFormulario extends NavigationMixin(LightningElement) {
    @api tipo;
    @api etiqueta;
    @api valor;
    @api recordTypeId;
    @api fieldApiName;
    @api objectApiName;
    @api valueCheckBox;
    @track picklistLabel;
    @track urlReference;
    @track nameReference;
    
    @track error;


    @wire(getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: '$fieldApiName' })
    picklistValues({ error, data }) {
        if (this.tipo == 'lista') {
            if (data) {
                data.values.forEach(picklistValue => {
                    if (picklistValue.value == this.valor) {
                        this.picklistLabel = picklistValue.label;
                    }
                });
            }
            else if (error) {
                console.log(error);
            }
        }
    }

    @wire(consultarObjetoPorCodigo, { objectApiName: '$objectApiName', codigo: '$valor' })
    referenceURL({ error, data }) {
        if (this.tipo == 'referencia') {
            if (data) {
                console.log('consultarObjetoPorCodigo' + data);
                if(data.id){
                    this.actualizarUrl(data.id);
                }
                if(data.nombre){
                    this.nameReference = data.nombre;
                }
                
            }
            else if (error) {
                console.log(error);
            }
        }
    }

    actualizarUrl(referenceId) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: referenceId,
                actionName: 'view',
            },
        }).then(url => {
            this.urlReference = url;
        });
    }

    get esTexto() {
        return this.tipo == 'texto';
    }

    get esLista() {
        return this.tipo == 'lista';
    }

    get esEmail() {
        return this.tipo == 'email';
    }

    get esTelefono() {
        return this.tipo == 'telefono';
    }

    get esReferencia() {
        return this.tipo == 'referencia';
    }

    get esMoneda() {
        return this.tipo == 'moneda';
    }
    get esCheckBox(){
        return this.tipo == 'checkbox';
    }
}