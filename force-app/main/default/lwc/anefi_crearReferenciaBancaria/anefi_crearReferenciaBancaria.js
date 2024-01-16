import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import registrarReferenciaBancariaEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.registrarReferenciaBancariaEnGestor';


export default class Anefi_crearReferenciaBancaria extends NavigationMixin(LightningElement) {
    

    @api clienteId;
    @api clienteCodigoGestor;
    @api accion;
    @api numeroCuentaBancariaActual;
    @track cargandoVisible = false;    
   
    valorMoneda = '1';
    valorPrincipal = 'S';
    valorEstado = 'ACT';
    valorObservaciones = '';

    get fechaIngresoPorDefecto(){
        let fechaActual = new Date();       
        let anio = fechaActual.getFullYear();
        let mes = fechaActual.getMonth() +1;
        let dia = fechaActual.getDate();        

        if(mes < 10){
            mes = '0' + mes;
        }

        if(dia < 10){
            dia = '0' + dia;
        }     
        
        let fechaIngresoDefecto = anio + '-' + mes + '-' + dia;
        
        return fechaIngresoDefecto;
    }

    get deshabilitarCampoNumeroCuenta(){
        if(this.accion == 'actualizarReferenciaBancaria'){
            return true;
        }else{
            return false;
        }
    }

    get opcionesMoneda() {
        return [
            { label: 'Dólar', value: '1' },
            { label: 'Euro', value: '2' }
        ];
    }

    get opcionesPrincipal() {
        return [
            { label: 'Si', value: 'S' },
            { label: 'No', value: 'N' }
        ];
    }

    get opcionesEstado() {
        return [
            { label: 'Activa', value: 'ACT' },
            { label: 'Inactiva', value: 'INA' },
            { label: 'Cancelada', value: 'CAN' }
        ];
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting  
        this.cargandoVisible = true;      
        const fields = event.detail.fields; 
        let numeroCuentaBancariaLocal; 
        if(this.accion == 'actualizarReferenciaBancaria'){
            numeroCuentaBancariaLocal = this.numeroCuentaBancariaActual;
        } 
        else{
            numeroCuentaBancariaLocal = fields.Numero_de_cuenta_bancaria__c;
        }
        let registroReferenciaBancariaInput = {
            codigoTipoEntidadFinanciera : '',
            codigoEntidadFinanciera : fields.Entidad_financiera__c,
            numeroCuenta : numeroCuentaBancariaLocal,
            codigoTipoCuenta :  fields.Tipo_de_cuenta_bancaria__c,
            codigoMoneda : this.valorMoneda,
            fechaIngreso : this.fechaIngreso,
            principal : this.valorPrincipal,
            estado: this.valorEstado,
            observaciones : this.valorObservaciones
        };

        let registroReferenciaBancariaInputString = JSON.stringify(registroReferenciaBancariaInput);        
        
        registrarReferenciaBancariaEnGestor({ clienteId: this.clienteId,
            clienteCodigoGestor: this.clienteCodigoGestor, accion: this.accion,
            registroReferenciaBancariaInputString: registroReferenciaBancariaInputString })
            .then((data) => {                                
                this.cargandoVisible = false;
                let mensajeConfirmacion = '';                
                if(this.accion == 'crearReferenciaBancaria'){
                    mensajeConfirmacion = 'Referencia bancaria creada en Gestor';                    
                }
                else{
                    mensajeConfirmacion = 'Referencia bancaria actualizada en Gestor';                    
                }   

                if(data == '201' || data == '204'){    
                                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Confirmación',
                            message: mensajeConfirmacion,
                            variant: 'success'
                        })
                    );

                    this.handleFinalizarCreacionReferenciaBancaria();
                    
                }
                else{    
                    let response = JSON.parse(data);
                    let errores = response.errors;                     
                    let mensajeError = '';                    
                    

                    if(errores && errores.length > 0){                        
                        mensajeError = errores[0].detail;                       
                    }               
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error ejecutando operación de referencia bancaria 1',
                            message: mensajeError,
                            variant: 'error'
                        })
                    );
                    this.handleFinalizarCreacionReferenciaBancaria();
                    
                }
                
			})
            .catch(error => {
                console.log(JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error ejecutando operación de referencia bancaria',
                        message: JSON.stringify(error),
                        variant: 'error'
                    })
                );  
                this.handleFinalizarCreacionReferenciaBancaria();             
                
            });
        
    }

    handleChangeMoneda(event) {
        this.valorMoneda = event.detail.value;
    }

    handleFechaIngreso(event){
        this.fechaIngreso = event.target.value;
    }

    handleChangePrincipal(event) {
        this.valorPrincipal = event.detail.value;
    }

    handleChangeEstado(event) {
        this.valorEstado = event.detail.value;
    }

    handleObservaciones(event){
        this.valorObservaciones =event.detail.value;
    }

    handleFinalizarCreacionReferenciaBancaria() {
        this.dispatchEvent(new CustomEvent('finalizar'));
    }
}