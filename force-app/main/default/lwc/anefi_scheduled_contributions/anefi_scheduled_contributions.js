import { LightningElement, api, wire, track} from 'lwc';
import consultContributions from '@salesforce/apex/WebManagerAPI.consultContributions';
import processRecords from '@salesforce/apex/WebManagerAPI.processRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [   { label: 'Cédula o RUC', fieldName: 'identificacion', type: 'text', sortable: true },
                    { label: 'Código Cliente', fieldName: 'codigoCliente', type: 'text', sortable: true },
                    { label: 'Código Producto', fieldName: 'codigoProducto', type: 'text', sortable: true },
                    { label: 'Nombre', fieldName: 'nombre', type: 'text', sortable: true },                  
                    { label: 'Número Cuenta', fieldName: 'numeroCuenta', type: 'text', sortable: true },  
                    { label: 'Banco', fieldName: 'banco', type: 'text', sortable: true },
                    { label: 'Cuenta Bancaria', fieldName: 'cuentaBancaria', type: 'text', sortable: true }, 
                    { label: 'Tipo Cuenta', fieldName: 'tipoCuenta', type: 'text', sortable: true },                    
                    { label: 'Número Aporte Programado', fieldName: 'numeroAporteProgramado', type: 'text', sortable: true },
                    { label: 'Secuencia Aporte', fieldName: 'secuenciaAporte', type: 'text', sortable: true },
                    { label: 'Fecha', fieldName: 'fecha', type: 'date', sortable: true, typeAttributes:{ year: "numeric", month: "2-digit", day: "2-digit", timezone: "UTC" } },
                    { label: 'Monto', fieldName: 'monto', type: 'currency', sortable: true, cellAttributes: { alignment: 'left' } },
                    { label: 'Estado', fieldName: 'estado', type: 'text', sortable: true },
                    { label: 'Canal', fieldName: 'canal', type: 'text', sortable: true }
];

export default class Anefi_scheduled_contributions extends LightningElement {
    
    @track error;
    @track isSpinner = false;
    @track isNextDisable = false;
    @track isPreviousDisable = false;
    @track divVisible = false;

    @track page = 1; //initialize 1st page
    @track items = []; //contains all the records.
    @track data = []; //data  displayed in the table
    @track columns; //holds column info.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageDataSize = 0; //total size data of actual page
    @track pageSize = 10; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track montoTotal = 0;

    @track InnerWrapper  = {
        pageNumber: '1',
        fechaDesde: '',
        fechaHasta: '',
        producto: '-',
        codigoCliente: '-',
        estado: '',
        pageSize: ''
    };

    @track products = '';
    get productOptions() {
        return [
            { label: 'Elija un producto', value: '' },
            { label: 'F001', value: 'F001' },
            { label: 'F002', value: 'F002' },
            { label: 'F003', value: 'F003' },
            { label: 'F004', value: 'F004' },
            { label: 'F005', value: 'F005' }
        ];
    }

    @track thestatus = '';
    get statusOptions() {
        return [
            { label: 'Elija un estado', value: '' },
            { label: 'PEN', value: 'PEN' },
            { label: 'GEN', value: 'GEN' }
        ];
    }    

    @track dateSince = new Date().toISOString().substring(0, 10);    
    @track dateUntil = new Date().toISOString().substring(0, 10);
    @track product;
    @track status;
    @track codeClient;

    connectedCallback() {
        this.isSpinner = true;
        this.InnerWrapper.fechaDesde = new Date().toISOString().substring(0, 10);
        this.InnerWrapper.fechaHasta = new Date().toISOString().substring(0, 10);

        consultContributions({
            innerWrapper: this.InnerWrapper
        })
        .then(result =>{ //console.log('Resultado: '+JSON.stringify(result));
            if(result.isOK == false) {
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'El servicio web está caído: '+result.msgError+ ', consulte con el administrador de la API.',
                    variant: "error",
                });
                this.dispatchEvent(event);
            } else if(result.data.length > 0) {
                this.items = result.data;
                this.totalRecountCount = JSON.stringify(result.totalElements);
                this.totalPage = result.totalPages;
                //here we slice the data according page size
                this.data = this.items.slice(0,this.pageSize); 
                this.endingRecord = this.pageSize;
                this.pageDataSize = JSON.stringify(result.data.length);
                this.montoTotal = result.montoTotal;
                this.columns = columns;
                this.error = undefined;
                this.isSpinner = false;
                this.divVisible = true;

                this.startingRecord = ((this.page -1) * this.pageSize) ;
                this.endingRecord = (this.pageSize * this.page);

                this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                                    ? this.totalRecountCount : this.endingRecord; 

                this.data = this.items.slice(this.startingRecord, this.endingRecord);

                //increment by 1 to display the startingRecord count, 
                //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
                this.startingRecord = this.startingRecord + 1;

                this.isPreviousDisable = (this.endingRecord == JSON.stringify(this.data.length)) ? true : false;
                
                this.isNextDisable = (this.page == this.totalPage) ? true : false;
            } else {
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Sin registros',
                    message: 'No hay registros para visualizar',
                    variant: "info",
                });
                this.dispatchEvent(event);    
            }
        })
        .catch(error=>{
            this.error = error;
            this.isSpinner = false;
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Se generó un error en la API: '+this.error,
                variant: "error",
            });
            this.dispatchEvent(event);  
        });

        //this.displayRecordPerPage(this.page);
    }

    consultRecords() {
        this.template.querySelector("lightning-datatable").draftValues = [];
        
        this.startingRecord = 1;
        this.endingRecord = 0;
        this.totalRecountCount = 0;
        this.page = 1;
        this.totalPage = 0;
        this.isSpinner = true;

        this.dateSince = this.template.querySelector("lightning-input[data-datesince]").value;
        this.dateUntil = this.template.querySelector("lightning-input[data-dateuntil]").value;
        this.product = this.template.querySelector("lightning-select[data-selectproduct]").value;
        this.status = this.template.querySelector("lightning-select[data-selectstatus]").value;
        this.codeClient = this.template.querySelector("lightning-input[data-codeclient]").value; 

        this.InnerWrapper.pageNumber = '1';
        this.InnerWrapper.fechaDesde =  this.dateSince;
        this.InnerWrapper.fechaHasta = this.dateUntil;
        this.InnerWrapper.producto = (this.product !== '') ? this.product : '-';
        this.InnerWrapper.codigoCliente = (this.codeClient !== '') ? this.codeClient : '-';
        this.InnerWrapper.estado =  this.status;
        
        if((this.dateSince === '' && this.dateUntil === '') || (this.dateSince !== '' && this.dateUntil === '') || (this.dateSince !== '' && this.dateUntil === null) || (this.dateSince === null && this.dateUntil !== '') || (this.dateSince === '' && this.dateUntil !== '')) {
            this.isSpinner = false;
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Debe completar los campos requeridos: Fecha desde y Fecha hasta',
                variant: "error",
            });
            this.dispatchEvent(event);
        } else {   
            consultContributions({
                innerWrapper: this.InnerWrapper
            })
            .then(result =>{
                if(result.isOK == false) {
                    this.isSpinner = false;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: 'El servicio web está caído: '+result.msgError+ ', consulte con el administrador de la API.',
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                } else if(result.data.length > 0) {
                    this.items = result.data;
                    this.totalRecountCount = JSON.stringify(result.totalElements);
                    this.totalPage = result.totalPages;
                    //here we slice the data according page size
                    this.data = this.items.slice(0,this.pageSize); 
                    this.endingRecord = this.pageSize;
                    this.pageDataSize = JSON.stringify(result.data.length);
                    this.columns = columns;
                    this.error = undefined;
                    this.isSpinner = false;
                    this.divVisible = true;

                    this.startingRecord = ((this.page -1) * this.pageSize) ;
                    this.endingRecord = (this.pageSize * this.page);

                    this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                                        ? this.totalRecountCount : this.endingRecord; 

                    this.data = this.items.slice(this.startingRecord, this.endingRecord);

                    //increment by 1 to display the startingRecord count, 
                    //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
                    this.startingRecord = this.startingRecord + 1;

                    this.isPreviousDisable = (this.endingRecord == JSON.stringify(this.data.length)) ? true : false;
                    
                    this.isNextDisable = (this.page == this.totalPage) ? true : false;
                } else {
                    this.isSpinner = false;
                    const event = new ShowToastEvent({
                        title: 'Sin registros',
                        message: 'No hay registros para visualizar',
                        variant: "info",
                    });
                    this.dispatchEvent(event);    
                }
            })
            .catch(error=>{
                this.error = error;
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Se generó un error en la API: '+this.error,
                    variant: "error",
                });
                this.dispatchEvent(event); 
            });

            //this.displayRecordPerPage(this.page);
        }
    }
    
    //press on previous button this method will be called
    previousHandler() {
        this.template.querySelector("lightning-datatable").draftValues = [];
        this.isSpinner = true;

        this.dateSince = this.template.querySelector("lightning-input[data-datesince]").value;
        this.dateUntil = this.template.querySelector("lightning-input[data-dateuntil]").value;
        this.product = this.template.querySelector("lightning-select[data-selectproduct]").value;
        this.status = this.template.querySelector("lightning-select[data-selectstatus]").value;
        this.codeClient = this.template.querySelector("lightning-input[data-codeclient]").value; 

        this.InnerWrapper.fechaDesde =  this.dateSince;
        this.InnerWrapper.fechaHasta = this.dateUntil;
        this.InnerWrapper.producto = (this.product !== '') ? this.product : '-';
        this.InnerWrapper.codigoCliente = (this.codeClient !== '') ? this.codeClient : '-';
        this.InnerWrapper.estado =  this.status;

        if (this.page > 1) {
            this.page = this.page - 1;
            this.InnerWrapper.pageNumber = this.page;

            consultContributions({
                innerWrapper: this.InnerWrapper
            })
            .then(result =>{      console.log('Resultados son:', JSON.stringify(result));                      
                this.items = result.data;
                this.totalRecountCount = JSON.stringify(result.totalElements);
                this.totalPage = result.totalPages;
                //here we slice the data according page size
                this.data = this.items.slice(0,this.pageSize); 
                this.columns = columns;
                this.error = undefined;
                this.isSpinner = false;
                this.divVisible = true;
            })
            .catch(error=>{
                this.error = error;
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Se generó un error en la API: '+this.error,
                    variant: "error",
                });
                this.dispatchEvent(event); 
            });

            this.displayRecordPerPage(this.page);
        }
    }

    //press on next button this method will be called
    nextHandler() {      
        this.template.querySelector("lightning-datatable").draftValues = [];
        this.isSpinner = true;

        this.dateSince = this.template.querySelector("lightning-input[data-datesince]").value;
        this.dateUntil = this.template.querySelector("lightning-input[data-dateuntil]").value;
        this.product = this.template.querySelector("lightning-select[data-selectproduct]").value;
        this.status = this.template.querySelector("lightning-select[data-selectstatus]").value;
        this.codeClient = this.template.querySelector("lightning-input[data-codeclient]").value; 

        this.InnerWrapper.fechaDesde =  this.dateSince;
        this.InnerWrapper.fechaHasta = this.dateUntil;
        this.InnerWrapper.producto = (this.product !== '') ? this.product : '-';
        this.InnerWrapper.codigoCliente = (this.codeClient !== '') ? this.codeClient : '-';
        this.InnerWrapper.estado =  this.status;

        if((this.page < this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; 
            this.InnerWrapper.pageNumber = this.page;

            consultContributions({
                innerWrapper: this.InnerWrapper
            })
            .then(result =>{        console.log('Resultados son:', JSON.stringify(result));                   
                this.items = result.data;
                this.totalRecountCount = JSON.stringify(result.totalElements);
                this.totalPage = result.totalPages;
                //here we slice the data according page size
                this.data = this.items.slice(0,this.pageSize); 
                this.columns = columns;
                this.error = undefined;
                this.isSpinner = false;
                this.divVisible = true;
            })
            .catch(error=>{
                this.error = error;
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Se generó un error en la API: '+this.error,
                    variant: "error",
                });
                this.dispatchEvent(event); 
            });

            this.displayRecordPerPage(this.page);            
        }            
    }

    //this method displays records page by page
    displayRecordPerPage(page) {
        this.startingRecord = ((page -1) * this.pageSize); 
        
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.data = this.items.slice(this.startingRecord, this.endingRecord);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;

        this.isPreviousDisable = (page == 1) ? true : false;
        
        this.isNextDisable = (this.page == this.totalPage) ? true : false;                              
    }
    
    columnHeader = ['Código Cliente', 'Código Producto', 'Número Cuenta', 'Banco', 'Cuenta Bancaria', 'Tipo Cuenta', 'Número Aporte Programado', 'Secuencia Aporte', 'Fecha', 'Monto', 'Estado', 'Canal'];
    @track InnerWrapper2  = {
        pageNumber: '1',
        fechaDesde: '',
        fechaHasta: '',
        producto: '-',
        codigoCliente: '-',
        estado: '',
        pageSize: ''
    };

    exportData(){ 
        this.dateSince = this.template.querySelector("lightning-input[data-datesince]").value;
        this.dateUntil = this.template.querySelector("lightning-input[data-dateuntil]").value;
        this.product = this.template.querySelector("lightning-select[data-selectproduct]").value;
        this.status = this.template.querySelector("lightning-select[data-selectstatus]").value;
        this.codeClient = this.template.querySelector("lightning-input[data-codeclient]").value;

        this.InnerWrapper2.pageSize = this.totalRecountCount;
        this.InnerWrapper2.fechaDesde =  this.dateSince;
        this.InnerWrapper2.fechaHasta = this.dateUntil;
        this.InnerWrapper2.producto = (this.product !== '') ? this.product : '-';
        this.InnerWrapper2.codigoCliente = (this.codeClient !== '') ? this.codeClient : '-';
        this.InnerWrapper2.estado =  this.status;

        this.isSpinner = true;
        
        if((this.dateSince === '' && this.dateUntil === '') || (this.dateSince !== '' && this.dateUntil === '') || (this.dateSince !== '' && this.dateUntil === null) || (this.dateSince === null && this.dateUntil !== '') || (this.dateSince === '' && this.dateUntil !== '')) {
            this.isSpinner = false;
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Debe completar los campos requeridos: Fecha desde y Fecha hasta',
                variant: "error",
            });
            this.dispatchEvent(event);
        } else {   
            consultContributions({
                innerWrapper: this.InnerWrapper2
            })
            .then(result =>{
                if(result.isOK == false) {
                    this.isSpinner = false;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: 'El servicio web está caído: '+result.msgError+ ', consulte con el administrador de la API.',
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                } else {
                    this.allRecords = result.data; 
                    this.isSpinner = false;

                    // Prepare a html table
                    let doc = '<table>';
                    // Add styles for the table
                    doc += '<style>';
                    doc += 'table, th, td {';
                    doc += '    border: 1px solid black;';
                    doc += '    border-collapse: collapse;';
                    doc += '}';          
                    doc += '</style>';
                    // Add all the Table Headers
                    doc += '<tr>';
                    this.columnHeader.forEach(element => {            
                        doc += '<th>'+ element +'</th>'           
                    });
                    doc += '</tr>';
                    // Add the data rows
                    this.allRecords.forEach(record => {
                        doc += '<tr>';
                        doc += '<th>'+record.codigoCliente+'</th>'; 
                        doc += '<th>'+record.codigoProducto+'</th>'; 
                        doc += '<th>'+record.numeroCuenta+'</th>';
                        doc += '<th>'+record.banco+'</th>';
                        doc += '<th>'+record.cuentaBancaria+'</th>';
                        doc += '<th>'+''+'</th>';
                        doc += '<th>'+record.numeroAporteProgramado+'</th>';
                        doc += '<th>'+record.secuenciaAporte+'</th>';
                        doc += '<th>'+record.fecha+'</th>';
                        doc += '<th>'+record.monto+'</th>';
                        doc += '<th>'+record.estado+'</th>';
                        doc += '<th>'+record.canal+'</th>'; 
                        doc += '</tr>';
                    });
                    doc += '</table>';
                    var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
                    let downloadElement = document.createElement('a');
                    downloadElement.href = element;
                    downloadElement.target = '_self';
                    // use .csv as extension on below line if you want to export data as csv
                    downloadElement.download = 'Data.xls';
                    document.body.appendChild(downloadElement);
                    downloadElement.click();
                }
            })
            .catch(error=>{
                this.error = error;
                this.isSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Se generó un error en la API: '+this.error,
                    variant: "error",
                });
                this.dispatchEvent(event); 
            });
        } 
    }

    @track WrapperProcess  = {
        codigoProducto: '',
        codigoCliente: '',
        fechaDesde: '',
        fechaHasta: '',
        monto: 0
    };

    @track event;
    @track relatedRecordResult;

    processRecords() {
        let records =  this.template.querySelector("lightning-datatable").getSelectedRows();  

        if(records.length == 0) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Debe seleccionar al menos un registro',
                variant: "error",
            });
            this.dispatchEvent(event);
        } else {
            processRecords({wrapperProcess: records})
            
            this.isSpinner = true;
            setTimeout(function(){
                window.location.reload();
            }, 10000);
        }

    } 
}