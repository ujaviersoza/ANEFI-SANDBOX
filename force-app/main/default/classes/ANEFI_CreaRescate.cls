global without sharing  class ANEFI_CreaRescate {
    public class GestionarParticipeGestorException extends Exception {}
    
    public static ANEFI_ServicesDTO.LoginOUT loginOUTDTO;
    public static ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb;
    @InvocableMethod()
    public static List<String> creaRescate(List<String> idRescateProgramado){
        List<String> respuesta = new List<String>();
        String respuestaRegistro='';
        system.debug('d'+idRescateProgramado);
        String recordId = idRescateProgramado[0];
        List<ANEFI_Rescates_Programados__c> rescateConsulta = new List<ANEFI_Rescates_Programados__c>();
        rescateConsulta = [Select id,Anefi_Agencia__c,Anefi_CodigoMoneda__c,Anefi_FormaDePago__c,Anefi_CodTipoTransaccion__c, Anefi_CuentaRescate__c ,Anefi_Codigo_Gestor_Participe__c, Anefi_Entidad_Financiera_Destino__c,Anefi_Entidad_Financiera_Producto__c,
                           Anefi_Estado_Rescate__c, Anefi_FechaEfectiva__c,ANEFI_ManejaExcepcion__c,Anefi_MontoRescate__c,Anefi_NumeroCuentaDestino__c
                           ,Anefi_Numero_Cuenta_Gestor__c ,Anefi_NumeroCuentaProducto__c ,Anefi_Producto_Rescate__c 
                           ,ANEFI_Tipo_de_Rescate__c,Anefi_Tipo_Entidad_Financiera_Destino__c,Anefi_Tipo_Entidad_Financiera_Producto__c,Anefi_Usuario_Envio_Rescate__c
                           ,ANEFI_Fecha_Envio_Rescate__c from ANEFI_Rescates_Programados__c where id =:recordId and Anefi_Estado_Rescate__c in ('Activo','Evento Creado','Con Error')];
        if(rescateConsulta.isEmpty()){
            respuestaRegistro = 'El rescate ya ha sido generado o esta inactivo.';
            respuesta.add(respuestaRegistro);
            return respuesta;
        }
        ANEFI_Rescates_Programados__c rescate = new ANEFI_Rescates_Programados__c();
        rescate = rescateConsulta[0];
        String registroRescateInputString ='';
        registroRescateInputString =  '{';
        registroRescateInputString = registroRescateInputString +  ' "codigoAgencia" :' +  '"1",';
        registroRescateInputString = registroRescateInputString +' "tipoRescate" : "' +  rescate.ANEFI_Tipo_de_Rescate__c +  '"' +',';
        registroRescateInputString = registroRescateInputString + ' "codigoTipoTransaccion" : "' + rescate.Anefi_CodTipoTransaccion__c + '"' + ',';
        if( rescate.Anefi_MontoRescate__c > 0){
            registroRescateInputString = registroRescateInputString +  ' "monto" : "'  + String.valueOf(rescate.Anefi_MontoRescate__c) + '"'  + ','; 
        }else{
            registroRescateInputString = registroRescateInputString +  ' "monto" : ""'  + ','; 
            
        }
        
        
        registroRescateInputString = registroRescateInputString +  ' "codigoMoneda" : "' + '1' + '"' + ',';
        registroRescateInputString = registroRescateInputString + ' "fechaEfectiva" : "' + rescate.Anefi_FechaEfectiva__c + '"' + ', ';
        registroRescateInputString = registroRescateInputString + ' "codigoTipoFormaPago" : "' + rescate.Anefi_FormaDePago__c + '"' +' ,';
        registroRescateInputString = registroRescateInputString + ' "manejaExcepciones" : ' + rescate.ANEFI_ManejaExcepcion__c  + ',';
        
        registroRescateInputString = registroRescateInputString + ' "cuentaBancariaProducto" : { ' ;
        registroRescateInputString = registroRescateInputString + ' "codigoTipoEntidadFinanciera" : "' + rescate.Anefi_Tipo_Entidad_Financiera_Producto__c + '"' + ',';
        registroRescateInputString = registroRescateInputString + ' "codigoEntidadFinanciera" : "' + rescate.Anefi_Entidad_Financiera_Producto__c + '"' + ',';
        registroRescateInputString = registroRescateInputString + ' "numeroCuenta" : "' +rescate.Anefi_NumeroCuentaProducto__c +'"'  ;
        registroRescateInputString = registroRescateInputString + '},';    
        registroRescateInputString = registroRescateInputString + ' "cuentaBancariaDestino" : { ' ;   
        registroRescateInputString = registroRescateInputString + ' "codigoTipoEntidadFinanciera" : "' + rescate.Anefi_Tipo_Entidad_Financiera_Destino__c + '"' + ',';
        registroRescateInputString = registroRescateInputString + ' "codigoEntidadFinanciera" : "' + rescate.Anefi_Entidad_Financiera_Destino__c + '"' + ',';
        registroRescateInputString = registroRescateInputString + ' "numeroCuenta" : "' +rescate.Anefi_NumeroCuentaDestino__c + '"' ;
        registroRescateInputString = registroRescateInputString + '}';
        registroRescateInputString = registroRescateInputString + '}';
        system.debug('json1 ->' + (registroRescateInputString));        
        
        
        respuestaRegistro = registraRescate( rescate.Anefi_CuentaRescate__c, rescate.Anefi_Codigo_Gestor_Participe__c, rescate.Anefi_Producto_Rescate__c, rescate.Anefi_Numero_Cuenta_Gestor__c, registroRescateInputString,false);
        System.debug('respuesta ->' +  respuestaRegistro);
        rescate.ANEFI_Respuesta_de_envio_rescate__c = respuestaRegistro;
        rescate.Anefi_Usuario_Envio_Rescate__c = UserInfo.getUserId();
        rescate.ANEFI_Fecha_Envio_Rescate__c = Date.today();
        if(respuestaRegistro == '201' || respuestaRegistro == '204' ){
            rescate.Anefi_Estado_Rescate__c = 'Enviado';
            respuestaRegistro = 'Rescate creado exitosamente.';
            rescate.ANEFI_Respuesta_de_envio_rescate__c = 'OK, Rescate generado.';
        }else{
            rescate.Anefi_Estado_Rescate__c = 'Con Error';
            respuestaRegistro = 'Ha ocurrido un error, consulte con su administrador';
        }
        update rescate;
        respuesta.add(respuestaRegistro);
        return respuesta;
    }
    
    public static void creaRescatePDF(String fechaEfectiva, String accountId,String tipoFondo,String numeroCuentaProducto,String tipoRescate, Decimal montoRescate, String identificacionCuentaDestino,String titularCuenta,String bancoDestino, String tipoCuenta, String numeroCuentaDestino){
        
        List<ANEFI_Entidad_financiera__c> entidadFinanciera = new List<ANEFI_Entidad_financiera__c>();
        
        entidadFinanciera = [Select Nombre__c,Name from ANEFI_Entidad_financiera__c where Name =:bancoDestino.trim() limit 1 ];
        System.debug('tipo tipoFondo' + tipoFondo);
        Date fechaEfec;
        fechaEfec = Date.today();
        String fechaString = '';
        String mes= '';
        String dia = '';
        mes = (fechaEfec.month()<=9) ? '0'+ String.valueOf(fechaEfec.month()) : String.valueOf(fechaEfec.month());
        dia = (fechaEfec.day()<=9) ? '0'+ String.valueOf(fechaEfec.day()) : String.valueOf(fechaEfec.day());
        fechaString = fechaEfec.year() + '-'+mes + '-'+ dia;
        ANEFI_Rescates_Programados__c rescateProgramado = new ANEFI_Rescates_Programados__c();
        rescateProgramado.Anefi_FechaEfectiva__c = (fechaEfectiva.trim() == '' || fechaEfectiva == null) ? fechaString : fechaEfectiva;
        rescateProgramado.AccountId__c = accountId;
        rescateProgramado.Tipo_Fondo__c = (tipoFondo == 'F001') ? 'CP-1' : (tipoFondo == 'F002') ? 'FS-2' : (tipoFondo == 'F004') ? 'FM-3' : (tipoFondo == 'F003') ? 'Optimo': (tipoFondo=='F005')? 'FAS 5' : '';
        rescateProgramado.Anefi_NumeroCuentaProducto__c = numeroCuentaProducto;
        rescateProgramado.ANEFI_Tipo_de_Rescate__c = tipoRescate;
        rescateProgramado.Anefi_MontoRescate__c = montoRescate;
        rescateProgramado.Identificacion_Cuenta_Destino__c = identificacionCuentaDestino;
        rescateProgramado.Titular_de_la_cuenta__c = titularCuenta;
        rescateProgramado.Banco_Destino__C = (entidadFinanciera.size()>0) ?entidadFinanciera[0].Nombre__c : '';
        rescateProgramado.Tipo_de_cuenta__C = (tipoCuenta =='C') ? 'Cheque' : 'Ahorro';
        rescateProgramado.Anefi_NumeroCuentaDestino__c = numeroCuentaDestino;
        Account acc = [Select id,Correo_electronico__c,RecordType.developername,owner.name,owner.Email,name from account where id =:accountId];
        String correoElectronicoCliente;
        if(ANEFI_OpportunityHelper.RECORDTYPE_ACCOUNT_BUSINESS.equals(acc.RecordType.DeveloperName)){
            ANEFI_ServicesDTO.ConsultaPersonaJuridica consulta = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(acc.Id);
            
            for(integer i=0 ; i<consulta.personaJuridicaOut.direccionesElectronicas.size();i++){
                if(consulta.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                    correoElectronicoCliente = consulta.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                }
            }
        }else{
            correoElectronicoCliente = acc.Correo_electronico__c;
        }    
        insert rescateProgramado;
        System.debug('rescateProgramado->'+rescateProgramado.id );
        
        creaPdfRescate(rescateProgramado.id,accountId,correoElectronicoCliente,acc.Name);                               
    }
    
    @future(callout=true)
    public static void creaPdfRescate(String idRescate, String idCuenta,String correoElectronico,String nombreCuenta){
        Boolean sendEmail = false;
        ANEFI_Rescates_Programados__c  rescate = [Select id,CreatedDate,Titular_de_la_cuenta__c,Banco_Destino__C,Tipo_Fondo__c,Anefi_MontoRescate__c,Anefi_FechaEfectiva__c from ANEFI_Rescates_Programados__c  where id =: idRescate];
        String correo = UserInfo.getUserEmail();
        string pagina,titulo,typeDoc;
        pagina = 'ANEFISolicitudRescate';
        titulo = 'Solicitud de Rescate';
        PageReference ref = new PageReference('/apex/'+pagina+'?id='+idRescate);
        ContentVersion cont = new ContentVersion();
        cont.Title = titulo;
        cont.PathOnClient = 'file.pdf';   
        if(Test.isRunningTest()){
            cont.VersionData = blob.valueOf('Unit.Test');                              
        }else{                
            cont.VersionData = ref.getContentAsPDF(); 
        }
        cont.Origin = 'H';
        insert cont;
        Id conDoc = [Select ContentDocumentId from ContentVersion where Id=:cont.Id].ContentDocumentId;
        ContentDocumentLink contentDocResumen = new ContentDocumentLink(ContentDocumentId = conDoc,LinkedEntityId = idCuenta,ShareType = 'I');
        insert contentDocResumen;    
        
        sendEmail = (correoElectronico != null) ? true :false;
        
        if(sendEmail){
            EmailTemplate et = [SELECT Id,Subject, Body,DeveloperName,HtmlValue FROM EmailTemplate where developername = 'PlantillaNuevoRescate'];
            String htmlBody = et.HtmlValue;
            String monto = String.valueOf(rescate.Anefi_MontoRescate__c);
            System.debug('monto ->'+monto);
            htmlBody = htmlBody.replace('{!ANEFI_Rescates_Programados__c.Titular_de_la_cuenta__c}',nombreCuenta)
                .replace('{!ANEFI_Rescates_Programados__c.Tipo_Fondo__c}',rescate.Tipo_Fondo__c).
                replace('{!ANEFI_Rescates_Programados__c.Anefi_MontoRescate__c}',monto).
                replace('{!ANEFI_Rescates_Programados__c.CreatedDate}',String.valueOf(rescate.CreatedDate)).
                replace('{!ANEFI_Rescates_Programados__c.Anefi_FechaEfectiva__c}',rescate.Anefi_FechaEfectiva__c)
                .replace('{!ANEFI_Rescates_Programados__c.Banco_Destino__c}',rescate.Banco_Destino__c).
                replace(']]>','');
            System.debug('htmlbody ->'+ htmlBody);
            System.debug('htmlbody ->'+ htmlBody);
            Messaging.Emailfileattachment efat = new Messaging.Emailfileattachment();
            efat.setFileName(titulo+'.pdf');
            Blob b = blob.valueof('error');
            efat.setBody( (Test.isRunningTest()) ? b :  ref.getContentAsPDF());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {'carlos.escoto@intellectsystem.net'}; 
            //String[] ccAddresses = new String[] {'carlos.escoto@yahoo.com'};        
            String[] toAddresses = new String[] {correoElectronico,correo}; 
                String[] ccAddresses = new String[] {Label.Correo_Administrador};
                    mail.setToAddresses(toAddresses);	
            mail.setCcAddresses(ccAddresses);
            mail.setSubject(et.subject);
            mail.setHtmlBody(htmlBody);
            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efat });//Set File Attachment
            
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                
            }
        }
    } 
    @AuraEnabled()
    public static String creaRescateProgramado(String agencia, String codigoMoneda,String codigoFormaPago, String codigoTipoTransaccion
                                               ,String clienteId,
                                               String codigoGestorParticipe, String entidadFinancieraProducto,String entidadFinancieraDestino,
                                               String fechaEfectiva,Date fechaEjecucionRescate, Boolean manejaExcepciones, Decimal montoRescate,
                                               String numeroCuentaProducto, String numeroCuentaDestino, String numeroCuentaGestor,
                                               String productoRescate,String tipoRescate, String tipoEntidadProducto, String tipoEntidadDestino,
                                               String usuarioCreoRescate, String frecuenciaRescate, integer periodo
                                              ){
                                                  List<ANEFI_Rescates_Programados__c>  listRescate = new List<ANEFI_Rescates_Programados__c>();
                                                  
                                                  Account acc = [ Select id, name from account where id =: clienteId];
                                                  
                                                  system.debug('llama a crea rescate sf');
                                                  if(frecuenciaRescate == '1'){
                                                      try {
                                                          
                                                          String mesEfectivo = '';
                                                          String diaEFectivo = '';
                                                          diaEFectivo = (fechaEjecucionRescate.day() < 10) ? '0'+String.valueOf(fechaEjecucionRescate.day()) : String.valueOf(fechaEjecucionRescate.day())  ;
                                                          mesEfectivo =  (fechaEjecucionRescate.month() < 10) ? '0'+String.valueOf(fechaEjecucionRescate.month()) : String.valueOf(fechaEjecucionRescate.month())  ;
                                                          ANEFI_Rescates_Programados__c  rescate = new ANEFI_Rescates_Programados__c();
                                                          rescate.Anefi_Agencia__c = agencia;
                                                          rescate.Anefi_Codigo_Gestor_Participe__c = codigoGestorParticipe;
                                                          rescate.Anefi_CodigoMoneda__c = codigoMoneda;
                                                          rescate.Anefi_CodTipoTransaccion__c = codigoTipoTransaccion;
                                                          rescate.Anefi_Entidad_Financiera_Destino__c = entidadFinancieraDestino;
                                                          rescate.Anefi_Entidad_Financiera_Producto__c = entidadFinancieraProducto;
                                                          rescate.Anefi_Estado_Rescate__c = 'Activo';
                                                          rescate.Anefi_Fecha_Ejecucion_Rescate__c = fechaEjecucionRescate;
                                                          rescate.Anefi_FechaEfectiva__c = fechaEjecucionRescate.year() + '-' + mesEfectivo + '-' +diaEFectivo;
                                                          rescate.Anefi_FormaDePago__c = codigoFormaPago;
                                                          rescate.ANEFI_ManejaExcepcion__c = true;
                                                          rescate.Anefi_MontoRescate__c = montoRescate;
                                                          rescate.Anefi_Numero_Cuenta_Gestor__c = numeroCuentaGestor;
                                                          rescate.Anefi_NumeroCuentaDestino__c = numeroCuentaDestino;
                                                          rescate.Anefi_NumeroCuentaProducto__c = numeroCuentaProducto;
                                                          rescate.Anefi_Producto_Rescate__c = productoRescate;
                                                          rescate.ANEFI_Tipo_de_Rescate__c = tipoRescate;
                                                          rescate.Anefi_Tipo_Entidad_Financiera_Destino__c = tipoEntidadDestino;
                                                          rescate.Anefi_Tipo_Entidad_Financiera_Producto__c = tipoEntidadProducto;
                                                          rescate.Anefi_Usuario_Creo_Rescate__c = UserInfo.getUserId();
                                                          rescate.Anefi_CuentaRescate__c = acc.id;
                                                          rescate.Name = 'Rescate cuenta ' +  acc.Name + ' año ' + fechaEjecucionRescate.year() +  ' mes ' + fechaEjecucionRescate.month() + ' dia ' + fechaEjecucionRescate.day()  ;
                                                          insert rescate;
                                                      }catch(Exception ex){
                                                          return 'Error';
                                                      }     
                                                  }else if(frecuenciaRescate == '2'){
                                                      Integer restDays = 0;
                                                      Date fechaCiclicla = fechaEjecucionRescate;
                                                      for(Integer i=0;i<periodo;i++){
                                                          String mesEfectivo = '';
                                                          String diaEFectivo = '';
                                                          ANEFI_Rescates_Programados__c  rescate = new ANEFI_Rescates_Programados__c();
                                                          
                                                          diaEFectivo = (fechaCiclicla.day() < 10) ? '0'+String.valueOf(fechaCiclicla.day()) : String.valueOf(fechaCiclicla.day())  ;
                                                          mesEfectivo =  (fechaCiclicla.month() < 10) ? '0'+String.valueOf(fechaCiclicla.month()) : String.valueOf(fechaCiclicla.month())  ;
                                                          
                                                          rescate.Anefi_Agencia__c = agencia;
                                                          rescate.Anefi_Codigo_Gestor_Participe__c = codigoGestorParticipe;
                                                          rescate.Anefi_CodigoMoneda__c = codigoMoneda;
                                                          rescate.Anefi_CodTipoTransaccion__c = codigoTipoTransaccion;
                                                          rescate.Anefi_Entidad_Financiera_Destino__c = entidadFinancieraDestino;
                                                          rescate.Anefi_Entidad_Financiera_Producto__c = entidadFinancieraProducto;
                                                          rescate.Anefi_Estado_Rescate__c = 'Activo';
                                                          rescate.Anefi_Fecha_Ejecucion_Rescate__c = fechaCiclicla;
                                                          rescate.Anefi_FechaEfectiva__c = fechaCiclicla.year() + '-'+ mesEfectivo+ '-' + diaEFectivo;
                                                          rescate.Anefi_FormaDePago__c = codigoFormaPago;
                                                          rescate.ANEFI_ManejaExcepcion__c = true;
                                                          rescate.Anefi_MontoRescate__c = montoRescate;
                                                          rescate.Anefi_Numero_Cuenta_Gestor__c = numeroCuentaGestor;
                                                          rescate.Anefi_NumeroCuentaDestino__c = numeroCuentaDestino;
                                                          rescate.Anefi_NumeroCuentaProducto__c = numeroCuentaProducto;
                                                          rescate.Anefi_Producto_Rescate__c = productoRescate;
                                                          rescate.ANEFI_Tipo_de_Rescate__c = tipoRescate;
                                                          rescate.Anefi_Tipo_Entidad_Financiera_Destino__c = tipoEntidadDestino;
                                                          rescate.Anefi_Tipo_Entidad_Financiera_Producto__c = tipoEntidadProducto;
                                                          rescate.Anefi_Usuario_Creo_Rescate__c = UserInfo.getUserId();
                                                          rescate.Anefi_CuentaRescate__c = acc.id;
                                                          rescate.Name = 'Rescate cuenta ' +  acc.Name +  ' año ' + fechaCiclicla.year() + ' mes ' + fechaCiclicla.month() + ' dia ' + fechaCiclicla.day()  ; 
                                                          fechaCiclicla = fechaCiclicla - restDays;
                                                          fechaCiclicla =  fechaCiclicla.addMonths(1);
                                                          Time myTime = Time.newInstance(3, 3, 3, 0);
                                                          
                                                          Datetime dt =  DateTime.newInstance(fechaCiclicla, myTime);
                                                          System.debug('fechaCiclicla en for' + fechaCiclicla);
                                                          String diaMes  = dt.format('EEEE');
                                                          System.debug('dia mes' + diaMes);
                                                          
                                                          if(diaMes == 'Saturday'){
                                                              fechaCiclicla = fechaCiclicla.addDays(2);
                                                              restDays = 2;
                                                          }
                                                          else if(diaMes == 'Sunday'){
                                                              fechaCiclicla = fechaCiclicla.addDays(1);
                                                              restDays = 1;
                                                          }else{
                                                              restDays = 0;
                                                              
                                                          }
                                                          
                                                          listRescate.add(rescate);	
                                                      }
                                                      insert listRescate;
                                                  }
                                                  
                                                  return 'OK';
                                              }
    @AuraEnabled()
    public static List<ItemConsultaCuentasBancarias> consultaCuentas(String codigoProducto,String clienteId,Boolean consultaLogin){
        CuentasBancarias consultaCuenta = null;
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();    
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        system.debug('configuracionGestorWeb'+configuracionGestorWeb);
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
        system.debug('loginOUTDTO'+loginOUTDTO);
        if(loginOUTDTO != null){
            System.debug('logOut' + loginOUTDTO);
            HttpResponse response = obtenerInformacionCuentasSalidas(requestHandler,clienteId,codigoProducto); 
            System.debug('response' + JSON.serializePretty(response.getBody()) );
            String jsonString =response.getBody();
            consultaCuenta = (ANEFI_CreaRescate.CuentasBancarias)JSON.deserialize(jsonString,ANEFI_CreaRescate.CuentasBancarias.class);
            System.debug('response2' + consultaCuenta );
        }
        
        return consultaCuenta.data;
    }
    @AuraEnabled()
    public static List<ItemConsultaCuentasBancarias> consultaCuentasReferenciaBancaria(String codigoPersonaGestor,String clienteId){
        CuentasBancarias consultaCuenta = null;
        CuentasBancariasTerceros consultaCuentaTerceros = null;
        List<ItemConsultaCuentasBancarias> referenciaCuentas = new List<ItemConsultaCuentasBancarias>();
        
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();    
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
        if(loginOUTDTO != null){
            System.debug('logOut' + loginOUTDTO);
            HttpResponse response = obtenerInformacionCuentasReferencia(requestHandler,clienteId,codigoPersonaGestor,'cuentaReferenciaBancaria'); 
            System.debug('response referencia bancaria ' + JSON.serializePretty(response.getBody()) );
            String jsonString =response.getBody();
            consultaCuenta = (ANEFI_CreaRescate.CuentasBancarias)JSON.deserialize(jsonString,ANEFI_CreaRescate.CuentasBancarias.class);
            System.debug('referencia bancaria ' + consultaCuenta );
            referenciaCuentas.addAll(consultaCuenta.data);
            for(Integer i = 0;i<referenciaCuentas.size();i++ ){
                referenciaCuentas[i].esBeneficiario = false;
            }
            response = obtenerInformacionCuentasReferencia(requestHandler,clienteId,codigoPersonaGestor,'cuentaReferenciaBancariaTerceros'); 
            System.debug('response referencia bancaria terceros ' + JSON.serializePretty(response.getBody()) );
            jsonString =response.getBody();
            consultaCuentaTerceros = (ANEFI_CreaRescate.CuentasBancariasTerceros)JSON.deserialize(jsonString,ANEFI_CreaRescate.CuentasBancariasTerceros.class);
            System.debug('referencia bancaria terceros ' + consultaCuentaTerceros );
            //referenciaCuentas.addAll(consultaCuenta.data);
            for(Integer i = 0;i<consultaCuentaTerceros.data.size();i++ ){
                ItemConsultaCuentasBancarias item = new ItemConsultaCuentasBancarias();
                item.codigoTipoEntidadFinanciera = consultaCuentaTerceros.data[i].cuentaBancaria.codigoTipoEntidadFinanciera;
                item.codigoEntidadFinanciera = consultaCuentaTerceros.data[i].cuentaBancaria.codigoEntidadFinanciera;
                item.numeroCuenta = consultaCuentaTerceros.data[i].cuentaBancaria.numeroCuenta;
                item.codigoTipoCuenta  = consultaCuentaTerceros.data[i].cuentaBancaria.codigoTipoCuenta; 
                item.nombre =  consultaCuentaTerceros.data[i].titular.nombre; 
                item.identificacion = consultaCuentaTerceros.data[i].titular.identificacion; 
                item.esBeneficiario = true;
                referenciaCuentas.add(item);
            }
            
            
        }
        ///System.debug('referencia bancaria data ' + consultaCuenta.data );
        
        return referenciaCuentas;
    }
    @AuraEnabled()
    public static datosMontosProducto consultaDatosMontosProducto(String codigoProducto,String clienteId){
        datoMontosProducto consultaDatosProducto = null;
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();    
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);
        if(loginOUTDTO != null){
            System.debug('logOut' + loginOUTDTO);
            HttpResponse response = obtenerInformacionMontoProductos(requestHandler,clienteId,codigoProducto); 
            System.debug('consultaDatosMontosProducto' + JSON.serializePretty(response.getBody()) );
            String jsonString =response.getBody();
            consultaDatosProducto = (ANEFI_CreaRescate.datoMontosProducto)JSON.deserialize(jsonString,ANEFI_CreaRescate.datoMontosProducto.class);
            System.debug('consultaDatosMontosProducto' + consultaDatosProducto );
            System.debug('consultaDatosMontosProducto.data' + consultaDatosProducto.data );
        }
        
        return consultaDatosProducto.data;
    }
    @AuraEnabled()
    public static String registraRescate(String clienteId,String codigoPersonaGestor,String codigoProducto,String numeroCuenta,String registroRescateInputString,Boolean createPdf){
        ANEFI_RequestsHandler requestHandler = new ANEFI_RequestsHandler();    
        Integer responseStatusCode = 0;
        configuracionGestorWeb = ANEFI_Utilitarios.obtenerConfiguracionGestorWeb();
        String codigoRespuestaCreacionRescate = null;
        loginOUTDTO = ANEFI_Utilitarios.autenticarEnGestor(requestHandler, clienteId, configuracionGestorWeb);   
        if(loginOUTDTO != null){
            String URLServicio = '';
            String metodoHTTP = '';
            ANEFI_PostRequestData postRequestData = null;
            URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('registroRescate');
            System.debug('URLServicio' +URLServicio);
            URLServicio = URLServicio.replace('{codigoEmpresa}', '-');	
            URLServicio = URLServicio.replace('{codigoProducto}', codigoProducto);	
            URLServicio = URLServicio.replace('{codigoCliente}', codigoPersonaGestor);	
            URLServicio = URLServicio.replace('{numeroCuenta}', numeroCuenta);	         
            metodoHTTP = 'POST';
            RegistroRescate registroRescateInput = 
                (RegistroRescate)
                JSON.deserialize(registroRescateInputString, RegistroRescate.class); 
            System.debug('registroRescateInput' + registroRescateInput);
            registroRescateInput.canal = 'CRM';
            postRequestData =  new ANEFI_PostRequestData(registroRescateInput);
            String endpoint = configuracionGestorWeb.URL__c + URLServicio;
            Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);               
            String body = JSON.serialize(postRequestData,true);                
            ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;
            HttpResponse response = null;
            String responseBody = '';
            try {
                requestHandlerResponse = requestHandler.processRequest(endpoint, body, headers, metodoHTTP ,null, clienteId); 
                response = requestHandlerResponse.response;
                responseStatusCode = response.getStatusCode(); 
                responseBody = response.getBody();  
            } catch (Exception e) {
                responseStatusCode = 404;
                responseBody = 'Error al intentar realizar el rescate';
            }     
            
            System.debug('responseBody ->'+responseBody);            
            
            System.debug('responseStatusCode ->' + responseStatusCode);
            Account acc = new Account();
            acc = [Select id, name, Numero_de_identificacion__c from account where id =:clienteId];
            
            if(responseStatusCode == 201){                    		            
                
                //String identificacionCuentaDestino,String titularCuenta,String bancoDestino, String tipoCuenta, String numeroCuentaDestino
                System.debug('registroRescateInput.identificacionCuentaDestino' + registroRescateInput.identificacionCuentaDestino);
                System.debug('registroRescateInput.titularCuentaDestino' + registroRescateInput.titularCuentaDestino);                
                String identificacionCuentaDestino = '';
                String titularCuenta = '';
                identificacionCuentaDestino = (registroRescateInput.identificacionCuentaDestino == '' ||registroRescateInput.identificacionCuentaDestino == null) ? acc.Numero_de_identificacion__c : registroRescateInput.identificacionCuentaDestino ;
                titularCuenta = (registroRescateInput.titularCuentaDestino == '' || registroRescateInput.titularCuentaDestino == null) ? acc.name : registroRescateInput.titularCuentaDestino ;
                
                if(createPdf){
                    Decimal valorRescate = (registroRescateInput.tipoRescate == 'TOT') ? Decimal.valueOf(registroRescateInput.saldoDisponible) : Decimal.valueOf(registroRescateInput.monto);
                    System.debug('registroRescateInput.monto'+registroRescateInput.monto);
                    
                    System.debug('registroRescateInput.saldoDisponible'+registroRescateInput.saldoDisponible);
                    creaRescatePDF(registroRescateInput.fechaEfectiva,clienteId, registroRescateInput.tipoProducto,
                                   registroRescateInput.cuentaBancariaProducto.numeroCuenta,registroRescateInput.tipoRescate,
                                   valorRescate,identificacionCuentaDestino,titularCuenta,
                                   registroRescateInput.cuentaBancariaDestino.codigoEntidadFinanciera,registroRescateInput.cuentaBancariaDestino.tipoCuenta,registroRescateInput.cuentaBancariaDestino.numeroCuenta);
                }
                ANEFI_Utilitarios.enviarNotificacionRescateExitos(acc.name, registroRescateInput.monto, codigoPersonaGestor, numeroCuenta,codigoProducto);
                
            }else{
                codigoRespuestaCreacionRescate = responseBody;
            }
            
        }
        requestHandler.insertRequestLogs(); 
        codigoRespuestaCreacionRescate = String.valueOf(responseStatusCode);
        return  codigoRespuestaCreacionRescate;
    }
    
    /*Método para consultar la información del participe con el código de persona dado en Gestor*/
    public static HttpResponse obtenerInformacionCuentasSalidas(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoProducto){
        HttpResponse response = null;        
        
        String URLServicio = '';
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('cuentasBancarias');
        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de información persona');        
        URLServicio = URLServicio.replace('{codigoProducto}', codigoProducto);
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);         
        
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;     
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',null, clienteID); 
            response = requestHandlerResponse.response;
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            
        } catch (Exception e) {
            System.debug('exception' + e.getMessage());
            throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
        }       
        return response;
    }
    /*Método para consultar la información de los montos del producto indicado , codigoProducto.*/
    public static HttpResponse obtenerInformacionMontoProductos(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoProducto){
        HttpResponse response = null;        
        
        String URLServicio = '';
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre('consultaConfiguracionMontos');
        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de información persona');        
        URLServicio = URLServicio.replace('{codigoProducto}', codigoProducto).replace('{codigoEmpresa}','1');
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);         
        
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;     
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',null, clienteID); 
            response = requestHandlerResponse.response;
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            
        } catch (Exception e) {
            System.debug('exception' + e.getMessage());
            throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
        }       
        return response;
    }
    public static HttpResponse obtenerInformacionCuentasReferencia(ANEFI_RequestsHandler requestHandler, String clienteID, String codigoPersonaGestor,String url){
        HttpResponse response = null;        
        
        String URLServicio = '';
        URLServicio = ANEFI_Utilitarios.obtenerURLServicioPorNombre(url);
        
        if(String.isBlank(URLServicio) || String.isEmpty(URLServicio))throw new GestionarParticipeGestorException('No se ha definido la URL del servicio de consulta de información persona');        
        URLServicio = URLServicio.replace('{codigoPersonaGestor}', codigoPersonaGestor);
        String endpoint = configuracionGestorWeb.URL__c + URLServicio;
        Map<String,String> headers = ANEFI_Utilitarios.obtenerHeadersGenerales(configuracionGestorWeb, loginOUTDTO);         
        
        ANEFI_ServicesDTO.RequestsHandlerResponse requestHandlerResponse = null;     
        
        try {
            requestHandlerResponse = requestHandler.processRequest(endpoint, null, headers, 'GET',null, clienteID); 
            response = requestHandlerResponse.response;
            if(requestHandlerResponse.loginOUT != null){
                loginOUTDTO = requestHandlerResponse.loginOUT;
            }
            
        } catch (Exception e) {
            System.debug('exception' + e.getMessage());
            throw new GestionarParticipeGestorException('No se pudo realizar la petición: ' + e.getMessage());
        }       
        return response;
    }
    public class CuentasBancarias{
        public List<ItemConsultaCuentasBancarias> data;
    }
    public class CuentasBancariasTerceros{
        public List<datosTerceros> data;
    }
    
    public class datosTerceros{
        public cuentaBancaria cuentaBancaria;
        public titular titular;
    }
    public class cuentaBancaria {
        
        @AuraEnabled
        public String codigoTipoEntidadFinanciera;
        @AuraEnabled
        public String codigoEntidadFinanciera;
        @AuraEnabled
        public String nombreEntidadFinanciera;
        @AuraEnabled
        public String numeroCuenta;     
        @AuraEnabled
        public String codigoTipoCuenta;
        @AuraEnabled
        public String nombreTipoCuenta;
        @AuraEnabled
        public String codigoMoneda;
        
    }
    public class titular  {
        @AuraEnabled
        public String nombre;
        @AuraEnabled
        public String codigoTipoIdentificacion;
        @AuraEnabled
        public String nombreTipoIdentificacion;
        @AuraEnabled
        public String identificacion;
        
    }
    public class ItemConsultaCuentasBancarias{
        
        @AuraEnabled
        public String codigoTipoEntidadFinanciera;
        @AuraEnabled
        public String codigoEntidadFinanciera;
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public String codigoTipoCuenta;     
        @AuraEnabled
        public String nombre;
        @AuraEnabled
        public String identificacion;
        @AuraEnabled
        public boolean esBeneficiario = false;
        
        
    }
    
    public class ResponseDataRegistroRescateOut{
        public RegistroRescate data;
    }
    
    public class RegistroRescate{
        public String codigoAgencia;
        public String tipoRescate;
        public String codigoTipoTransaccion;
        public String monto;     
        public String codigoMoneda;
        public String fechaEfectiva;
        public String codigoTipoFormaPago;
        public Boolean manejaExcepciones = true;
        public string tipoProducto;
        public String identificacionCuentaDestino;
        public String titularCuentaDestino;
        public String canal;
        public cuentaBancariaProducto cuentaBancariaProducto;
        public cuentaBancariaDestino cuentaBancariaDestino;
        public String saldoDisponible;
        
    }
    public class cuentaBancariaProducto{
        public String codigoTipoEntidadFinanciera;
        public String codigoEntidadFinanciera;
        public String numeroCuenta;
    }
    public class cuentaBancariaDestino{
        public String codigoTipoEntidadFinanciera;
        public String codigoEntidadFinanciera;
        public String numeroCuenta;
        public String tipoCuenta;
    }
    public class datoMontosProducto {
        @AuraEnabled
        public datosMontosProducto data;
    }
    
    
    public class DisponibilidadEgresos {
        @AuraEnabled
        public Integer numeroRango;
        @AuraEnabled
        public Integer diasDesde;
        @AuraEnabled
        public Integer diasHasta;
        @AuraEnabled
        public Decimal porcentajeEgresoDesde;
        @AuraEnabled
        public Decimal porcentajeEgresoHasta;
        @AuraEnabled
        public String codigoRetencion;
        @AuraEnabled
        public String codigoPorcentajeRetencion;
    }
    
    public class datosMontosProducto {
        @AuraEnabled
        public Decimal montoMinimoEgreso;
        @AuraEnabled
        public Decimal montoMinimoIngreso;
        @AuraEnabled
        public Decimal montoMinimoIncremento;
        @AuraEnabled
        public Decimal montoMinimoSaldo;
        @AuraEnabled
        public Integer diasSaldoMinimo;
        @AuraEnabled
        public Integer diasEsperaDesembolso;
        @AuraEnabled
        public Integer diasEntreDesembolsos;
        @AuraEnabled
        public Integer numeroDesembolsos;
        @AuraEnabled
        public String tipoComision;
        @AuraEnabled
        public Decimal valorComision;
        @AuraEnabled
        public Integer diasEfectivizacion;
        @AuraEnabled
        public String controlarDisponibilidadSoloPrimerAporte;
        @AuraEnabled
        public String codigoImpuestoPorPermanencia;
        @AuraEnabled
        public String codigoRetencionPorPermanencia;
        @AuraEnabled
        public String fechaMinimaRescate;
        @AuraEnabled
        public List<DisponibilidadEgresos> disponibilidadEgresos;
    }
    
}