public with sharing class ANEFI_ConsultarClienteEnGestorController {
    
    public class ConsultaRelacion{

        @AuraEnabled
        public String objectApiName;
        
        @AuraEnabled
        public String codigo;

    }
    
    public class OportunidadAporte{
        public String clienteId;
        public String numeroCuentaParticipe;
        public String codigoProducto;
        public String nombre;
        public Decimal monto;
        public String productoDeInteres;
        public String trader;
        public String complementarios;
        public String transaccionCooparticipe;
        public String fechaEfectivaPrimerAporte;
		public String numeroDocumentoDeposito;
        public String formaDePago;
        public String moneda;
        public String entidadFinanciera;
    }

    @AuraEnabled()
    public static ANEFI_ServicesDTO.ConsultaPersonaNatural consultarInformacionPersonaNaturalEnGestor(String clienteId){
        return ANEFI_GestionarParticipeGestor.consultarInformacionPersonaNaturalEnGestor(clienteId);
    }

    @AuraEnabled()
    public static ANEFI_ServicesDTO.ConsultaPersonaJuridica consultarInformacionPersonaJuridicaEnGestor(String clienteId){
        return ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(clienteId);
    }
    
 	@AuraEnabled()
    public static String consultarInformacionPersonaJuridicaEnGestorJson(String clienteId){
        return JSON.serialize(ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(clienteId));
    }
    @AuraEnabled(Cacheable=true)
    public static String consultarRelacion(String objectApiName, String codigo){
        String resp = '';
        if(objectApiName.equals('ANEFI_Pais__c')){
            List<ANEFI_Pais__c> pais = [SELECT Id, Name, Codigo_Pais__c FROM ANEFI_Pais__c WHERE Codigo_Pais__c = :codigo WITH SECURITY_ENFORCED];
            if(pais != null && pais.size() > 0 ){
                resp = pais.get(0).Id;
            }
        }
        else if(objectApiName.equals('ANEFI_Actividad_Economica__c')){
            List<ANEFI_Actividad_Economica__c> actividadEconomica = [SELECT Id, Name FROM ANEFI_Actividad_Economica__c WHERE Name = :codigo WITH SECURITY_ENFORCED];
            if(actividadEconomica != null && actividadEconomica.size() > 0 ){
                resp = actividadEconomica.get(0).Id;
            }
        }
        else if(objectApiName.equals('ANEFI_Canton__c')){
            List<ANEFI_Canton__c> canton = [SELECT Id, Name, 	Nombre_canton__c FROM ANEFI_Canton__c WHERE Name = :codigo WITH SECURITY_ENFORCED];
            if(canton != null && canton.size() > 0 ){
                resp = canton.get(0).Id;
            }
        }
        else if(objectApiName.equals('ANEFI_Entidad_financiera__c')){
            List<ANEFI_Entidad_financiera__c> entidadFinanciera = [SELECT Id, Name FROM ANEFI_Entidad_financiera__c WHERE Name = :codigo WITH SECURITY_ENFORCED];
            if(entidadFinanciera != null && entidadFinanciera.size() > 0 ){
                resp = entidadFinanciera.get(0).Id;
            }
        }   
        return resp;
    }
    
    @AuraEnabled()
    public static List<ANEFI_ServicesDTO.ItemCuentaParticipe> consultarCuentasParticipeEnGestor(String clienteId, String codigoPersonaEnGestor){
        return ANEFI_GestionarParticipeGestor.consultarCuentasDeParticipeEnGestor(clienteId, codigoPersonaEnGestor);
    }
    
    @AuraEnabled()
    public static ANEFI_ServicesDTO.MovimientosCuentaParticipeOut consultarMovimientosCuentaEnGestor(String clienteId, String movimientosCuentaInputString){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = null;
        if(!String.isBlank(movimientosCuentaInputString) && !String.isEmpty(movimientosCuentaInputString) ){
            ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = 
            (ANEFI_ServicesDTO.MovimientosCuentaParticipeInput)
        	JSON.deserialize(movimientosCuentaInputString, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput.class);           
            
            movimientosCuentaParticipeOut = ANEFI_GestionarParticipeGestor.consultaMovimientosDeCuentaParticipe(clienteId, movimientosCuentaParticipeInput);        }        
        	
        return movimientosCuentaParticipeOut;
    }
    
    @AuraEnabled()
    public static ANEFI_ServicesDTO.InformacionAdicionalCuenta consultaInformacionAdicionalCuenta(String clienteId, String movimientosCuentaInputString){
        ANEFI_ServicesDTO.InformacionAdicionalCuenta informacionAdicionalCuenta = null;
        if(!String.isBlank(movimientosCuentaInputString) && !String.isEmpty(movimientosCuentaInputString) ){
            ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = 
            (ANEFI_ServicesDTO.MovimientosCuentaParticipeInput)
        	JSON.deserialize(movimientosCuentaInputString, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput.class);           
            
            informacionAdicionalCuenta = ANEFI_GestionarParticipeGestor.consultaInformacionAdicionalCuenta(clienteId, movimientosCuentaParticipeInput);  
        }        
        	
        return informacionAdicionalCuenta;
    }
    
    @AuraEnabled()
    public static String actualizarPersonaEnGestor(String clienteId, String clienteCodigoGestor){
        
        return ANEFI_GestionarParticipeGestor.actualizarPersonaEnGestor(clienteId, clienteCodigoGestor);
    }
    
    @AuraEnabled()
    public static String actualizarPersonaEnGestorCorreo(String clienteId, String clienteCodigoGestor, String correoElectronico, String principal, String esDireccionEstadoCuenta ){
        return ANEFI_GestionarParticipeGestor.actualizarPersonaEnGestorCorreo(clienteId, clienteCodigoGestor, correoElectronico, principal, esDireccionEstadoCuenta);
    }
    
    /*@AuraEnabled()
    public static String obtenerContenidoPDF(){
        PageReference pref= Page.ANEFI_GenerarEstadoDeCuentaPage;
        pref.setRedirect(true); 
        Blob b;       
        b = pref.getContent();
        string contenidoBase64 = EncodingUtil.base64Encode(b);
        
        return contenidoBase64;
    }*/
    
    @AuraEnabled()
    public static String registrarReferenciaBancariaEnGestor(String clienteId, String clienteCodigoGestor,String accion, String registroReferenciaBancariaInputString){
        String codigoRespuestaCreacionReferencia = null;
        if(!String.isBlank(registroReferenciaBancariaInputString) && !String.isEmpty(registroReferenciaBancariaInputString) ){
            ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput = 
            (ANEFI_ServicesDTO.RegistroReferenciaBancariaInput)
        	JSON.deserialize(registroReferenciaBancariaInputString, ANEFI_ServicesDTO.RegistroReferenciaBancariaInput.class);           
            
            codigoRespuestaCreacionReferencia = ANEFI_GestionarParticipeGestor.crearReferenciaBancariaEnGestor(clienteId,clienteCodigoGestor, accion, registroReferenciaBancariaInput);  
        }        
        	
        return codigoRespuestaCreacionReferencia;
    }
    
    /*Método que se utiliza para consultar desde el componente de creación de oportunidad de aporte las entidades financieras que coincidan
	con el criterio de búsqueda*/
    @AuraEnabled()
    public static List<SObject> findRecords(String searchKey, String objectName, String searchField, String codigoProducto){
        String searchquery='FIND \''+ String.escapeSingleQuotes(searchKey) + '*\' IN ALL FIELDS RETURNING ANEFI_Entidad_financiera__c(id,name,Nombre__c where Codigo_fiducia__c = \''
            + String.escapeSingleQuotes(codigoProducto) + '\')'; 
        
        List<List<sObject>> searchList = search.query(searchquery);
        List<ANEFI_Entidad_financiera__c> entidadesFinancieras = (List<ANEFI_Entidad_financiera__c>)searchList[0];
        return entidadesFinancieras;  
    }
      
    /*Método para obtener los tipos de registros de oportunidad desde el componente de selección de tipo de nueva oportunidad
	Si se esta creando una oportunidad desde cero retornara los tipos de registros de oportunidad a excepción de los de aporte
	Si se esta creando una oportunidad desde un cliente o desde un contacto retorna el tipo de registros que coincide con el tipo
	de registro del objeto relacionado*/
    @AuraEnabled()
    public static Map<String,String> obtenerTiposRegistroOportunidad(String objectId){     
        Map<String,String> recordTypeMap = new Map<String,String>();
        String tipoRegistroCliente = '';        
        if(!String.isBlank(objectId) && !String.isEmpty(objectId)){            
            List<Account> clientes = [Select Id, Name, RecordType.Name from Account where Id =: objectId];
            if(clientes.size() > 0){
                tipoRegistroCliente = clientes.get(0).RecordType.Name;
            }      
        } 
        if(!String.isBlank(tipoRegistroCliente) ){                
            for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Opportunity' AND (Name =: tipoRegistroCliente OR DeveloperName =: 'Gestion_de_Cuentas')]) {
                recordTypeMap.put(rec.Id, rec.Name);                    
            }
        }else{
            for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Opportunity']) {
                if(!rec.Name.contains('Aporte')){                    
                    recordTypeMap.put(rec.Id, rec.Name);                
                }               
            }  
        } 
        
        return recordTypeMap;
    } 
    
    /*Método que obtiene el Id de un cliente dependiendo del tipo de id de objeto que ingresa como parámetro*/
    @AuraEnabled()
    public static String obtenerClienteId(Id objectId){
        String clienteId = '';
        if(!String.isBlank(objectId) && !String.isEmpty(objectId)){
            if(objectId.getSobjectType() == Account.sObjectType){
                clienteId = objectId;                
            }else if(objectId.getSobjectType() == Contact.sObjectType){
                List<Contact> contactos = [Select Id, AccountId from Contact where Id=: objectId];
                if(contactos.size() > 0){
                    clienteId = contactos.get(0).AccountId;
                }
            }
        }
        return clienteId;
    }
       
    
    
}