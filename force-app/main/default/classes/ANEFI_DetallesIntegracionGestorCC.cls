public class ANEFI_DetallesIntegracionGestorCC {
    
    public Opportunity oportunidadSeleccionada {get;set;}
    public Boolean habilitarBotonSincronizacionManual {get;set;}
    
    public ANEFI_DetallesIntegracionGestorCC(ApexPages.StandardController stdController){    	
        oportunidadSeleccionada = (Opportunity)stdController.getRecord();
        obtenerInformacionSincronizacion();
    }
    
    public void obtenerInformacionSincronizacion(){
        List<Opportunity> oportunidades = [Select Id, Estado_sincronizacion_Gestor__c, Sincronizado_en_Gestor__c,
                                           Bloqueado_en_listas_negras_de_Gestor__c, Fecha_de_sincronizacion_en_Gestor__c,
                                           StageName, RecordTypeId, AccountId, OwnerId, Name, 
                                           Account.Codigo_persona_en_Gestor__c, Numero_cuenta_de_participe__c,
										   Numero_transaccion_aporte_en_gestor__c, Codigo_persona_en_Gestor__c,
										   Producto_de_Interes__c, Trader__c, Complementarios__c, Transaccion_cooparticipe__c,
                                           Fecha_efectiva_primer_aporte__c, Numero_documento_deposito__c,Forma_de_Pago__c,
                                           Moneda__c, Amount,Codigo_tipo_entidad_financiera__c,Codigo_entidad_financiera__c,
                                           Numero_de_cuenta_fondo__c
                                          from Opportunity where Id =: oportunidadSeleccionada.Id];
        if(oportunidades.size() > 0){
            oportunidadSeleccionada = oportunidades.get(0);
            //Habilitar botón de sincronización manual si la oportunidad se intentó sincronizar y se presentó error
            if(oportunidadSeleccionada.Estado_sincronizacion_Gestor__c == 'ERROR SINCRONIZACIÓN' 
               && oportunidadSeleccionada.StageName == 'Cerrada ganada'){
                habilitarBotonSincronizacionManual = true;
            }
        }
    }
    
    public PageReference sincronizarOportunidadEnGestor(){  
        PageReference pRef =  (new ApexPages.StandardController (oportunidadSeleccionada)).view();
        try{			             
            //Actualizar el estado a sincronizando de la oportunidad para que el botón no se pueda ejecutar más de una vez
            //hasta que no finaliza la invocación inicial
            oportunidadSeleccionada.Estado_sincronizacion_Gestor__c = 'SINCRONIZANDO';
            update oportunidadSeleccionada;
            
            //Se invoca el proceso de sincronización en Gestor
            ANEFI_CuentaGestorInvocable cuentaGestorInvocable = new ANEFI_CuentaGestorInvocable();
            cuentaGestorInvocable.oportunidad = oportunidadSeleccionada;
            List<ANEFI_CuentaGestorInvocable> cuentasGestorInvocable = new List<ANEFI_CuentaGestorInvocable>();
            cuentasGestorInvocable.add(cuentaGestorInvocable);
            ANEFI_CrearCuentaGestor.crearCuentaEnGestor(cuentasGestorInvocable);                 
        }
        catch(Exception e){
            system.debug('Error sincronizando manualmente la oportunidad:' + e.getMessage());
        }
        pRef.setRedirect(true); 
        return pRef;       
    }

}