import { LightningElement, api, wire, track } from 'lwc';

import ETAPA_OPORTUNIDAD from '@salesforce/schema/Opportunity.StageName';

export default class Anefi_pathOportunidad extends LightningElement {

    @api recordId;

    

    etapas = [
        {
            nombre: 'Nueva oportunidad',
            objetosClave: []
        },
        {
            nombre: 'Propuesta',
            objetosClave: []
        },
        {
            nombre: 'Recopilación de documentos',
            objetosClave: []
        },
        {
            nombre: 'Firma de contrato',
            objetosClave: [
                {
                    apiName: 'Opportunity',
                    id: '0061h00000GqEKnAAN',
                    label: 'Oportunidad',
                    camposClave: [
                        'Trader__c',
                        'Fecha_efectiva_primer_aporte__c',
                        'Numero_documento_deposito__c',
                        'Forma_de_Pago__c',
                        'Moneda__c',
                        'Entidad_financiera__c'
                    ]
                }
            ]
        },
        {
            nombre: 'Cerrada',
            objetosClave: []
        },
    ]

    etapaActual = 'Firma de contrato';

    @track objetosClaveActuales = [
        {
            apiName: 'Opportunity',
            id: '0061h00000GqEKnAAN',
            label: 'Oportunidad',
            camposClave: [
                'Trader__c',
                'Fecha_efectiva_primer_aporte__c',
                'Numero_documento_deposito__c',
                'Forma_de_Pago__c',
                'Moneda__c',
                'Entidad_financiera__c'
            ]
        }
    ]

    handleCambioEtapa(evento){
        console.log(this.etapaActual + "--" + evento.target.value);
        if (this.etapaActual !== evento.target.value) {
            this.validateFields();


        }
    }

    validateFields() {
        let formularioValido = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            let campoValido = element.reportValidity();
            if(formularioValido && !campoValido){
                formularioValido = false;
            }
        });
    }
}