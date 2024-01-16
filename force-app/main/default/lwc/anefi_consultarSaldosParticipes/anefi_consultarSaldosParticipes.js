import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import consultarSaldosCuentasDeParticipe from '@salesforce/apex/ANEFI_ConsultarSaldosCuentasParticipeCC.consultarSaldosCuentasDeParticipe';

export default class Anefi_consultarSaldosParticipes extends NavigationMixin(LightningElement) {
    
    @track fechaDesde;
    @track fechaHasta;
    @track cargandoVisible;
    @track mostrarSeccionFiltros;
    @track mostrarConsultaReporte;
    @track fechaHastaMax;
    codigoProductoSeleccionado;
    idInformeSaldosParticipe;
    //valorInicialProducto = 'F001';

    
    connectedCallback(){
        this.cargandoVisible = false;           
        this.mostrarSeccionFiltros = true;
        this.mostrarConsultaReporte = false;
        //this.codigoProductoSeleccionado = this.valorInicialProducto;
        this.obtenerFechaHastaMaxima();
         
    }

    get opcionesProducto() {
        return [            
            { label: 'CP-1', value: 'F001' },
            { label: 'FS-2', value: 'F002' },
            { label: 'Todos', value: 'todos' },
        ];
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

    handleFechaDesde(event){
        this.fechaDesde = event.target.value;
    }

    handleFechaHasta(event){
        this.fechaHasta = event.target.value;
    }

    handleActualizar(){
        if(!this.codigoProductoSeleccionado || !this.fechaHasta ){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error de validación',
                    message: 'Debe seleccionar el producto y la fecha hasta para realizar la actualización de saldos de partícipes.',
                    variant: 'error'
                })
            ); 
        }else if(this.fechaHasta > this.fechaHastaMax){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error de validación',
                    message: 'La fecha hasta no puede ser mayor a la fecha actual.',
                    variant: 'error'
                })
            ); 
        }
        else{
            this.cargandoVisible = true;
            let saldosCuentasParticipeInput = {
                codigoProducto : this.codigoProductoSeleccionado,
                fechaDesde : this.fechaDesde,
                fechaHasta : this.fechaHasta,
                pageNumber : 1,
                pageSize : 500
            }

            consultarSaldosCuentasDeParticipe({ saldosCuentasParticipeInput: saldosCuentasParticipeInput })
            .then(result => {
                this.cargandoVisible = false;
                console.log(result);
                if(!result){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error de actualización',
                            message: 'Error actualizando saldos de partícipes, por favor revise su correo electrónico para mas detalles.',
                            variant: 'error'
                        })
                    ); 
                }
                else{
                    this.idInformeSaldosParticipe = result;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Confirmación',
                            message: 'Saldos de partícipes actualizados correctamente',
                            variant: 'success'
                        })
                    );                               
                    this.mostrarSeccionFiltros = false;
                    this.mostrarConsultaReporte = true;
                }
                
            })
            .catch(error => {
                this.cargandoVisible = false;
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error de actualización',
                        message: 'Error actualizando saldos de partícipes, por favor revise su correo electrónico para mas detalles.',
                        variant: 'error'
                    })
                ); 
                
            });                
        }
    }

    handleChangeProducto(event){
        this.codigoProductoSeleccionado = event.detail.value;        

    }

    handleNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.idInformeSaldosParticipe,
                objectApiName: 'Report',
                actionName: 'view'
            }
        });
        this.mostrarSeccionFiltros = true;
        this.mostrarConsultaReporte = false;
        this.fechaDesde = '';
        this.fechaHasta = '';
        this.codigoProductoSeleccionado = '';
    }

   

}