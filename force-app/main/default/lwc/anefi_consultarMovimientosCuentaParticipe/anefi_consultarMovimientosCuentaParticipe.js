import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import consultarMovimientosCuentaEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarMovimientosCuentaEnGestor';
import consultaInformacionAdicionalCuenta from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultaInformacionAdicionalCuenta';

const columns = [
    {label: 'Número transacción', fieldName: 'numeroTransaccion' }, 
    { label: 'Fecha Transacción', fieldName: 'fechaTransaccion' },    
    {label: 'Número Unidades', fieldName: 'numeroUnidades', type: 'number', typeAttributes: { maximumFractionDigits: '2'}, cellAttributes: { alignment: 'left' } },       
    {label: 'Tipo Movimiento', fieldName: 'tipoMovimiento' },
    {label: 'Valor Bruto', fieldName: 'valorBruto', type: 'currency', typeAttributes: { currencyCode: 'USD'},cellAttributes: { alignment: 'left' }},
    {label: 'Valor Neto', fieldName: 'valorNeto' ,type: 'currency', typeAttributes: { currencyCode: 'USD'},cellAttributes: { alignment: 'left' } },
    {label: 'Valor Retenciones', fieldName: 'valorRetenciones', type: 'currency', typeAttributes: { currencyCode: 'USD'},cellAttributes: { alignment: 'left' } }
];

export default class Anefi_consultarMovimientosCuentaParticipe extends NavigationMixin(LightningElement) {
    @api clienteId;
    @api codigoProducto;
    @api nombreProducto;
    @api numeroCuenta;
    @api clienteCodigoGestor;
    @api tipoTransaccion;    
    @track fechaHastaMax;
    @track fechaDesde;
    @track fechaHasta;
    @track columns = columns;
    @track movimientosCuenta;
    @track links;
    @track meta;
    @track disabledPrev;
    @track disabledNext;
    @track pageNumber = 0;  
    @track pageSize = 10; 
    @track tituloConsulta;
    @track tituloLista;
    @track mensajeSinRegistros;
    @track cargandoVisible = false;
    @track mostrarTablaMovimientos = false;
    @track mostrarMensajeSinMovimientos = false;
    @track saldosCuentaParticipe;
    @track mostrarSeccionSaldos = false;     
    

    connectedCallback(){
        console.log('codigoProducto: ' + this.codigoProducto);
        this.obtenerFechaHastaMaxima(); 
        this.obtenerTitulos();  
         
    }

    obtenerFechaHastaMaxima(){
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
        
        this.fechaHastaMax = anio + '-' + mes + '-' + dia;        
    }

    obtenerTitulos(){
        switch (this.tipoTransaccion){
            case 'aporte':
                this.tituloConsulta = 'Consultar aportes cuenta de partícipe ' + this.codigoProducto + '-' + this.numeroCuenta;
                this.tituloLista = 'Aportes';
                this.mensajeSinRegistros = 'No existen aportes para el rango de fecha seleccionado';
                break;
            case 'rescate':
                this.tituloConsulta = 'Consultar rescates cuenta de partícipe ' + this.codigoProducto + '-' + this.numeroCuenta;
                this.tituloLista = 'Rescates';
                this.mensajeSinRegistros = 'No existen rescates para el rango de fecha seleccionado';
                break;
            default:
                this.tituloConsulta = 'Consultar movimientos cuenta de partícipe ' + this.codigoProducto + '-' + this.numeroCuenta;
                this.tituloLista = 'Movimientos';
                this.mensajeSinRegistros = 'No existen movimientos para el rango de fecha seleccionado';
                break;
        }
    }

    handleRegresar(){        
        this[NavigationMixin.Navigate]({  
            type: 'standard__recordPage',  
            attributes: {  
                recordId: this.clienteId,  
                objectApiName: 'Account',  
                actionName: 'view'  
            }  
        })  
    }

    handleFechaDesde(event){
        this.fechaDesde = event.target.value;
    }

    handleFechaHasta(event){
        this.fechaHasta = event.target.value;
    }

    handleBuscar(){
        if(this.fechaDesde > this.fechaHastaMax || this.fechaHasta > this.fechaHastaMax){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'El rango de fechas no puede ser mayor a la fecha actual',
                    variant: 'error'
                })
            );
        }
        else{
            
            if(this.tipoTransaccion != 'aporte' && this.tipoTransaccion != 'rescate'){
                if(!this.fechaHasta){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Para consultar movimientos debe seleccionar una fecha hasta',
                            variant: 'error'
                        })
                    );
                }
                else{
                    this.consultarSaldosCuenta();
                }
                
            }
            else{
                this.pageNumber = 1;
                this.consultarMovimientosCuenta();
            }
            
        } 
        
    }

    handlePrevious(){
        this.pageNumber--;
        this.consultarMovimientosCuenta();
    }

    handleNext(){        
        this.pageNumber++;
        this.consultarMovimientosCuenta();    
    } 

    consultarMovimientosCuenta(){
        this.cargandoVisible = true;
        let movimientosCuentaParticipeInput = {
            codigoProducto : this.codigoProducto,
            codigoCliente : this.clienteCodigoGestor,
            fechaDesde : this.fechaDesde,
            fechaHasta :  this.fechaHasta,
            numeroCuenta : this.numeroCuenta,
            tipoTransaccion : this.tipoTransaccion,
            pageNumber : this.pageNumber,
            pageSize: this.pageSize
        };

        let movimientosCuentaInputString = JSON.stringify(movimientosCuentaParticipeInput);
        
        //llamar el servicio para obtener movimientos de cuenta de participe en Gestor
        consultarMovimientosCuentaEnGestor({ clienteId: this.clienteId, 
            movimientosCuentaInputString: movimientosCuentaInputString })
        .then((data) => {
            console.log(data);            
            this.movimientosCuenta = data.data;
            this.links = data.links;
            this.meta = data.meta;                           
            this.actualizarBotonesPaginacion();            
            this.cargandoVisible = false;
            if(this.movimientosCuenta.length > 0){
                this.mostrarMensajeSinMovimientos = false;
                this.mostrarTablaMovimientos = true;
            }
            else{
                this.mostrarMensajeSinMovimientos = true;
                this.mostrarTablaMovimientos = false;
            }
        })
        .catch(error => {
            this.cargandoVisible = false;
            console.log(error);                    
        });
    }

    actualizarBotonesPaginacion(){
        if(this.links.prev){
            this.disabledPrev = false;
        }
        else{
            this.disabledPrev = true;
        }

        if(this.links.next){
            this.disabledNext = false;
        }
        else{
            this.disabledNext = true;
        }
    }

    consultarSaldosCuenta(){
        this.cargandoVisible = true;
        let movimientosCuentaParticipeInput = {
            codigoProducto : this.codigoProducto,
            codigoCliente : this.clienteCodigoGestor,
            fechaDesde : this.fechaDesde,
            fechaHasta :  this.fechaHasta,
            numeroCuenta : this.numeroCuenta            
        };

        let movimientosCuentaInputString = JSON.stringify(movimientosCuentaParticipeInput);
        
        //llamar el servicio para obtener saldos  de cuenta de participe en Gestor
        consultaInformacionAdicionalCuenta({ clienteId: this.clienteId, 
            movimientosCuentaInputString: movimientosCuentaInputString })
        .then((data) => {            
            if(data){                
                if(data.cuentasParticipe.length > 0){
                    this.mostrarSeccionSaldos = true;              
                    this.saldosCuentaParticipe = data.cuentasParticipe[0];                                     
                }               
                
            }
            this.pageNumber = 1; 
            this.consultarMovimientosCuenta();           
        })
        .catch(error => {
            this.cargandoVisible = false;
            console.log(error);                    
        });
    }

    handleGenerarEstadoDeCuenta(){
        this[NavigationMixin.Navigate]({  
            type: 'standard__component',  
            attributes: {  
                componentName: "c__anefi_redireccionAGenerarEstadoDeCuenta"
            },
            state: {                        
                c__clienteId: this.clienteId,
                c__codigoProducto: this.codigoProducto,
                c__numeroCuentaParticipe: this.numeroCuenta,
                c__fechaCorte: this.fechaHasta,
                c__fechaDesde: this.fechaDesde,
                c__nombreComponente : "GenerarEstadoCuenta",
                c__nombreProducto: this.nombreProducto              
            }  
        })
        /*this[NavigationMixin.Navigate]({  
            type: 'standard__component',  
            attributes: {  
                componentName: "c__anefi_redireccionAGenerarEstadoDeCuenta"
            },
            state: {                        
                c__clienteId: this.recordId,
                c__codigoProducto : this.cuentaParticipeSeleccionada.codigoProducto,                       
                c__numeroCuenta : this.cuentaParticipeSeleccionada.numeroCuenta                
            }  
        })*/
    }

    

}