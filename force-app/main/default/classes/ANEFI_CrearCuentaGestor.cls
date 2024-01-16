global without sharing class ANEFI_CrearCuentaGestor {
    
    public class CrearCuentaGestorException extends Exception {}
    
    /**
     * Método que crea una cuenta de participe en Gestor a partir de una oportunidad Ganada enviada desde un process builder
     * o desde un flujo
	*/
    @InvocableMethod(label='Crear Cuenta en Gestor' description='Crear cuenta en Gestor Web')
    public static void crearCuentaEnGestor(List<ANEFI_CuentaGestorInvocable> cuentasGestor){        
        for(ANEFI_CuentaGestorInvocable cuentaInvocable: cuentasGestor){            
            if(cuentaInvocable.oportunidad == null) throw new CrearCuentaGestorException('Se debe especificar una oportunidad en el process Builder');
            Opportunity oportunidadGanada = cuentaInvocable.oportunidad;
            try{
                String oportunidadSerializada = ANEFI_SerializadorService.serializarOportunidad(oportunidadGanada);
                Id userProfileId = UserInfo.getProfileId();
                Profile profile = [Select id , name from profile where id =:userProfileId];
                if(!profile.name.contains('Vendedor Fid Inversión')){
                ANEFI_CrearCuentaGestorQueueable crearCuentaGestorQueueable = new ANEFI_CrearCuentaGestorQueueable(oportunidadSerializada);           
                ID jobID = System.enqueueJob(crearCuentaGestorQueueable);                    
                }else{
                    oportunidadGanada.Estado_sincronizacion_Gestor__c =  'SIN SINCRONIZAR';
                    update oportunidadGanada;
                }

            }
            catch(Exception e){
                system.debug('Error sincronizando oportunidad en Gestor: ' + e.getMessage());
            }
        }
    }	
}