import { LightningElement,track,api,wire } from 'lwc';
import consultaCuentasBancariasSalida from '@salesforce/apex/ANEFI_CreaRescate.consultaCuentas';
import consultaReferenciaCuentasBancarias from '@salesforce/apex/ANEFI_CreaRescate.consultaCuentasReferenciaBancaria';
import consultaDatosMontosProducto from '@salesforce/apex/ANEFI_CreaRescate.consultaDatosMontosProducto';
import registraRescate from '@salesforce/apex/ANEFI_CreaRescate.registraRescate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import consultaInformacionAdicionalCuenta from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultaInformacionAdicionalCuenta';
import LightningAlert  from 'lightning/alert';
export default class Anefi_creaRescate extends LightningElement {
    @track mostrarSeccionSaldos = false;     
    @track fechaDesde;
    @track fechaHasta;
    @track saldosCuentaParticipe;
    @track buttonDisabled = false;
    @track dataMontosProducto;
    @api codigoProducto;
    @api codigoPersonaGestor;
    @api numeroCuentaParticipe;
    @track agencia = 1;
    @track codigoTipoTransaccion;
    @track valorRescate;
    @track codigoMoneda  = 1;
    @track fechaEfectiva = '';
    @track fechaEfectivaGuardar = '';
    @track codigoFormaPago = 'TRANS';
    @track mapeoExcepciones = false;
    @api results = [];
    @api resultsReferenciaBancaria = [];
    @track combobox = [];
    @track comboboxReferenciaBancaria = [];
    @track fechaMinima;
    @api cliente;
    @track tipRescate;
    @track alertVisible = false;
    @track datosCuentaBancariaProducto;
    @track datosCuentaBancariaDestino;
    @track nombreReferencia;
    @track mostrarReferencia = false;
    @track referenciaTerceros = [];
    @track referenciaTipoCuenta = [];
    @track mostrarMonto = true;
    @track mostrarSeccionRescate = false;
    get tipoRescate(){
        return [
            {label : 'Parcial', value : 'PAR'},
            {label : 'Total', value : 'TOT'}
        ];
    }
    
    obtenerFechaHastaMaxima(){

        this.fechaDesde = '2022-06-01';
        this.fechaHasta = '2022-06-30';    

    }    
    changeHandler(event){ 
        if(event.target.name === 'monto'){
            this.valorRescate =  event.target.value;
            console.log(this.valorRescate);
        }else if(event.target.name === 'tipoRescate'){
            this.tipRescate = event.target.value;
            console.log('->'+this.tipRescate);
            this.codigoTipoTransaccion = (event.target.value === 'PAR') ? 'PFP' : 'LT';

            if(event.target.value === 'TOT'){
                this.valorRescate = '';
                this.mostrarMonto = false;
            }else{
                this.mostrarMonto = true;
            }

        }else if(event.target.name === 'cuentaBancariaProducto'){
            this.datosCuentaBancariaProducto = event.target.value;
        }else if(event.target.name === 'cuentaBancariaReferencia'){
            console.log('cuentaBancariaReferencia change');
            this.datosCuentaBancariaDestino = event.target.value;
            this.mostrarReferencia = false;
            let existsReferencia = this.referenciaTerceros.filter((item) => {
                return item.value == event.target.value; 
            });
            this.nombreReferencia = '';
            if(existsReferencia.length>0){
                this.mostrarReferencia = true;
                this.nombreReferencia = existsReferencia[0].datos ;
            }
            
        }else if(event.target.name === 'fechaEfectiva'){
            this.fechaEfectiva = event.target.value;
            let fechaEfectiva  = this.fechaEfectiva;
            let Months = ["January","February","March","April","May","June","July","August","September","Octuber","November","December"];
            //let year =fechaEfectiva.split('-')[0];
            //let month = fechaEfectiva.split('-')[1];
            //let days = fechaEfectiva.split('-')[2];
            console.log('this.fechaEfectiva -> ' + this.fechaEfectiva);

            //console.log('fechaEfectiva -> ' + year +  month+ days  );
            let date2 = new Date(this.fechaEfectiva);
             
            let day2 = date2.getDate() + 1;
            let fechaString = Months[date2.getMonth()]+' '+ day2 +', '+date2.getFullYear()+' 13:15:30'
            let date = new Date(fechaString);
            let day = date.getDay();
            console.log('fecha utc' + date);
            console.log('day utc ' + day);
            let fechaE =   this.template.querySelector('.reqInpFld');

            if(day === 0 || day === 6){
                fechaE.setCustomValidity('Fecha Efectiva no puede ser Sábado o Domingo');
            }else{
                fechaE.setCustomValidity('');
            }
            fechaE.reportValidity();
        }


    }
      
     fechaIngresoPorDefecto(){
        let fechaActual = new Date();       
        let anio = fechaActual.getFullYear();
        let mes = fechaActual.getMonth();
        let dia = fechaActual.getDate() + 1;        

        if(mes < 10){
            mes = '0' + mes;
        }

        if(dia < 10){
            dia = '0' + dia;
        }     
        
        let fechaIngresoDefecto = anio + '-' + mes + '-' + dia;
        
        return fechaIngresoDefecto;
    }

    connectedCallback(){
        this.obtenerFechaHastaMaxima();
        console.log('entro' + this.codigoProducto);
        var d = new Date();
        this.fechaMinima  = d.getFullYear() + '-' + (d.getMonth()+1) + '-' + (d.getDate() - 1)  ;
        this.consultarSaldosCuenta();
        consultaCuentasBancariasSalida({codigoProducto: this.codigoProducto , clienteId : this.cliente, consultaLogin : true}).then(
            result => {
                this.results = result;
                console.log(result); 
                this.llenarComboBox();

            }).then(
                consultaReferenciaCuentasBancarias({codigoPersonaGestor : this.codigoPersonaGestor , clienteId : this.cliente}).then(
                    result =>{
                        console.log(result); 
                        this.resultsReferenciaBancaria = result;
                        this.llenarComboboxReferenciaBancaria();
                        this.mostrarSeccionRescate = true;
                    }
                ) 
                
            )
            .catch(error =>{
                console.log(error);   
            }) 
           
    }
    consultarSaldosCuenta(){
         
        let movimientosCuentaParticipeInput = {
            codigoProducto : this.codigoProducto,
            codigoCliente : this.codigoPersonaGestor,
           
            numeroCuenta : this.numeroCuentaParticipe            
        };

        let movimientosCuentaInputString = JSON.stringify(movimientosCuentaParticipeInput);
        
        //llamar el servicio para obtener saldos  de cuenta de participe en Gestor
        consultaInformacionAdicionalCuenta({ clienteId: this.clienteId, 
            movimientosCuentaInputString: movimientosCuentaInputString })
        .then((data) => {            
            if(data){                
                if(data.cuentasParticipe.length > 0){
                                
                    this.saldosCuentaParticipe = data.cuentasParticipe[0];    
                     this.mostrarSeccionSaldos = true;                                      
                }               
                
            }
                      
        }).then(
            consultaDatosMontosProducto({codigoProducto : this.codigoProducto, clienteId : this.clienteId}).
            then((result) => {
                if(result){
                    const jsonStringResult =  JSON.stringify(result);
                    const jsonResult = JSON.parse(jsonStringResult);
                    console.log('Data:'+ jsonStringResult);
                    console.log('dataMontos ' + jsonResult.fechaMinimaRescate);
                    this.fechaEfectiva = jsonResult.fechaMinimaRescate;
                }
            }

            )
        ).catch(error => {
             
            console.log(error);                    
        });
    }
    llenarComboBox(){
        
        console.log('length ' +this.results.length);
        for(let i = 0; i<this.results.length;i++){
           // this.combobox.push({label : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta , value : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta});
          this.combobox = [
            ...this.combobox,{label : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta , value : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta}
          ] ;   
        }
        console.log('combobox ->' + this.combobox);
    }
    llenarComboboxReferenciaBancaria(){
        let esBeneficiario =false;
        let valorEtiqueta = '';
        for(let i = 0; i<this.resultsReferenciaBancaria.length;i++){
            esBeneficiario = false;
            console.log('entrara a beneficiario');
            if(this.resultsReferenciaBancaria[i].esBeneficiario){
                console.log('es beneficiario');
                esBeneficiario = true;
             this.referenciaTerceros =  [
                 ...this.referenciaTerceros,{datos : this.resultsReferenciaBancaria[i].identificacion + '-' +  this.resultsReferenciaBancaria[i].nombre , value : this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta}
               ] ;  
             }
             this.referenciaTipoCuenta = [
                ...this.referenciaTipoCuenta,{tipoCuenta: this.resultsReferenciaBancaria[i].codigoTipoCuenta, cuenta: this.resultsReferenciaBancaria[i].numeroCuenta}
             ];
            // this.combobox.push({label : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta , value : this.results[i].codigoTipoEntidadFinanciera + '-' + this.results[i].codigoEntidadFinanciera + '-' + this.results[i].numeroCuenta});
            valorEtiqueta = (esBeneficiario)? 'CUENTA TERCERO : ' : ' CUENTA PROPIA : ';
            valorEtiqueta = valorEtiqueta + this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta;

            this.comboboxReferenciaBancaria = [

             ...this.comboboxReferenciaBancaria,{label :  valorEtiqueta , value : this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta}
           ] ;   
           
            
         }
        
    }

    async handleConfirmClick(message) {
       await LightningAlert.open({
            message: message,
            theme: 'success',
            label: 'Resultado de creación de rescate',
            // setting theme would have no effect
        });
        //result is true if OK was clicked
        //and false if cancel was clicked
         
        //Confirm has been closed
        this.buttonDisabled = false; 
        this.handleFinalizarCreacionRescate();
    }
    async handleConfirmClickError(message) {
        await LightningAlert.open({
             message: message,
             theme: 'error',
             label: 'Resultado de creación de rescate',
             // setting theme would have no effect
         });
         //result is true if OK was clicked
         //and false if cancel was clicked
          
         //Confirm has been closed
         this.buttonDisabled = false; 
         this.handleFinalizarCreacionRescate();
     }
     realizarRescate(){
         
        this.fechaEfectivaGuardar = this.fechaEfectiva;
        console.log('fechaEfectivaGuardar1 ' + this.fechaEfectiva);
        this.fechaEfectiva = '';
        //Se agrega de nuevo el servicio para validar la fecha efectiva
        consultaDatosMontosProducto({codigoProducto : this.codigoProducto, clienteId : this.clienteId})
        .then((result) => {
                if(result){
                    const jsonStringResult =  JSON.stringify(result);
                    const jsonResult = JSON.parse(jsonStringResult);
                    console.log('Data:'+ jsonStringResult);
                    console.log('dataMontos1 ' + jsonResult.fechaMinimaRescate);
                    this.fechaEfectiva = jsonResult.fechaMinimaRescate;
                    //console.log('fechaEfectivaGuardar:'+ fechaEfectivaGuardar);
                    console.log('fechaEfectivaGuardar ' + this.fechaEfectiva);
                }
                if(this.fechaEfectivaGuardar <= this.fechaEfectiva){
                    this.fechaEfectiva
                }else{
                    this.fechaEfectiva= this.fechaEfectivaGuardar
                }
                
                if(this.valorRescate > this.saldosCuentaParticipe.saldoDisponibleEfectivo ){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'No cuenta con suficiente Saldo disponible efectivo ',
                            variant: 'error'
                        })
                    );
                }else {
        
                 
                let codigoTipoEntidadFinancieraProducto = '';
                let codigoEntidadFinancieraProducto= '';
                let numeroCuentaProducto = '';
                let codigoTipoEntidadFinancieraDestino = '';
                let codigoEntidadFinancieraDestino= '';
                let numeroCuentaDestino= '';
                let manejaExcepciones = false;
                let tipoCuenta = '';
                codigoTipoEntidadFinancieraProducto = this.datosCuentaBancariaProducto.split('-')[0];
                codigoEntidadFinancieraProducto = this.datosCuentaBancariaProducto.split('-')[1];
                numeroCuentaProducto = this.datosCuentaBancariaProducto.split('-')[2];
        
                codigoTipoEntidadFinancieraDestino = this.datosCuentaBancariaDestino.split('-')[0];
                codigoEntidadFinancieraDestino = this.datosCuentaBancariaDestino.split('-')[1];
                numeroCuentaDestino = this.datosCuentaBancariaDestino.split('-')[2];
                //manejaExcepciones = (this.tipRescate == 'TOT') ? false : manejaExcepciones;
                tipoCuenta = this.referenciaTipoCuenta.filter((item) => {
                    return item.cuenta == numeroCuentaDestino;
                });
                console.log('if fecha' + this.fechaEfectiva);               
                let registroRescateInput = {
                    codigoAgencia : '1',
                    tipoRescate : this.tipRescate,
                    codigoTipoTransaccion : this.codigoTipoTransaccion,
                    monto :  this.valorRescate,
                    codigoMoneda : '1',
                    fechaEfectiva :this.fechaEfectiva,
                    codigoTipoFormaPago :this.codigoFormaPago,
                    manejaExcepciones: manejaExcepciones,
                    tipoProducto: this.codigoProducto,
                    identificacionCuentaDestino: (this.nombreReferencia !== '') ? this.nombreReferencia.split('-')[0] : '',
                    titularCuentaDestino : (this.nombreReferencia !== '') ? this.nombreReferencia.split('-')[1] : '',
                    cuentaBancariaProducto : {
                        codigoTipoEntidadFinanciera : codigoTipoEntidadFinancieraProducto,
                        codigoEntidadFinanciera : codigoEntidadFinancieraProducto,
                        numeroCuenta : numeroCuentaProducto
                    },
                    cuentaBancariaDestino : {
                        codigoTipoEntidadFinanciera : codigoTipoEntidadFinancieraDestino,
                        codigoEntidadFinanciera : codigoEntidadFinancieraDestino,
                        numeroCuenta : numeroCuentaDestino ,
                        tipoCuenta : (tipoCuenta.length>0) ? tipoCuenta[0].tipoCuenta : ''
                    },
                    saldoDisponible : this.saldosCuentaParticipe.saldoDisponible
                };
                let registroRescateInputString = JSON.stringify(registroRescateInput);
                console.log('registroRescateInputString' + registroRescateInputString);
                if(this.regInpFormAction()) { 
                this.buttonDisabled = true; 
                registraRescate({clienteId : this.cliente, codigoPersonaGestor : this.codigoPersonaGestor,
                    codigoProducto :this.codigoProducto,numeroCuenta : this.numeroCuentaParticipe , 
                    registroRescateInputString : registroRescateInputString , createPdf : true })
                    .then(
                   data => {
                        
                       console.log(data); 
                       if(data == '201' || data == '204'){    
                            
                        console.log('RESCATE CREADO ++++++');
                       this.handleConfirmClick('Creación de rescate realizado.');
        
                        //this.dispatchEvent(new ShowToastEvent({
                          //  title: 'EXITO!',
                          //  message: 'Creación de rescate realizado.',    
                          //  variant: 'success',
                        //}));  
                          // this.handleFinalizarCreacionRescate();
                       }else{
                        let response = JSON.parse(data);
                            let errores = response.errors;                     
                            let mensajeError = '';                    
                            let title = 'Error en la creacion del rescate';
                            console.log('errores ->'+ errores);
                            if(errores && errores.length > 0){                        
                                mensajeError = errores[0].detail;        
                                title = errores[0].detail;                     
                            }               
                            //this.dispatchEvent(
                             //   new ShowToastEvent({
                             //       title: title,
                             //       message: mensajeError,
                             //       variant: 'error'
                             //   })
                            //);
                           //this.handleFinalizarCreacionRescate();
                           this.handleConfirmClickError(title);
                       }
        
                   }
               ).catch(error =>{
                console.log('errror' + error);
                //this.handleConfirmClickError(error);
                     
               })
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Debe de rellenar todos los campos obligatorios',
                        variant: 'error'
                    })
                );
            }
            }
            }

            ).catch(error =>{
                console.log('errror' + error);
                //this.handleConfirmClickError(error);        
            })
        
}
    
    get comboboxcuentaBancariaProducto(){
        return this.combobox;
    }
    get comboboxcuentaBancariaReferencia(){
        return this.comboboxReferenciaBancaria;
    }

    handleFinalizarCreacionRescate(){
        this.dispatchEvent(new CustomEvent('finalizar'));
    }

    regInpFormAction() {
        var isValidVal = true;
        var inputFields = this.template.querySelectorAll('.reqInpFld');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
             
        });
         inputFields = this.template.querySelectorAll('.hijo-campo');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
             
        });
        return isValidVal;
    }

}