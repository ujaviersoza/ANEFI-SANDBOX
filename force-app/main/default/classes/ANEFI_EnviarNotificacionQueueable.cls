/*Clase para enviar notificación de resultado de sincronización de la oportunidad en Gestor*/
public class ANEFI_EnviarNotificacionQueueable implements Queueable,Database.AllowsCallouts {
	@TestVisible static Boolean makeCallout = true;// Esta propiedad se utiliza para evitar que se genere el error de uncommitted work pending en la ejecución de los tests
    public ANEFI_ServicesDTO.Oportunidad oportunidadDTO;
    public String titulo;
    public String mensaje;
    
    public ANEFI_EnviarNotificacionQueueable(ANEFI_ServicesDTO.Oportunidad oportunidadDTO, String titulo, String mensaje){
        this.oportunidadDTO = oportunidadDTO;
        this.titulo = titulo;
        this.mensaje = mensaje;
    }
    
    public void execute(QueueableContext context){
        if(makeCallout)ANEFI_Utilitarios.crearNotificacionSincronizacionOportunidad(oportunidadDTO,titulo,mensaje);
    }
}