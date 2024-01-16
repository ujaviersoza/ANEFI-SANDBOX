global class ANEFI_Utilitarios {
    
    //Constantes para los tipos de persona
    public static final string PERSONA_NATURAL = 'Persona Natural';
    public static final string PERSONA_JURIDICA = 'Persona Jurídica';
    
    //Constantes para el tipo de accion en item Ocurrencia Listas negras de Gestor
    public static final string ACCION_BLOQUEAR = 'BLO';
    public static final string ACCION_ALERTAR = 'ALE';
    
    //Constantes para el tipo de notificación de error
    public static final string ERROR_GENERAL = 'GENERAL';
    public static final string ERROR_CONFLICTO = 'CONFLICTO';
    public static final string ERROR_INESPERADO = 'INESPERADO';
    
    //Constante para el nombre de la notificación personalizada
    public static final string NOTIFICACION_PERSONALIZADA_OPORTUNIDAD = 'Notificacion_sincronizando_oportunidad_en_Gestor';
    
    //Constante para el código cuenta contable de los productos CP-1 y FS-2
    public static final string CODIGO_CUENTA_CONTABLE = '3010501'; 
    
    //Constantes para los códigos de tipos de transacción en Gestor
    public static final string CODIGO_TRANSACCION_APORTE = 'IP';
    
    //Constantes para los tipos de transacción al consulta movimientos de cuentas de participe
    public static final string TRANSACCION_APORTE = 'aporte';
    public static final string TRNSACCION_RESCATE = 'rescate';
    
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;

    
    /*Método que retorna el nombre del tipo de registro*/
    public static String obtenerNombreTipoRegistro(String idAccount){
        Account acc = [Select Id, recordTypeId from account where id =:idAccount];
        String nombreTipoRegistro = '';
        
        List<RecordType> tiposRegistro = [Select Id, Name from RecordType where Id =: acc.recordTypeId];
        if(tiposRegistro.size() > 0){
            nombreTipoRegistro = tiposRegistro.get(0).Name;
        }
        
        return nombreTipoRegistro;
        
    }
    /**
     * Método que define si es un entorno de pruebas o de produccion
     */
    public static String pruebasOProduccion() {
        String endpoint='';
        Boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;

        if(runningInASandbox)   endpoint ='PRUEBAS';
        else    endpoint='PRODUCCION';

        return endpoint;
    }
    
    /**Método para enviar notificación electrónica con fallo de servicio de Gestor*/
    public static void enviarNotificacionFalloServicioGestor(String endpointServicioGestor, HttpResponse responseServicioGestor, Id relatedObjectId, String tipoDeError, String mensajeErrorInesperado){
        try{                                   
            List<String> cuentasCorreo = new List<String>();
            
            for(ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion : [Select Id, Nombre__c,Correo_electronico__c             
                                                                               From ANEFI_Usuario_notificacion_Gestor__c]){
                cuentasCorreo.add(usuarioNotificacion.Correo_electronico__c);
            }
            
            if(cuentasCorreo.size() > 0){                                
                String asuntoCorreo = '';
                String cuerpoCorreo = ''; 
                CorreoElectronicoDTO correoElectronicoDTO = new CorreoElectronicoDTO();
                if(relatedObjectId != null && relatedObjectId.getSobjectType() == Opportunity.sObjectType){//Se esta sincronizando una oportunidad en Gestor
                    correoElectronicoDTO = obtCorreoErrorSincronizandoOportunidad(endpointServicioGestor, responseServicioGestor, relatedObjectId, tipoDeError, mensajeErrorInesperado);                    
                }
                else if(relatedObjectId != null && relatedObjectId.getSobjectType() == Account.sObjectType){ //Se esta consultando información de un participe asociado a un cliente
                   correoElectronicoDTO = obtCorreoErrorConsultandoClienteEnGestor(endpointServicioGestor, responseServicioGestor, relatedObjectId, tipoDeError, mensajeErrorInesperado);                   
                }else{//Se esta consumiendo un servicio General a todos los partícipes
                    correoElectronicoDTO = obtCorreoErrorServicioGeneralGestor(endpointServicioGestor, responseServicioGestor, tipoDeError, mensajeErrorInesperado);
                }  
                
                asuntoCorreo = correoElectronicoDTO.asunto;
                cuerpoCorreo = correoElectronicoDTO.cuerpo;                    
                if(correoElectronicoDTO.emailPropietarioRegistro != null){
                    cuentasCorreo.add(correoElectronicoDTO.emailPropietarioRegistro);
                }                
                enviarNotificacionGeneral(asuntoCorreo, cuerpoCorreo, cuentasCorreo);
            }
            
        }
        catch(Exception e){
            system.debug('Error enviando notificación de error de servicio en Gestor');
        }      
    } 
    
    /*Método general para enviar notificaciones con el estilo del membrete de ANEFI*/
    public static void enviarNotificacionGeneral(String asunto, String cuerpo, List<String> cuentasCorreo){
        try{
            if(cuentasCorreo.size() > 0){
                String rutaImagen = '';
                Organization organizacion = [select id, name from Organization limit 1];
                OrgWideEmailAddress orgEmailAddressGeneral = null; 
                List<OrgWideEmailAddress> orgEmailAddress = [select Id from OrgWideEmailAddress
                                                             where DisplayName  = 'Administrador ANEFI'];
                if(orgEmailAddress.size() > 0){
                    orgEmailAddressGeneral = orgEmailAddress.get(0);
                } 
                
                List<ANEFI_Parametros_Generales__c> parametrosGenerales = [Select Id, Ruta_publica_logo_Anefi__c 
                                                                        from ANEFI_Parametros_Generales__c];
                if(parametrosGenerales.size() > 0){
                   rutaImagen = parametrosGenerales.get(0).Ruta_publica_logo_Anefi__c;
                }                
                
                String cuerpoCompleto = '<div><center>';
                cuerpoCompleto += '<div style="background-color:#FFFFFF; vertical-align:top; height:100px; text-align:left">';
                cuerpoCompleto += '<img src="' + rutaImagen +'"/>';
                cuerpoCompleto += '</div>';
                cuerpoCompleto += '<div style="background-color:#00bfa3; height:5px"></div>';
                cuerpoCompleto += '<div style="background-color:#FFFFFF; color:#000000; font-size:12pt; font-family:arial;text-align:left;">';
                cuerpoCompleto += cuerpo;
                cuerpoCompleto +=  '<br /><br />';
            	cuerpoCompleto += 'Saludos.<br /><br />';
            	cuerpoCompleto += organizacion.name;
                cuerpoCompleto += '</div><br />';
                cuerpoCompleto += '<div style="background-color:#00bfa3; height:5px"></div>';
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               	List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
                email.setSubject(asunto);             
               	email.setHtmlBody(cuerpoCompleto);
                if(orgEmailAddressGeneral != null){
                	email.setOrgWideEmailAddressId(orgEmailAddressGeneral.Id);        
                }
                email.setToAddresses(cuentasCorreo); 
                emails.add(email);                
                Messaging.SendEmailResult[] res = Messaging.sendEmail(emails);         
            }
        }
        catch(Exception e){
            system.debug('Error enviando notificación general');
        }
    }
    
    //Método para retornar el correo electronico de error sincronizando oportunidades
    public static CorreoElectronicoDTO obtCorreoErrorSincronizandoOportunidad(String endpointServicioGestor, HttpResponse responseServicioGestor, Id oportunidadId, String tipoDeError, String mensajeErrorInesperado){
        CorreoElectronicoDTO correoElectronicoDTO = new CorreoElectronicoDTO();
        String indicacionesCorreo = '';
        
        List<Opportunity> oportunidades = [Select Name, Owner.Email from opportunity where Id =: oportunidadId ];
        if(oportunidades.size() > 0){
            Opportunity oportunidad = oportunidades.get(0);
            correoElectronicoDTO.asunto = 'Notificación de error sincronizando la oportunidad ' + oportunidades.get(0).Name + ' en Gestor';
           
            if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_INESPERADO)){
                indicacionesCorreo = 'Por favor comuniquese con el administrador del sistema para resolver los errores antes de ' + 
                'iniciar la sincronización manual de la oportunidad.';
            }
            else{
                indicacionesCorreo = 'Por favor ajuste la información en la oportunidad y cliente asociado para superar las ' +
                    'validaciones de negocio al sincronizar la oportunidad manualmente.';
            }
            
            if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_CONFLICTO)){
                correoElectronicoDTO.cuerpo = '<p>La oportunidad ' + oportunidad.Name + ' no se sincronizó en Gestor debido a que se presentó el siguiente error ' + 
                    'al consumir el servicio: ' + endpointServicioGestor + 
                    '<br/><br/>' + 'Código de error: ' + responseServicioGestor.getStatusCode() + '<br/>' +
                    'Tipo de error: ' + responseServicioGestor.getStatus() + '<br/>' +
                    'Detalles del error: ' + responseServicioGestor.getBody() + '<br/><br/>' +                
                    indicacionesCorreo +
                    '</p>';
            }
            else{
                correoElectronicoDTO.cuerpo = '<p>La oportunidad ' + oportunidad.Name + ' no se sincronizó en Gestor debido a que se presentó el siguiente error inesperado ' + 
                    mensajeErrorInesperado +  '<br/><br/>' +                
                    indicacionesCorreo +
                    '</p>';
            }
            if(oportunidades.get(0).Owner.Email != null){
                correoElectronicoDTO.emailPropietarioRegistro = oportunidad.Owner.Email;
            }
        }
        return correoElectronicoDTO;
    }
    
    //Método para retornar el correo electronico de error consultando información de cliente en Gestor
    public static CorreoElectronicoDTO obtCorreoErrorConsultandoClienteEnGestor(String endpointServicioGestor, HttpResponse responseServicioGestor, Id clienteId, String tipoDeError, String mensajeErrorInesperado){
        CorreoElectronicoDTO correoElectronicoDTO = new CorreoElectronicoDTO();
        String indicacionesCorreo = '';
        List<Account> clientes = [Select Name, Owner.Email from Account where Id =: clienteId ];
        if(clientes.size() > 0){
            Account cliente = clientes.get(0);
            correoElectronicoDTO.asunto = 'Notificación de error consultando cliente ' + cliente.Name + ' en Gestor';
           
            if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_INESPERADO)){
                indicacionesCorreo = 'Por favor comuniquese con el administrador del sistema para resolver los errores antes de ' + 
                'consultar nuevamente la información del cliente en Gestor.';
            }
            else{
                indicacionesCorreo = 'Por favor ajuste la información del cliente para superar las ' +
                    'validaciones de negocio al consultar/actualizar el participe asociado en Gestor.';
            }
            
            if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_CONFLICTO)){
                correoElectronicoDTO.cuerpo = '<p>No se pudo consultar/actualizar la información del cliente ' + cliente.Name + ' en Gestor debido a que se presentó el siguiente error ' + 
                    'al consumir el servicio: ' + endpointServicioGestor + 
                    '<br/><br/>' + 'Código de error: ' + responseServicioGestor.getStatusCode() + '<br/>' +
                    'Tipo de error: ' + responseServicioGestor.getStatus() + '<br/>' +
                    'Detalles del error: ' + responseServicioGestor.getBody() + '<br/><br/>' +                
                    indicacionesCorreo +
                    '</p>';
            }
            else{
                correoElectronicoDTO.cuerpo = '<p>No se pudo consultar/actualizar la información del cliente ' + cliente.Name + ' en Gestor debido a que se presentó el siguiente error inesperado ' + 
                    mensajeErrorInesperado +  '<br/><br/>' +                
                    indicacionesCorreo +
                    '</p>';
            }
            if(cliente.Owner.Email != null){
                correoElectronicoDTO.emailPropietarioRegistro = cliente.Owner.Email;
            }
        }
        return correoElectronicoDTO;
    }
    
    //Método para retornar el correo electronico de error consumiendo un servicio general a los partícipes en Gestor
    public static CorreoElectronicoDTO obtCorreoErrorServicioGeneralGestor(String endpointServicioGestor, HttpResponse responseServicioGestor, String tipoDeError, String mensajeErrorInesperado){
        CorreoElectronicoDTO correoElectronicoDTO = new CorreoElectronicoDTO();
        String indicacionesCorreo = '';
        
        correoElectronicoDTO.asunto = 'Notificación de error consumiendo servicio de Gestor';
        
        if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_INESPERADO)){
            indicacionesCorreo = 'Por favor comuniquese con el administrador del sistema para resolver los errores antes de ' + 
                'consultar nuevamente la información en Gestor.';
        }
        else{
            indicacionesCorreo = 'Por favor ajuste la información necesaria para superar las ' +
                'validaciones de negocio al consumir el servicio en Gestor.';
        }
        
        if(tipoDeError.equals(ERROR_GENERAL) || tipoDeError.equals(ERROR_CONFLICTO)){
            correoElectronicoDTO.cuerpo = '<p>No se pudo consumir el servicio de Gestor debido a que se presentó el siguiente error: ' + 
                + endpointServicioGestor + 
                '<br/><br/>' + 'Código de error: ' + responseServicioGestor.getStatusCode() + '<br/>' +
                'Tipo de error: ' + responseServicioGestor.getStatus() + '<br/>' +
                'Detalles del error: ' + responseServicioGestor.getBody() + '<br/><br/>' +                
                indicacionesCorreo +
                '</p>';
        }
        else{
            correoElectronicoDTO.cuerpo = '<p>No se pudo consumir el servicio de Gestor debido a que se presentó el siguiente error inesperado ' + 
                mensajeErrorInesperado +  '<br/><br/>' +                
                indicacionesCorreo +
                '</p>';
        }
        
        correoElectronicoDTO.emailPropietarioRegistro = UserInfo.getUserEmail();
        
        return correoElectronicoDTO;
    }
    
    //Método para obtener el map de headers que son comunes a todos los servicios de Gestor
    public static ANEFI_Configuracion_Gestor_Web__c obtenerConfiguracionGestorWeb(){
    	ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb = null;
        String TARGET_ORG = pruebasOProduccion();
        List<ANEFI_Configuracion_Gestor_Web__c> configuracionesGestorWeb = [Select Id, URL__c, Gestor_Token_App__c, 
                                                                            Gestor_Token_Env__c,Usuario__c, Clave__c   
                                                                     from ANEFI_Configuracion_Gestor_Web__c 
                                                                     where Instancia__c =: TARGET_ORG];
        
        if(configuracionesGestorWeb.size() > 0){
            configuracionGestorWeb = configuracionesGestorWeb.get(0);
        }
        system.debug(configuracionGestorWeb);
     	return configuracionGestorWeb;
    }    
    
    
    /*Método para enviar notificación de persona reportada en listas negras de Gestor*/
    public static void enviarNotificacionPersonaEnListasNegrasDeGestor(ANEFI_ServicesDTO.Oportunidad oportunidadDTO, ANEFI_servicesDTO.ListasNegrasOut listasNegrasOut, String nombreCliente, String numeroIdentificacion){
        try{                                   
            List<String> cuentasCorreo = new List<String>();
            User propietarioOportunidad = new User();
            
            for(ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion : [Select Id, Nombre__c,Correo_electronico__c             
                                                                               From ANEFI_Usuario_notificacion_Gestor__c]){
                cuentasCorreo.add(usuarioNotificacion.Correo_electronico__c);
            }
            
            List<User> usuarios = [Select Id, email, Name from User Where Id =: oportunidadDTO.propietarioId];
            if(usuarios.size() > 0){
                propietarioOportunidad = usuarios.get(0);
                cuentasCorreo.add(propietarioOportunidad.email);
            }            
            
            if(cuentasCorreo.size() > 0){                
                String asuntoCorreo = 'Notificación persona reportada en listas negras de Gestor';
                String cuerpoCorreo = '';
                
                cuerpoCorreo = '<p>La oportunidad ' + oportunidadDTO.oportunidadNombre + 
                    			' no se sincronizó en Gestor ya que el cliente asociado' +
                    			' con número de identificación ' + numeroIdentificacion +
                    			' se encuentra reportado en las listas negras de Gestor.' +
                    			'<br/><br/>' + 'Información de listas negras en las que se encuentra el cliente: <br/><br/>' + JSON.serialize(listasNegrasOut) + '<br/><br/>' +
                    			'Para iniciar la sincronización manual de la oportunidad en Gestor, el cliente debe ser desbloqueado ' + 
                    			' de las listas negras de Gestor.' + '<br/>' +'</p>';
                
                enviarNotificacionGeneral(asuntoCorreo, cuerpoCorreo, cuentasCorreo);                       
            }            
        }
        catch(Exception e){
            system.debug('Error enviando notificación de error de servicio en Gestor');
        }       
    } 
    
    //Método para validar la respuesta retornada por el servicio de validación de listas negras de Gestor
    public static Boolean existePersonaEnListasNegrasDeGestor(ANEFI_ServicesDTO.Oportunidad oportunidadDTO, ANEFI_ServicesDTO.ListasNegrasOut listasNegrasOUTDTO, String nombreCliente, String numeroIdentificacion){
        Boolean estaPersonaEnListasNegras = listasNegrasOUTDTO.personaReportada;
        if(!estaPersonaEnListasNegras){
            return estaPersonaEnListasNegras;
        }
        else{
            estaPersonaEnListasNegras = false;
            for(ANEFI_ServicesDTO.ItemOcurrenciaPersonaListaNegra itemOcurrenciaPersonaListaNegra : listasNegrasOUTDTO.ocurrencias){
                if(itemOcurrenciaPersonaListaNegra.accion.equals(ANEFI_Utilitarios.ACCION_BLOQUEAR)){
                    estaPersonaEnListasNegras = true;
                    break;
                }
            }
            if(!estaPersonaEnListasNegras){
                return estaPersonaEnListasNegras;
            }
            else{
                try{
                    enviarNotificacionPersonaEnListasNegrasDeGestor(oportunidadDTO, listasNegrasOUTDTO, nombreCliente, numeroIdentificacion);
                    return estaPersonaEnListasNegras;
                }
                catch(Exception e){
                    system.debug('Error enviando notificación persona en listas negras de Gestor');
                }                
            }            
        }        
        return estaPersonaEnListasNegras;
    }     
    
    /*Método para actualizar el estado de sincronización de la oportunidad en Gestor*/
    public static void actualizarEstadoSincronizacionOportunidad(String oportunidadId, ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad){
       	
        System.debug('respuestaSincronizacionOportunidad ->' + respuestaSincronizacionOportunidad);
        Boolean enviarCorreoSincronizacionExitosa = false;
        List<SObject> registrosActualizar = new List<SObject>();
        List<Opportunity> oportunidades = [Select Id,Name,Estado_sincronizacion_Gestor__c, Sincronizado_en_Gestor__c,
                                          AccountId, OwnerId, Amount,Producto_de_Interes__c,Oportunidad_es_Aporte__c
                                          from opportunity where Id =: oportunidadId];
        if(oportunidades.size() > 0){            
            Opportunity oportunidad = oportunidades.get(0);
            if(respuestaSincronizacionOportunidad.errorEnSincronizacion){
            	oportunidad.Estado_sincronizacion_Gestor__c = 'ERROR SINCRONIZACIÓN';
            	oportunidad.Sincronizado_en_Gestor__c = false;
            }
            else{
                oportunidad.Estado_sincronizacion_Gestor__c = 'SINCRONIZADO OK';
            	oportunidad.Sincronizado_en_Gestor__c = true;                
                enviarCorreoSincronizacionExitosa = true;
                if(oportunidad.Oportunidad_es_Aporte__c){
                    ANEFI_OpportunityHelper.createLicitudFondosFile(oportunidades);
                }
                
            }
            
            if(!String.isBlank(respuestaSincronizacionOportunidad.numeroCuentaParticipe) && !String.isEmpty(respuestaSincronizacionOportunidad.numeroCuentaParticipe) ){
                oportunidad.Numero_cuenta_de_participe__c = respuestaSincronizacionOportunidad.numeroCuentaParticipe;
            }
            
            if(!String.isBlank(respuestaSincronizacionOportunidad.numeroTransaccionAporte) && !String.isEmpty(respuestaSincronizacionOportunidad.numeroTransaccionAporte) ){
               oportunidad.Numero_transaccion_aporte_en_gestor__c = respuestaSincronizacionOportunidad.numeroTransaccionAporte;
            }            
            
            oportunidad.Fecha_de_sincronizacion_en_Gestor__c = System.today();
            oportunidad.Bloqueado_en_listas_negras_de_Gestor__c = respuestaSincronizacionOportunidad.personaBloqueadaEnListasNegras;
            
            registrosActualizar.add(oportunidad);
            
            List<Account> clientes = [Select Id, Codigo_persona_en_Gestor__c from Account where Id =: oportunidad.AccountId ];
            if(clientes.size() > 0  && clientes.get(0).Codigo_persona_en_Gestor__c == null){
                Account cliente = clientes.get(0);
                cliente.Codigo_persona_en_Gestor__c = respuestaSincronizacionOportunidad.codigoPersonaEnGestor != null ? String.valueOf(respuestaSincronizacionOportunidad.codigoPersonaEnGestor) : null;                
                registrosActualizar.add(cliente);
            }          
                
            update registrosActualizar;
            
            if(enviarCorreoSincronizacionExitosa){
                enviarNotificacionSincronizacionExitosaOportunidad(oportunidad.Name, oportunidad.OwnerId, oportunidad.Amount, oportunidad.Producto_de_Interes__c, respuestaSincronizacionOportunidad);
            }
        }        
    }
    
    public static void crearNotificacionSincronizacionOportunidad(ANEFI_ServicesDTO.Oportunidad oportunidadDTO, String titulo, String mensaje)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        try{
            List<CustomNotificationType> notificacionesPersonalizadas = [Select Id,DeveloperName from CustomNotificationType
                                                                    where DeveloperName =: NOTIFICACION_PERSONALIZADA_OPORTUNIDAD];
            if(notificacionesPersonalizadas.size() > 0){
                req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                + '/services/data/v46.0/actions/standard/customNotificationAction');
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                req.setHeader('Content-Type', 'application/json');
                ANEFI_ServicesDTO.CustomNotificationActionInput input = new ANEFI_ServicesDTO.CustomNotificationActionInput();
                input.customNotifTypeId = notificacionesPersonalizadas.get(0).Id;
                input.recipientIds = new List<String>{oportunidadDTO.propietarioId};
                input.title = titulo;
                input.body = mensaje;
                input.targetId = oportunidadDTO.oportunidadId;
                ANEFI_ServicesDTO.CustomNotificationAction action = new ANEFI_ServicesDTO.CustomNotificationAction();
                action.inputs = new List<ANEFI_ServicesDTO.CustomNotificationActionInput>{input};
                req.setBody(JSON.serialize(action));
                HttpResponse res = http.send(req);				               
            }      
        }
        catch(Exception e){
            system.debug('Error creando notificación personalizada de sincronización de oportunidad');
        }        
    }
    
    /*Método para obtener de la configuración personalizada API Name la URL del servicio dado*/
    public static String obtenerURLServicioPorNombre(String nombreServicio){
        String URLServicio = '';
        List<ANEFI_API_Name__c> APINames = [Select Id, Name, URL_Name__c from ANEFI_API_Name__c where Name =: nombreServicio];
        if(APINames.size() > 0)
        {
            URLServicio = APINames.get(0).URL_Name__c;
        }
        return URLServicio;
    }
    
    /*Método para enviar notificación de sincronización de oportunidad finalizada correctamente*/
    public static void enviarNotificacionSincronizacionExitosaOportunidad(String nombreOportunidad, String idPropietario, Decimal monto, String productoInteres, ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad respuestaSincronizacionOportunidad){
        try{                                   
            List<String> cuentasCorreo = new List<String>();
            User propietarioOportunidad = new User();
            String etiquetaProductoInteres = '';
            
            for(ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion : [Select Id, Nombre__c,Correo_electronico__c             
                                                                               From ANEFI_Usuario_notificacion_Gestor__c]){
                cuentasCorreo.add(usuarioNotificacion.Correo_electronico__c);
            }
            
            //Se obtiene la etiqueta del producto de interés
            List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.Opportunity.fields.Producto_de_Interes__c.getPicklistValues();
            for(Schema.PicklistEntry ple :picklistEntries){
                if(ple.getValue() == productoInteres){
                    etiquetaProductoInteres = ple.getLabel();
                }
            }
            
            List<User> usuarios = [Select Id, email, Name from User Where Id =: idPropietario];
            if(usuarios.size() > 0){
                propietarioOportunidad = usuarios.get(0);
                cuentasCorreo.add(propietarioOportunidad.email);
            }            
            
            if(cuentasCorreo.size() > 0){                
                String asuntoCorreo = 'Notificación sincronización de oportunidad ' + nombreOportunidad + ' en Gestor';
                String cuerpoCorreo = '';
                
                cuerpoCorreo = '<p>La oportunidad ' + nombreOportunidad + 
                    			' se sincronizó correctamente en Gestor con los siguientes datos: <br/><br/>' +
                    			'Código persona en Gestor: ' + respuestaSincronizacionOportunidad.codigoPersonaEnGestor + '<br/>' +
                    			'Número de cuenta participe: ' + respuestaSincronizacionOportunidad.numeroCuentaParticipe + '<br/>' +
                    			'Número de transacción aporte: ' + respuestaSincronizacionOportunidad.numeroTransaccionAporte + '<br/>' +
                    			'Fondo: ' + etiquetaProductoInteres + '<br/>' +
                    			'Monto: $' + monto + '<br/>' +
                                '<br/><br/>' +
                    			'</p>';
                
                enviarNotificacionGeneral(asuntoCorreo, cuerpoCorreo, cuentasCorreo);                       
            }            
        }
        catch(Exception e){
            system.debug('Error enviando notificación de error de servicio en Gestor');
        }       
    }
    
    /*Método para obtener los headers generales de los servicios de ANEFI*/
    public static Map<String,String> obtenerHeadersGenerales(ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb, ANEFI_ServicesDTO.LoginOUT loginOUTDTO){
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type','application/json');
        headers.put('Gestor-Token-App',configuracionGestorWeb.Gestor_Token_App__c);
        headers.put('Gestor-Token-Env',configuracionGestorWeb.Gestor_Token_Env__c);
        headers.put('Authorization', 'Bearer ' + loginOUTDTO.accessToken);
        return headers;
    }
    
    /**
     * Método que envía petición de autenticación de Login a GESTOR
     */
    public static ANEFI_ServicesDTO.LoginOUT autenticarEnGestor(ANEFI_RequestsHandler requestHandler, Id relatedObjectId, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb){
        ANEFI_ServicesDTO.LoginOUT loginOUT = null;    
        Map<String,String> headers = new Map<String, String>();        
        if(configuracionGestorWeb != null){
            String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('login');        
            if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                String endpoint = configuracionGestorWeb.URL__c + URLServicio;        
                headers.put('Content-Type','application/json');
                headers.put('Gestor-Token-App',configuracionGestorWeb.Gestor_Token_App__c);
                headers.put('Gestor-Token-Env',configuracionGestorWeb.Gestor_Token_Env__c);
                ANEFI_ServicesDTO.LoginInput loginInputDTO = new ANEFI_ServicesDTO.LoginInput();
                loginInputDTO.usuario = configuracionGestorWeb.Usuario__c;
                loginInputDTO.clave =  configuracionGestorWeb.Clave__c;
                ANEFI_PostRequestData postRequestData = new ANEFI_PostRequestData(loginInputDTO);
                String body = JSON.serialize(postRequestData);             
                HttpResponse response = null;      
                ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
                try {
                    system.debug('body: '+body);
                    requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null,relatedObjectId);                    
                    response = requestHandlerResponse.response;
                } catch (Exception e) {
                    system.debug('No se pudo realizar la petición: '+e.getMessage());                    
                }                
                String responseBody = response != null ? response.getBody() : null;                
                Integer responseStatusCode = response != null ? response.getStatusCode() : 0;        
                if(responseStatusCode != 201){
                    return loginOUT;            
                }
                else{
                    ANEFI_ServicesDTO.ResponseDataLoginOut responseDataLoginOut = (ANEFI_ServicesDTO.ResponseDataLoginOut)JSON.deserialize(responseBody, ANEFI_ServicesDTO.ResponseDataLoginOut.class);            
                    loginOUT = responseDataLoginOut.data;     
                    return loginOUT;
                }
            }          
        }
        return loginOUT;
    }


    
    /**
     * Método que envía petición de validación de persona en registros de clientes de Gestor
     */
    public static ANEFI_ServicesDTO.RegistroClienteOut validarEnRegistrosDeClientes(ANEFI_RequestsHandler requestHandler, String clienteId, String relatedObjectId, ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb){
        ANEFI_ServicesDTO.RegistroClienteOut registroClienteOutDTO = null;        
        String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('validacionRegistrosCliente');        
        if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
            ANEFI_PostRequestData postRequestData = null;
            ANEFI_ServicesDTO.RegistroClienteInput registroClienteInput = ANEFI_SerializadorService.obtInputValidacionRegistroCliente(clienteId);
            postRequestData = new ANEFI_PostRequestData(registroClienteInput);            
            String body = JSON.serialize(postRequestData);
            ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
            HttpResponse response = null;
            
            try {
                requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null,relatedObjectId); 
                response = requestHandlerResponse.response; 
                
            } catch (Exception e) {
                system.debug('No se pudo realizar la petición: ' + e.getMessage());
            }
            
            String responseBody = response != null ? response.getBody() : null;     
            Integer responseStatusCode = response != null ? response.getStatusCode() : null;   
            if(responseStatusCode == 200){   
                if(requestHandlerResponse.loginOUT != null){
                    loginOUTDTO = requestHandlerResponse.loginOUT;
                }
                ANEFI_ServicesDTO.ResponseDataRegistroClienteOut responseDataRegistroClienteOUT = (ANEFI_ServicesDTO.ResponseDataRegistroClienteOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataRegistroClienteOut.class);
                registroClienteOutDTO = responseDataRegistroClienteOUT.data;         
            }
        }
        
        return registroClienteOutDTO;
        
               
    }
    
   
    /*Método que envía petición de actualización de persona en Gestor*/
    public static String actualizarPersonaEnGestor(ANEFI_RequestsHandler requestHandler, String clienteId, String codigoPersonaGestor, String relatedObjectId, ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb){
        String URLServicio = ''; 
        Account clienteAActualizar = null;
        List<Account> clientes = [Select Id, recordType.Name from Account where Id =: clienteId];
        if(clientes.size() >0 ){
            clienteAActualizar = clientes.get(0);            
            if(clienteAActualizar.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
                URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaJuridica');
            }
            else{
                URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('actualizarPersonaNatural');  
            }    
           
            
            if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                URLServicio = URLServicio.replace('{codigoPersona}', codigoPersonaGestor);
                String endpoint = configuracionGestorWeb.URL__c + URLServicio;                
                Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);
                ANEFI_PostRequestData postRequestData = null;
                if(clienteAActualizar.recordType.Name.equals(ANEFI_Utilitarios.PERSONA_JURIDICA)){
                    ANEFI_ServicesDTO.ActualizarPersonaJuridicaInput actualizarPersonaJuridicaInput = ANEFI_SerializadorService.obtInputActualizacionPersonaJuridica(clienteId);
                    postRequestData = new ANEFI_PostRequestData(actualizarPersonaJuridicaInput);
                }
                else{
                    ANEFI_ServicesDTO.ActualizarPersonaNaturalInput actualizarPersonaNaturalInput = ANEFI_SerializadorService.obtInputActualizacionPersonaNatural(clienteId);      
                    postRequestData = new ANEFI_PostRequestData(actualizarPersonaNaturalInput);
                    
                }
                String body = JSON.serialize(postRequestData, true);                
                ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
                HttpResponse response = null;
                
                try {                    
                    requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'PUT',null, relatedObjectId); 
                    response = requestHandlerResponse.response;                    
                } catch (Exception e) {
                    system.debug('No se pudo realizar la petición de actualización de persona en Gestor: ' + e.getMessage());            
                }
                
                String responseBody = response.getBody();        
                Integer responseStatusCode = response.getStatusCode();                
                if(responseStatusCode == 204){
                    if(requestHandlerResponse.loginOUT != null){
                        loginOUTDTO = requestHandlerResponse.loginOUT;
                    }                
                    return String.valueOf(responseStatusCode);
                }else{
                    return null;
                }
            } 
        }          
		return null;
    }
    
    public static void actualizarReferenciaBancariaDeCliente(String clienteId, String idEntidadFinanciera, String tipoCuentaBancaria, String numeroCuentaBancaria){
        try{
            List<Account> clientes = [Select Id, Entidad_financiera__c, Tipo_de_cuenta_bancaria__c, Numero_de_cuenta_bancaria__c from Account
                                     Where Id =: clienteId];
            if(clientes.size() > 0){
                Account cliente = clientes.get(0);
                cliente.Entidad_financiera__c = idEntidadFinanciera;
                cliente.Tipo_de_cuenta_bancaria__c = tipoCuentaBancaria;
                cliente.Numero_de_cuenta_bancaria__c = numeroCuentaBancaria;
                update cliente;
            }
        }
        catch(Exception e){
            
        }
    }
    
        /**
     * Método que envía petición de creación de creación de aporte en Gestor y retorna el número de transacción 
     * en caso de que se cree exitosamente
     */
    public static ANEFI_ServicesDTO.RegistroAporteOut crearRegistroAporteEnGestor(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb, ANEFI_RequestsHandler requestHandler, ANEFI_ServicesDTO.Oportunidad oportunidadDTO){
        String URLServicio = ''; 
        ANEFI_ServicesDTO.ResponseDataRegistroAporteOut responseDataRegistroAporteOut = null;
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroAporte');        
        if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
            URLServicio = URLServicio.replace('{codigoEmpresa}', '1').
            			replace('{codigoProducto}', oportunidadDTO.codigoProducto).
            			replace('{codigoCliente}', String.valueOf(oportunidadDTO.codigoPersonaEnGestor)).
            			replace('{numeroCuenta}', oportunidadDTO.numeroCuentaParticipe);
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);        
            ANEFI_PostRequestData postRequestData = new ANEFI_PostRequestData(ANEFI_SerializadorService.obtInputRegistroAporte(oportunidadDTO));        
            
            String body = JSON.serialize(postRequestData);
            ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
            HttpResponse response = null;
            
            try {
                requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, 'POST',null, oportunidadDTO.oportunidadId); 
                response = requestHandlerResponse.response;
                
            } catch (Exception e) {
                system.debug('No se pudo realizar la petición: ' + e.getMessage());
            }
            
            String responseBody = response.getBody();        
            Integer responseStatusCode = response.getStatusCode();   
            if(responseStatusCode == 201){
                if(requestHandlerResponse.loginOUT != null){
                    loginOUTDTO = requestHandlerResponse.loginOUT;
                }
                responseDataRegistroAporteOut = (ANEFI_ServicesDTO.ResponseDataRegistroAporteOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataRegistroAporteOut.class);
                return responseDataRegistroAporteOut.data;
            }
        }        
        return null;        
    }
    
    /*Método para realizar la consulta de saldos de cuenta de participe*/
    public static ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut consultaSaldosCuentaParticipe(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb,String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput, ANEFI_RequestsHandler requestHandler ){
        ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut responseDataSaldosParticipeOut = null;     
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null; 
        HttpResponse response = null;
        try{
            if(movimientosCuentaParticipeInput != null && !String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
              && !String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) && 
               !String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) && !String.isBlank(movimientosCuentaParticipeInput.codigoCliente)){
                String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaSaldosParticipe');      
                   if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                       URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto).
                            replace('{codigoCliente}', movimientosCuentaParticipeInput.codigoCliente);
                        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
                        Map<String,String> URLParams = new Map<String, String>();           
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
                            URLParams.put('fechaCorte',movimientosCuentaParticipeInput.fechaHasta);
                        }
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.numeroCuenta) && !String.isEmpty(movimientosCuentaParticipeInput.numeroCuenta)){
                            URLParams.put('numeroCuenta',movimientosCuentaParticipeInput.numeroCuenta);
                        }
                        
                        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);                 
                        try {            
                            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
                            response = requestHandlerResponse.response;       
                        } catch (Exception e) {
                            system.debug('No se pudo realizar la petición: ' + e.getMessage());
                        }
                        String responseBody = response.getBody();      
                        Integer responseStatusCode = response.getStatusCode();  
                        if(responseStatusCode == 200){
                            if(requestHandlerResponse.loginOUT != null){
                                loginOUTDTO = requestHandlerResponse.loginOUT;
                            }
                            responseDataSaldosParticipeOut = (ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.ResponseDataSaldosParticipeOut.class);                                               
                        }                           
                    }               
               }         
          }  
          catch(Exception e){
              system.debug('Error consultando los saldos de cuenta de participe: ' + e.getMessage());
          } 
          return responseDataSaldosParticipeOut;     
    }
    
    /*Método para realizar la consulta de los movimientos de una cuenta de participe*/
    public static ANEFI_ServicesDTO.MovimientosCuentaParticipeOut consultaMovimientosDeCuentaParticipe(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb,String clienteId, ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput, ANEFI_RequestsHandler requestHandler){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = null;
        HttpResponse response = null;
        try{
            if(movimientosCuentaParticipeInput != null && !String.isBlank(movimientosCuentaParticipeInput.codigoProducto)
              && !String.isEmpty(movimientosCuentaParticipeInput.codigoProducto) && 
               !String.isEmpty(movimientosCuentaParticipeInput.codigoCliente) && !String.isBlank(movimientosCuentaParticipeInput.codigoCliente)){
            	String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaMovimientosParticipe');      
                   if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                   		URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', movimientosCuentaParticipeInput.codigoProducto).
                            replace('{codigoCliente}', movimientosCuentaParticipeInput.codigoCliente);
                        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
                        Map<String,String> URLParams = new Map<String, String>();
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.fechaDesde) && !String.isEmpty(movimientosCuentaParticipeInput.fechaDesde)){
                            URLParams.put('fechaDesde',movimientosCuentaParticipeInput.fechaDesde);
                        }
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.fechaHasta) && !String.isEmpty(movimientosCuentaParticipeInput.fechaHasta)){
                            URLParams.put('fechaHasta',movimientosCuentaParticipeInput.fechaHasta);
                        }
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.numeroCuenta) && !String.isEmpty(movimientosCuentaParticipeInput.numeroCuenta)){
                            URLParams.put('numeroCuenta',movimientosCuentaParticipeInput.numeroCuenta);
                        }  
                        
                        URLParams.put('page[number]', String.valueOf(movimientosCuentaParticipeInput.pageNumber));
                        URLParams.put('page[size]',  String.valueOf(movimientosCuentaParticipeInput.pageSize));
                        
                        if(!String.isBlank(movimientosCuentaParticipeInput.tipoTransaccion) && !String.isEmpty(movimientosCuentaParticipeInput.tipoTransaccion)){
                            URLParams.put('tipoTransaccion',movimientosCuentaParticipeInput.tipoTransaccion);
                        }
                       
                        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);    
                        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;           
                        try {            
                            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, clienteId); 
                            response = requestHandlerResponse.response;       
                        } catch (Exception e) {
                            system.debug('No se pudo realizar la petición: ' + e.getMessage());
                        }
                        String responseBody = response.getBody();      
                        Integer responseStatusCode = response.getStatusCode();   
                        if(responseStatusCode == 200){
                            if(requestHandlerResponse.loginOUT != null){
                                loginOUTDTO = requestHandlerResponse.loginOUT;
                            }
                            movimientosCuentaParticipeOut = (ANEFI_ServicesDTO.MovimientosCuentaParticipeOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.MovimientosCuentaParticipeOut.class);                                   
                        }      
                   }                 
               }                   
        }
        catch(Exception e){
       		system.debug('Error consultando los movimientos de cuenta de participe: ' + e.getMessage());
        }
        
        return movimientosCuentaParticipeOut;
    }

	/*Método para realizar la consulta de los saldos de cuentas de participe para un producto*/
    public static ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut consultaSaldosCuentasDeParticipePorProducto(ANEFI_ServicesDTO.LoginOUT loginOUTDTO, ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb,ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosCuentasParticipeInput, ANEFI_RequestsHandler requestHandler){
        ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut saldosCuentasParticipePorProductoOut = null;
        HttpResponse response = null;        
        try{
            if(saldosCuentasParticipeInput != null && !String.isBlank(saldosCuentasParticipeInput.codigoProducto)
              && !String.isEmpty(saldosCuentasParticipeInput.codigoProducto)){
            	String URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaSaldosCuentasParticipe');      
                   if(!String.isBlank(URLServicio) && !String.isEmpty(URLServicio)){
                   		URLServicio = URLServicio.replace('{codigoEmpresa}', '1').replace('{codigoProducto}', saldosCuentasParticipeInput.codigoProducto);
                        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
                        Map<String,String> URLParams = new Map<String, String>();
                        
                        if(!String.isBlank(saldosCuentasParticipeInput.fechaDesde) && !String.isEmpty(saldosCuentasParticipeInput.fechaDesde)){
                            URLParams.put('fechaDesde',saldosCuentasParticipeInput.fechaDesde);
                        }
                        
                        if(!String.isBlank(saldosCuentasParticipeInput.fechaHasta) && !String.isEmpty(saldosCuentasParticipeInput.fechaHasta)){
                            system.debug('fechaHasta: ' + saldosCuentasParticipeInput.fechaHasta);
                            URLParams.put('fechaHasta',saldosCuentasParticipeInput.fechaHasta);
                        }                    
                        
                        URLParams.put('page[number]', String.valueOf(saldosCuentasParticipeInput.pageNumber));
                        URLParams.put('page[size]',  String.valueOf(saldosCuentasParticipeInput.pageSize));                        
                       
                        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);    
                        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;           
                        try {            
                            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',URLParams, null); 
                            response = requestHandlerResponse.response;       
                        } catch (Exception e) {
                            system.debug('No se pudo realizar la petición: ' + e.getMessage());
                        }
                       	
                       if(response != null){                           
                           String responseBody = response.getBody();      
                            Integer responseStatusCode = response.getStatusCode();                           
                            if(responseStatusCode == 200){
                                if(requestHandlerResponse.loginOUT != null){
                                    loginOUTDTO = requestHandlerResponse.loginOUT;
                                }
                                saldosCuentasParticipePorProductoOut = (ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut)JSON.deserialize(responseBody,ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut.class);                                
                            }   
                       }
                           
                   }                 
               }                   
        }
        catch(Exception e){
       		system.debug('Error consultando los saldos de cuentas de partícipe: ' + e.getMessage());
        }
        
        return saldosCuentasParticipePorProductoOut;
    }    
    public class CorreoElectronicoDTO{
        public String asunto;
        public String cuerpo;
        public String emailPropietarioRegistro;
    }
    
    /*Método para enviar notificación de creación de rescate finalizada correctamente*/
    public static void enviarNotificacionRescateExitos( String nombreCuenta ,String monto, String codigoPersonaEnGestor, String numeroCuentaParticipe, String fondo){
        try{                                   
            List<String> cuentasCorreo = new List<String>();
            User propietarioRescate = new User();
            String etiquetaProductoInteres = '';
            
            for(ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion : [Select Id, Nombre__c,Correo_electronico__c             
                                                                               From ANEFI_Usuario_notificacion_Gestor__c]){
                cuentasCorreo.add(usuarioNotificacion.Correo_electronico__c);
            }
            
            List<User> usuarios = [Select Id, email, Name from User Where Profile.Name = 'System Administrator'];
            if(usuarios.size() > 0){
                propietarioRescate = usuarios.get(0);
                cuentasCorreo.add(propietarioRescate.email);
            }            
            
            if(cuentasCorreo.size() > 0){                
                String asuntoCorreo = 'Notificación rescate exitosa ' + nombreCuenta + ' en Gestor';
                String cuerpoCorreo = '';
                
                cuerpoCorreo = '<p>El rescate ' + nombreCuenta +
                    			' se creo correctamente en Gestor con los siguientes datos: <br/><br/>' +
                    			'Código persona en Gestor: ' +codigoPersonaEnGestor + '<br/>' +
                    			'Número de cuenta participe: ' + numeroCuentaParticipe + '<br/>' +
                    			//'Número de transacción rescate: ' + respuestaCreacionRescate.numeroTransaccionAporte + '<br/>' +
                    			'Producto: ' + fondo + '<br/>' +
                    			'Monto: $' + monto + '<br/>' +
                                '<br/><br/>' +
                    			'</p>';
                system.debug('envio correo rescate');
                enviarNotificacionGeneral(asuntoCorreo, cuerpoCorreo, cuentasCorreo);                       
            }            
        }
        catch(Exception e){
            system.debug('Error enviando notificación de error de creacion en Rescate');
        }       
    }

}