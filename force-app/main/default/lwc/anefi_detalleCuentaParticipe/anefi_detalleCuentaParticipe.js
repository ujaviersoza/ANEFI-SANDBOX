import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';  

export default class Anefi_detalleCuentaParticipe extends NavigationMixin(LightningElement) {
    @api clienteId;
    @api codigoProducto;
    @api nombreProducto;
    @api codigoAgencia;
    @api nombreAgencia;
    @api codigoTrader;
    @api nombreTrader;
    @api numeroCuenta;
    @api codigoTipoCuenta;
    @api nombreTipoCuenta;
    @api fechaApertura;
    @api estado;
    
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


}