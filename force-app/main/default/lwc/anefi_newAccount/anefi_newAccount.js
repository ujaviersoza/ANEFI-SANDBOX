import { LightningElement, track } from 'lwc';
import getTipoRegistro from "@salesforce/apex/anefi_ControladorNuevaCuenta.getRecordTypeAccount";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils'
import { NavigationMixin } from 'lightning/navigation';
import nombrePersonaNuevaNatural from '@salesforce/label/c.anefi_NombrePersonaNuevaNatural';
import consultarClienteEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarClienteExistePorIdentificacion';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Anefi_newAccount extends NavigationMixin(LightningElement) {
    opcionesNuevaCuenta = [];
    @track tipoRegistro;
    @track formularioBusqueda = false; 
    @track mostrarSpinner = false;
    @track numeroIdentificacion = '';
    @track tipoIdentificacion = '';

    get mostrarBusqueda(){
        return this.formularioBusqueda;
    }

    handleSearch(event) {
            
        event.preventDefault();
        const fields = event.detail.fields;

        this.numeroIdentificacion = fields.Numero_de_identificacion__c;
        this.tipoIdentificacion = fields.Tipo_de_identificacion__c;

        console.log('Datos a buscar '+fields.Tipo_de_identificacion__c);
        console.log('Datos a buscar '+fields.Numero_de_identificacion__c);

        this.handleConsultarCliente();       

    }


    connectedCallback() {
        this.init();
    }
    init() {
        getTipoRegistro(

        ).then(response => {
            this.opcionesNuevaCuenta = response;
            this.tipoRegistro = response[0].value;
        })
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }


    handleConsultarCliente() {
        this.mostrarSpinner = true;
        consultarClienteEnGestor({ identificacion: this.numeroIdentificacion, tipoIdentificacion: this.tipoIdentificacion, tipoCliente : this.tipoRegistro})
            .then(result => {
                // Handle successful response
                console.log('Result:', result);
                this.mostrarSpinner = false;
            })
            .catch(error => {
                // Handle error
                this.mostrarSpinner = false;
                this.showToast('Atención!', error.body.message, 'error');


                console.error('Error:', error);
                
            });
    }

    onChangemostrarBusqueda(){
        this.formularioBusqueda = !this.formularioBusqueda;

    }

    onchangeTipoRegistro(event){
        this.tipoRegistro = event.target.value;
    }

    formularioNuevaCuenta() {
        let nombreDefault = '';
        for(let i=0; i<this.opcionesNuevaCuenta.length; i++){
            if(this.tipoRegistro == this.opcionesNuevaCuenta[i].value &&
                 this.opcionesNuevaCuenta[i].label == 'Persona Natural'){
                nombreDefault = nombrePersonaNuevaNatural;
            }
        }
        const defaultValues = encodeDefaultFieldValues({
            Name: nombreDefault
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                nooverride: "1",
                recordTypeId: this.tipoRegistro
            }
        });
       // this.fireCloseComponentEvent();
    }


    formularioNuevaCuenta() {
        let nombreDefault = '';
        for(let i=0; i<this.opcionesNuevaCuenta.length; i++){
            if(this.tipoRegistro == this.opcionesNuevaCuenta[i].value &&
                 this.opcionesNuevaCuenta[i].label == 'Persona Natural'){
                nombreDefault = nombrePersonaNuevaNatural;
            }
        }
        const defaultValues = encodeDefaultFieldValues({
            Name: nombreDefault
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                nooverride: "1",
                recordTypeId: this.tipoRegistro
            }
        });
       // this.fireCloseComponentEvent();
    }

    cerrarVentada() { 
        const closeWindow = new CustomEvent('CloseWindow', {} );
        this.dispatchEvent(closeWindow); 
    }

    cancelar(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            }
        });
    }
}