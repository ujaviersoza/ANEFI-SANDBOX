import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NOMBRE_CUENTA_FIELD from '@salesforce/schema/Opportunity.AccountId';
import NOMBRE_CLIENTE_FIELD from '@salesforce/schema/Account.Name';
import Profile_FIELD from '@salesforce/schema/User.Profile.Name';
import obtenerCamposFaltantesCierreOportunidad from '@salesforce/apex/ANEFI_ValidarCamposCierreOportunidadCC.obtenerCamposFaltantesCierreOportunidad';

const OPORTUNIDAD_FIELDS = [NOMBRE_CUENTA_FIELD];
const CLIENTE_FIELDS = [NOMBRE_CLIENTE_FIELD];

const estadosComponente = Object.freeze({
    "cargando": 1,
    "camposFaltantes": 2,
    "camposCompletos": 3,
    "error": 4
})

export default class Anefi_validarCamposCierreOportunidad extends LightningElement {
    @api recordId;

    @track clienteId;
    @track camposFaltantesCliente;
    @track camposFaltantesOportunidad;

    @track guardarClienteDeshabilitado = true;
    @track guardarOportunidadDeshabilitado = true;

    @track modalVisible = false;
    @track cargandoVisible = false;
    @track camposFaltantesVisible = false;
    @track camposCompletosVisible = false;
    @track errorVisible = false;
    @track requiredField = true;
    @track profile;
    @track isProfileEnabled = false;
    @track listaCamposFaltantesCliente = [
    ];
    @track listaCamposFaltantesOpp = [
    ];
    error;
    @wire(getRecord,{recordId:USER_ID,fields:[Profile_FIELD]}) wireuser({
        error,
        data
    }) {
        if (error) {
           
        } else if (data) {
            this.profile = data.fields.Profile.value.fields.Name.value;
            console.log(this.profile);
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: OPORTUNIDAD_FIELDS })
    darOportunidad({ data, error }) {
        this.clienteId = null;
        console.log("wire oportunidad");
        if (data) {
            this.clienteId = getFieldValue(data, NOMBRE_CUENTA_FIELD);
            this.actualizarCamposFaltantes();
        } else if (error) {
            console.log(result.error);
            this.error = result.error;
            this.cambiarEstado(estadosComponente.error);
        }
    }

    @wire(getRecord, { recordId: '$clienteId', fields: CLIENTE_FIELDS })
    darCliente({ data, error }) {
        if (data) {
            this.actualizarCamposFaltantes();
        } else if (error) {
            console.log(result.error);
            this.error = result.error;
            this.cambiarEstado(estadosComponente.error);
        }
    }

    actualizarCamposFaltantes() {
        this.camposFaltantesCliente = null;
        this.camposFaltantesOportunidad = null;
        
        obtenerCamposFaltantesCierreOportunidad({ oportunidadId: this.recordId })
            .then(data => {
                 
                let faltanCampos = false;
                if (data.camposFaltantesCliente && data.camposFaltantesCliente.length > 0) {
                    this.listaCamposFaltantesCliente = [];
                    for(let campo of data.camposFaltantesCliente ){
                        this.requiredField = true;
                        this.isProfileEnabled = false;
                        if( (campo ==='Entidad_financiera__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Numero_de_cuenta_bancaria__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Tipo_de_cuenta_bancaria__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Total_gastos__c' && this.profile === 'Vendedor Fid Inversión')   ){
                            this.requiredField = false;
                            this.isProfileEnabled = true;
                            
                        }
                        this.listaCamposFaltantesCliente.push({campo : campo, esRequerido : this.requiredField});
                    }
                    faltanCampos = true;
                    this.camposFaltantesCliente = data.camposFaltantesCliente;
                }
                if (data.camposFaltantesOportunidad && data.camposFaltantesOportunidad.length > 0) {
                    this.listaCamposFaltantesOpp = [];
                    for(let campo of data.camposFaltantesOportunidad ){
                        this.requiredField = true;
                        this.isProfileEnabled = false;
                        if( (campo ==='Fecha_efectiva_primer_aporte__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Numero_documento_deposito__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Forma_de_Pago__c' && this.profile === 'Vendedor Fid Inversión') || (campo ==='Moneda__c' && this.profile === 'Vendedor Fid Inversión')   ){
                            this.requiredField = false;
                            this.isProfileEnabled = true;
                            
                        }
                        this.listaCamposFaltantesOpp.push({campo : campo, esRequerido : this.requiredField});
                    }

                    faltanCampos = true;
                    this.camposFaltantesOportunidad = data.camposFaltantesOportunidad;
                }

                if (faltanCampos) {
                    this.cambiarEstado(estadosComponente.camposFaltantes);
                }
                else {
                    this.cambiarEstado(estadosComponente.camposCompletos);
                    this.modalVisible = false;
                }
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.cambiarEstado(estadosComponente.error);
            });
    }


    get hayCamposCliente() {
        let resp = false;
        if (this.camposFaltantesCliente && this.camposFaltantesCliente.length > 0) {
            resp = true;
        }
        return resp;
    }

    get hayCamposOportunidad() {
        let resp = false;
        if (this.camposFaltantesOportunidad && this.camposFaltantesOportunidad.length > 0) {
            resp = true;
        }
        return resp;
    }

    handleSubmitOpportunity(event) {
        this.guardarOportunidadDeshabilitado = true;
    }

    handleSuccessOpportunity(event) {
        console.log("SUCCESS");
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Oportunidad actualizada correctamente',
                message: 'Campos de la oportunidad actualizados correctamente',
                variant: 'success'
            })
        );
    }

    handleErrorOpportunity(event) {
        console.log("ERROR");
        console.log(JSON.stringify(event.detail) );
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error al actualizar los campos de la oportunidad: ' + event.detail.message + ' Detalle del error: ' + event.detail.detail,
                variant: 'error'
            })
        );
    }

    handleCambioCampoOportunidad(event) {
        console.log("Cambio Oportunidad");
        this.guardarOportunidadDeshabilitado = false;
    }

    handleSubmitAccount(event) {
        this.guardarClienteDeshabilitado = true;
    }

    handleSuccessAccount(event) {
        console.log("SUCCESS");
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Cliente actualizado correctamente',
                message: 'Campos del cliente actualizados correctamente',
                variant: 'success'
            })
        );
    }

    handleErrorAccount(event) {
        console.log("ERROR");
        console.log(event.detail);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Error al actualizar los campos del cliente: ' + event.detail.message + ' Detalle del error: ' + event.detail.detail,
                variant: 'error'
            })
        );
    }

    handleCambioCampoCliente(event) {
        this.guardarClienteDeshabilitado = false;
    }

    handleMostrarCamposFaltantes(event) {
        this.modalVisible = true;
    }

    handleCerrarModal(event) {
        console.log("cerrando modal")
        this.modalVisible = false;
    }

    /**
     * Cambia el estado actual del componente
     * @param estado al que se desea cambiar el componente
     */
    cambiarEstado(estado) {
        switch (estado) {
            case estadosComponente.cargando:
                this.cargandoVisible = true;
                this.camposFaltantesVisible = false;
                this.camposCompletosVisible = false;
                this.errorVisible = false;
                break;
            case estadosComponente.camposFaltantes:
                this.cargandoVisible = false;
                this.camposFaltantesVisible = true;
                this.camposCompletosVisible = false;
                this.errorVisible = false;
                break;
            case estadosComponente.camposCompletos:
                this.cargandoVisible = false;
                this.camposFaltantesVisible = false;
                this.camposCompletosVisible = true;
                this.errorVisible = false;
                break;
            case estadosComponente.error:
                this.cargandoVisible = false;
                this.camposFaltantesVisible = false;
                this.camposCompletosVisible = false;
                this.errorVisible = true;
                break;
            default:
                this.cargandoVisible = false;
                this.camposFaltantesVisible = false;
                this.camposCompletosVisible = false;
                this.errorVisible = false;
                break;
        }
    }
}