import { LightningElement,track,api,wire } from 'lwc';
import consultaCuentasBancariasSalida from '@salesforce/apex/ANEFI_CreaRescate.consultaCuentas';
import consultaReferenciaCuentasBancarias from '@salesforce/apex/ANEFI_CreaRescate.consultaCuentasReferenciaBancaria';
import registraRescate from '@salesforce/apex/ANEFI_CreaRescate.registraRescate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import creaRescateProgramado from '@salesforce/apex/ANEFI_CreaRescate.creaRescateProgramado';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';

export default class Anefi_creaRescateProgramado extends LightningElement {
    @api codigoProducto;
    @api codigoPersonaGestor;
    @api numeroCuentaParticipe;
    @api results = [];
    @api resultsReferenciaBancaria = [];
    @api cliente;
    @track agencia = 1;
    @track codigoTipoTransaccion;
    @track valorRescate = 0;
    @track codigoMoneda  = 1;
    @track fechaMinima;
    @track tipRescate;
    @track combobox = [];
    @track comboboxReferenciaBancaria = [];
    @track codigoFormaPago = 'TRANS';
    @track mapeoExcepciones = false;
    @track mostrarPeriodo = false;
    @track fechaEfectiva = '';
    @track fechaEjecucionRescate;
    @track datosCuentaBancariaProducto;
    @track datosCuentaBancariaDestino;
    @track frecuenciaRescate;
    @track nombreReferencia;
    @track mostrarReferencia = false;
    @track mostrarMonto = true;
    @track referenciaTerceros = [];
    @track periodoRescate = 0;
    get tipoRescate(){
        return [
            {label : 'Parcial', value : 'PAR'},
            {label : 'Total', value : 'TOT'}
        ];
    }
    changeHandler(event){ 

        if(event.target.name === 'monto'){
            this.valorRescate =  event.target.value;

        }else if(event.target.name === 'tipoRescate'){
            this.tipRescate = event.target.value;
            this.codigoTipoTransaccion = (event.target.value === 'PAR') ? 'PFP' : 'LT';
            if(event.target.value === 'TOT'){
                this.valorRescate = 0;
                this.mostrarMonto = false;
            }else{
                this.mostrarMonto = true;
            }
           
        }else if(event.target.name === 'cuentaBancariaDestino'){
            this.datosCuentaBancariaProducto = event.target.value;
        }else if(event.target.name === 'cuentaBancariaReferencia'){
            this.datosCuentaBancariaDestino = event.target.value;
            this.mostrarReferencia = false;
            let existsReferencia = this.referenciaTerceros.filter((item) => {
                return item.value == event.target.value; 
            });
             
            if(existsReferencia.length>0){
                this.mostrarReferencia = true;
                this.nombreReferencia = existsReferencia[0].datos ;
            }
        }else if(event.target.name === 'fechaEfectiva'){
            this.fechaEfectiva = event.target.value;
            let Months = ["January","February","March","April","May","June","July","August","September","Octuber","November","December"];

            //let date = new Date(this.fechaEfectiva);
            //let day = date.getDay();
             
            let fechaE =   this.template.querySelector('.reqInpFld');
            let date2 = new Date(this.fechaEfectiva);

            let day2 = date2.getDate() + 1;
            let fechaString = Months[date2.getMonth()]+' '+ day2 +', '+date2.getFullYear()+' 13:15:30'
            let date = new Date(fechaString);

            let day = date.getDay();
            console.log('fecha utc' + date);
            console.log('day utc ' + day);
            if(day === 0 || day === 6){
                fechaE.setCustomValidity('Fecha Efectiva no puede ser Sábado o Domingo');
            }else{
                fechaE.setCustomValidity('');
            }
            fechaE.reportValidity();
        }else if(event.target.name === 'FrecuenciaRescate'){
            this.mostrarPeriodo = (event.target.value === '2') ? true :false;
            this.frecuenciaRescate= event.target.value;
        }else if(event.target.name === 'fechaEjecucionRescate'){
            this.fechaEjecucionRescate = event.target.value;  
            
            let Months = ["January","February","March","April","May","June","July","August","September","Octuber","November","December"];

            //let date = new Date(this.fechaEfectiva);
            //let day = date.getDay();
             
            let fechaE =   this.template.querySelector('.reqFechaEje');
            let date2 = new Date(this.fechaEjecucionRescate);

            let day2 = date2.getDate() + 1;
            let fechaString = Months[date2.getMonth()]+' '+ day2 +', '+date2.getFullYear()+' 13:15:30'
            let date = new Date(fechaString);

            let day = date.getDay();
            console.log('fecha utc' + date);
            console.log('day utc ' + day);

            if(day === 0 || day === 6){
                fechaE.setCustomValidity('Fecha Ejecución no puede ser Sábado o Domingo');
            }else{
                fechaE.setCustomValidity('');
            }
            fechaE.reportValidity();
        }else if(event.target.name === 'periodo'){
            this.periodoRescate = event.target.value;
        }
    }
    connectedCallback(){
        console.log('entro');
        var d = new Date();
        this.fechaMinima  = d.getFullYear() + '-' + (d.getMonth()+1) + '-' + (d.getDate() - 1)  ;
        consultaCuentasBancariasSalida({codigoProducto: this.codigoProducto , clienteId : this.cliente, consultaLogin : true}).then(
            result => {
                this.results = result;
                console.log(result); 
                this.llenarComboBox();

            }).then(
                consultaReferenciaCuentasBancarias({codigoPersonaGestor : this.codigoPersonaGestor , clienteId : this.cliente}).then(
                    result =>{
                        this.resultsReferenciaBancaria = result;
                        this.llenarComboboxReferenciaBancaria();
                    }
                )
            )
            .catch(error =>{
                console.log(error);   
            }) 
    }
    llenarComboBox(){
        
        console.log('length ' +this.results.length);
        for(let i = 0; i<this.results.length;i++){
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
            if(this.resultsReferenciaBancaria[i].esBeneficiario){
                console.log('es beneficiario');
                esBeneficiario = true;
             this.referenciaTerceros =  [
                 ...this.referenciaTerceros,{datos : this.resultsReferenciaBancaria[i].identificacion + '-' +  this.resultsReferenciaBancaria[i].nombre , value : this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta}
               ] ;  
             }
             valorEtiqueta = (esBeneficiario)? 'CUENTA TERCERO : ' : ' CUENTA PROPIA : ';
             valorEtiqueta = valorEtiqueta + this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta;
           this.comboboxReferenciaBancaria = [
             ...this.comboboxReferenciaBancaria,{label : valorEtiqueta , value : this.resultsReferenciaBancaria[i].codigoTipoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].codigoEntidadFinanciera + '-' + this.resultsReferenciaBancaria[i].numeroCuenta}
           ] ;   

          
         }
        

    }

    creaRescate(){
        let codigoTipoEntidadFinancieraProducto = '';
        let codigoEntidadFinancieraProducto= '';
        let numeroCuentaProducto = '';
        let codigoTipoEntidadFinancieraDestino = '';
        let codigoEntidadFinancieraDestino= '';
        let numeroCuentaDestino= '';
        let mensaje = '';
        let manejaExcepciones = true;
        codigoTipoEntidadFinancieraProducto = this.datosCuentaBancariaProducto.split('-')[0];
        codigoEntidadFinancieraProducto = this.datosCuentaBancariaProducto.split('-')[1];
        numeroCuentaProducto = this.datosCuentaBancariaProducto.split('-')[2];

        codigoTipoEntidadFinancieraDestino = this.datosCuentaBancariaDestino.split('-')[0];
        codigoEntidadFinancieraDestino = this.datosCuentaBancariaDestino.split('-')[1];
        numeroCuentaDestino = this.datosCuentaBancariaDestino.split('-')[2];
        console.log('llamar a crear rescate programado');
        console.log('llamar a crear rescate codigoFormaPago'+ this.codigoFormaPago);
        console.log('llamar a crear rescate codigoTipoTransaccion'+ this.codigoTipoTransaccion);

        console.log('llamar a crear rescate cliente'+ this.cliente);
        console.log('llamar a crear rescate codigoPersonaGestor'+ this.codigoPersonaGestor);
        console.log('llamar a crear rescate codigoEntidadFinancieraDestino'+ codigoEntidadFinancieraDestino);
        console.log('llamar a crear rescate codigoEntidadFinancieraDestino'+ codigoEntidadFinancieraDestino);
        console.log('llamar a crear rescate fechaEfectiva'+ this.fechaEfectiva);
        console.log('llamar a crear rescate fechaEjecucionRescate'+ this.fechaEjecucionRescate);
        console.log('llamar a crear rescate valorRescate'+ this.valorRescate);
        console.log('llamar a crear rescate numeroCuentaProducto'+ numeroCuentaProducto);
        console.log('llamar a crear rescate numeroCuentaDestino'+ numeroCuentaDestino);
        console.log('llamar a crear rescate numeroCuentaDestino'+ this.numeroCuentaParticipe);
        console.log('llamar a crear rescate codigoProducto'+ this.codigoProducto);
        console.log('llamar a crear rescate tipRescate'+ this.tipRescate);
        console.log('llamar a crear rescate codigoTipoEntidadFinancieraProducto'+ codigoTipoEntidadFinancieraProducto);

        console.log('llamar a crear rescate codigoTipoEntidadFinancieraDestino'+ codigoTipoEntidadFinancieraDestino);
        console.log('llamar a crear rescate frecuenciaRescate'+ this.frecuenciaRescate);
        manejaExcepciones = (this.tipRescate == 'TOT') ? false : manejaExcepciones;
        if(this.regInpFormAction()) { 
        creaRescateProgramado({agencia : '1', codigoMoneda : '1',codigoFormaPago : this.codigoFormaPago, codigoTipoTransaccion: this.codigoTipoTransaccion,
        clienteId: this.cliente, codigoGestorParticipe :  this.codigoPersonaGestor, entidadFinancieraProducto : codigoEntidadFinancieraProducto, entidadFinancieraDestino  : codigoEntidadFinancieraDestino,
        fechaEfectiva : this.fechaEfectiva, fechaEjecucionRescate : this.fechaEjecucionRescate, manejaExcepciones : manejaExcepciones ,  montoRescate : this.valorRescate, numeroCuentaProducto : numeroCuentaProducto, 
        numeroCuentaDestino : numeroCuentaDestino , numeroCuentaGestor : this.numeroCuentaParticipe , productoRescate : this.codigoProducto, tipoRescate : this.tipRescate,
        tipoEntidadProducto : codigoTipoEntidadFinancieraProducto, tipoEntidadDestino : codigoTipoEntidadFinancieraDestino, usuarioCreoRescate : '' , frecuenciaRescate  : this.frecuenciaRescate, periodo : this.periodoRescate})
        .then(result => {
            console.log('respuesta llamada' + result);
            if(result === 'OK'){
                 mensaje = 'Rescate creado exitosamente';
                  
            }else{
                mensaje = 'Error al crear el rescate, contacte a su administrador';
            }
            
        }).catch(error =>{
            mensaje = 'Error al crear el rescate, contacte a su administrador';
            console.log(error);   

        }) 
        this.dispatchEvent(new ShowToastEvent({
            title: 'Rescate programado creado.!',
            message: mensaje,    
            variant: 'success',
        })); 
        updateRecord({ fields: { Id: this.cliente } });
        getRecordNotifyChange([{recordId: this.cliente}]);
       // eval("$A.get('e.force:refreshView').fire();");
        this.handleFinalizarCreacionRescateProgramado();
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
    
    get opcionesFrecuencia() {
        return [            
            { label: 'Única', value: '1' },
            { label: 'Mensual', value: '2' }
        ];
    }
    get comboboxcuentaBancariaDestino(){
        return this.combobox;
    }
    get comboboxcuentaBancariaReferencia(){
        return this.comboboxReferenciaBancaria;
    }
    handleFinalizarCreacionRescateProgramado(){
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
        inputFields = this.template.querySelectorAll('.reqFechaEje');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
             
        });
        
        return isValidVal;
    }
}