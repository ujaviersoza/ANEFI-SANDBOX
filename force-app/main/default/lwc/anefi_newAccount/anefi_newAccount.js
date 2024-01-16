import { LightningElement } from 'lwc';
import getTipoRegistro from "@salesforce/apex/anefi_ControladorNuevaCuenta.getRecordTypeAccount";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils'
import { NavigationMixin } from 'lightning/navigation';
import nombrePersonaNuevaNatural from '@salesforce/label/c.anefi_NombrePersonaNuevaNatural';

export default class Anefi_newAccount extends NavigationMixin(LightningElement) {
    opcionesNuevaCuenta = [];
    tipoRegistro;


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