import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import LightningAlert  from 'lightning/alert';

export default class Anefi_crearOportunidadDeAporte extends NavigationMixin(LightningElement) {

    @api numeroCuentaParticipe;    
    @api codigoProducto;
    @api clienteId;
    @api nombreTipoRegistroCliente;
    @track cargandoVisible = false;
    @track valorTrue = true;

    @track objectInfo;
    @track recordTypeId;
    @track codigoProductoSeleccionado;
    fechaActual;
    @track entidadFinancieraSeleccionada;    
    @track mostrarSeccionPago;
    esAporteConfirmado;
    @track buttonDisabled =false;
    @track alertVisible = false;

    connectedCallback(){
        this.codigoProductoSeleccionado = this.codigoProducto;           
        this.mostrarSeccionPago = false;
        this.esAporteConfirmado = false;
         
    }

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })    
    handleObjectInfo({error, data}) {
        if (data) {
            const rtis = data.recordTypeInfos;            
            let nombreTipoRegistroOportunidad = '';
            if(this.nombreTipoRegistroCliente === 'Persona Natural'){
                nombreTipoRegistroOportunidad = 'Aporte Persona Natural';
            }else if(this.nombreTipoRegistroCliente === 'Persona Jurídica'){
                nombreTipoRegistroOportunidad = 'Aporte Persona Jurídica'; 
            } 
                     
            this.recordTypeId = Object.keys(rtis).find(rti => rtis[rti].name === nombreTipoRegistroOportunidad);
            
        }
    }   

    get fechaEfectiva(){       
        this.getFechaActual();
        return this.fechaActual;
    }
   // realizarOportunidadAporte(){
    handleSubmit(event){        
        event.preventDefault();// stop the form from submitting  
        this.buttonDisabled = true;
        this.alertVisible= true;
        if(this.esAporteConfirmado && !this.entidadFinancieraSeleccionada){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error de validación',
                    message: 'Debe seleccionar una entidad financiera para guardar la oportunidad de aporte',
                    variant: 'error'
                })
            );        
            //this.buttonDisabled = false;
        }else{
            this.cargandoVisible = true;      
            const fields = event.detail.fields;  

            fields.AccountId = this.clienteId;
            fields.Cliente_hizo_el_pago__c = true;            
            fields.Firmo_el_contrato__c = true;
            if(this.esAporteConfirmado){
                fields.ForecastCategoryName = 'Closed';
                fields.Probability = 100;
                fields.StageName = 'Cerrada ganada';
                fields.Entidad_financiera__c = this.entidadFinancieraSeleccionada;
                //alertVisible= true;
                //this.handleConfirmClick('Creación de oportunidad de aporte realizado.');
                
            }else{
                fields.ForecastCategoryName = 'Commit';
                fields.Probability = 90;
                fields.StageName = 'Firma de contrato';
                
                //alertVisible = true;
                //this.handleConfirmClick('Creación de oportunidad de aporte realizado.');

            }           
            
            fields.Numero_cuenta_de_participe__c = this.numeroCuentaParticipe;            
            fields.Se_recopilo_cedula__c = true;
            fields.Se_recopilo_nombramiento__c = true;
            fields.Se_recopilo_RUC__c = true;        
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }       
        
    }

    alertHandler(){
        LightningAlert.open({
            message: 'La oportunidad de aporte se creó correctamente en el sistema',
            theme: 'success',
            label: 'Resultado de creación de oportunidad de aporte',
            // setting theme would have no effect
        });
     }

    handleSuccess(event){    
          
        //this.cargandoVisible = false; 
        this.alertHandler();
        //alertVisible= true;
        //this.handleConfirmClick = 'La oportunidad de aporte se creó correctamente en el sistema';      
       /* this.dispatchEvent(
            new ShowToastEvent({
                title: 'Confirmación',
                message: 'La oportunidad de aporte se creó correctamente en el sistema',
                variant: 'success'
            })
        );*/
        
        //this.buttonDisabled = false;  
        this.handleFinalizarCreacionOportunidad();
    }

    handleError(event){
        console.log(JSON.stringify(event));
        this.cargandoVisible = false;
        let mensajeError = event.detail.message;
        if( event.detail.output && event.detail.output.fieldErrors){   
            for (const prop in event.detail.output.fieldErrors) {                
                let fieldErrorObject = event.detail.output.fieldErrors[prop][0];                
                mensajeError = `${mensajeError} Campo: ${fieldErrorObject.fieldLabel} Detalle: ${fieldErrorObject.message}`;
              }           
        }  
        
        LightningAlert.open({
            message: mensajeError,
            theme: 'error',
            label: 'Resultado de creación de oportunidad de aporte',
            // setting theme would have no effect
        });

      /*  this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creando oportunidad de aporte',
                message: mensajeError,
                variant: 'error'
            })
        );*/  
        this.handleFinalizarCreacionOportunidad();
        
    }  
    
    handleFinalizarCreacionOportunidad(){
        this.dispatchEvent(new CustomEvent('finalizar'));
    }

    getFechaActual(){
        let fechaActualTemp = new Date();       
        let anio = fechaActualTemp.getFullYear();
        let mes = fechaActualTemp.getMonth() +1;
        let dia = fechaActualTemp.getDate();        

        if(mes < 10){
            mes = '0' + mes;
        }

        if(dia < 10){
            dia = '0' + dia;
        }     
        
        this.fechaActual = anio + '-' + mes + '-' + dia;        
    }

    handleChangeProducto(event){
        this.codigoProductoSeleccionado = event.target.value;        

    }

    handleSelectedrec(event){
        this.entidadFinancieraSeleccionada = event.detail.recordId;        
    }

    handleCheckboxChange(event){
        console.log(event.target.checked);        
        if(event.target.checked){
            this.mostrarSeccionPago = true;
            this.esAporteConfirmado = true;
        }else{
            this.mostrarSeccionPago = false;
            this.esAporteConfirmado = false;
        }

    }
    

}