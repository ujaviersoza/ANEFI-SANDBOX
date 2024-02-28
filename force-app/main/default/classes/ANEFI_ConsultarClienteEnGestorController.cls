public without sharing class ANEFI_ConsultarClienteEnGestorController {
    
    public static Id recordTypeIdPersonaJuridica = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Juridica').getRecordTypeId();
    
    public static Id recordTypeIdPersonaNatural =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Persona_Natural').getRecordTypeId();
            
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
    
    
    
    
    @AuraEnabled()
    public static boolean markUpdatedOrNot(Id clienteId){
        
        system.debug('-------------------CHECK UPDATED------------------');
        
        Account acc = [Select id, RecordType.DeveloperName,Capital_social__c, Calle_principal_direccion_tributaria__c, Total_patrimonio__c,
                       Calle_principal_direccion_trabajo__c, Cargo_representante_legal__c, 
                       Codigo_actividad_economica__c, Codigo_pais_nacionalidad__c, Codigo_pais_direccion_trabajo__c, Codigo_pais_direccion_tributaria__c, 
                       Codigo_canton_direccion_trabajo__c, Codigo_canton_direccion_tributaria__c, Secuencia_canton_direccion_trabajo__c, 
                       
                       Tipo_de_identificacion__c, Tipo_de_persona_juridica__c, Fecha_de_constitucion__c, 
                       Numero_de_identificacion__c, Interseccion_direccion_tributaria__c, 
                       Interseccion_direccion_trabajo__c, Name, Numero_direccion_tributaria__c,                      
                       Numero_direccion_trabajo__c, Description, Politicamente_expuesto__c, 
                       Identificacion_representante_legal__c, Secuencia_canton_direccion_tributaria__c, 
                       Telefono_celular__c, Phone, Total_activos__c, 
                       Total_pasivos__c, Total_gastos__c, AnnualRevenue,Entidad_financiera__c, 
                       Entidad_Financiera__r.Tipo_de_entidad__c,Entidad_Financiera__r.Name, 
                       Numero_de_cuenta_bancaria__c, Tipo_de_cuenta_bancaria__c, Tipo_identificacion_representante_legal__c,
                       Representante_Legal__r.Tipo_de_identificacion__c,Representante_Legal__r.Numero_de_identificacion__c,
                       Representante_Legal__r.title,Correo_electronico__c,
                       (Select FirstName,MiddleName,LastName,Rol_en_la_empresa__c,Nombre_empresa_donde_trabaja__c 
                        from contacts ), ANEFI_Monthly_expenses__c, 
                       PrimerNombre__c, SegundoNombre__c, PrimerApellido__c, SegundoApellido__c,                       
                       Paga_impuestos__c,  
                       Codigo_pais_de_nacimiento__c, Codigo_provincia_de_nacimiento__c, 
                       Secuencia_canton_de_nacimiento__c, Codigo_canton_nacimiento__c, Fecha_de_nacimiento__c, 
                       Estado_civil__c, Genero__c, Codigo_pais_direccion_domicilio__c, 
                       Codigo_canton_direccion_domicilio__c, Secuencia_canton_direccion_domicilio__c, 
                       Codigo_provincia_direccion_domicilio__c, Calle_principal_direccion_domicilio__c, 
                       Referencia_direccion_domicilio__c, Telefono_domicilio__c, 
                       Es_direccion_fiscal_direccion_domicilio__c, Tipo_de_empleo__c, 
                       Ingresos_mensuales__c, ANEFI_work_position__c, ANEFI_actualizado_en_Gestor__c                       
                       from Account where id  =: clienteId limit 1];
        
        
        List<String> fieldNames = new List<String>{
            'Capital_social__c', 'Calle_principal_direccion_tributaria__c', 'Total_patrimonio__c',
                'Calle_principal_direccion_trabajo__c', 'Cargo_representante_legal__c', 
                'Tipo_de_identificacion__c', 'Tipo_de_persona_juridica__c', 'Fecha_de_constitucion__c', 
                'Numero_de_identificacion__c', 'Interseccion_direccion_tributaria__c', 
                'Interseccion_direccion_trabajo__c', 'Name', 'Numero_direccion_tributaria__c',
                'Numero_direccion_trabajo__c', 'Description', 'Politicamente_expuesto__c', 
                'Identificacion_representante_legal__c', 
                'Telefono_celular__c', 'Phone', 'Total_activos__c', 
                'Total_pasivos__c', 'Total_gastos__c', 'AnnualRevenue', 'Entidad_financiera__c', 
                'Numero_de_cuenta_bancaria__c', 'Tipo_de_cuenta_bancaria__c', 'Tipo_identificacion_representante_legal__c',  
                'Correo_electronico__c', 'ANEFI_Monthly_expenses__c', 
                'PrimerNombre__c', 'SegundoNombre__c', 'PrimerApellido__c', 'SegundoApellido__c',                       
                'Paga_impuestos__c', 
                'Fecha_de_nacimiento__c', 
                'Estado_civil__c', 'Genero__c',                  
                'Calle_principal_direccion_domicilio__c', 
                'Referencia_direccion_domicilio__c', 'Telefono_domicilio__c', 
                'Es_direccion_fiscal_direccion_domicilio__c', 'Tipo_de_empleo__c', 
                'Ingresos_mensuales__c', 'ANEFI_work_position__c', 'ANEFI_actualizado_en_Gestor__c'
                };
                    for (String fieldName : fieldNames) {
                        
                        try{
                            Schema.DescribeFieldResult fieldDescribe = Account.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
                            if (fieldDescribe.getType() == Schema.DisplayType.STRING ||
                                fieldDescribe.getType() == Schema.DisplayType.TEXTAREA ||
                                fieldDescribe.getType() == Schema.DisplayType.PHONE ||
                                fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                                    Object fieldValue = acc.get(fieldName);
                                    if (fieldValue == null) {
                                        acc.put(fieldName, '');
                                    }
                                }
                        }catch(Exception e){
                            system.debug('Error '+e);
                            system.debug('On item '+fieldName);
                        }
                        
                    }        
        
        boolean updated = true;
        
        String correo_principal = '';
        
        system.debug(acc.RecordType.DeveloperName);
        
        try{
            
            
            if(acc.RecordType.DeveloperName == 'Persona_Juridica'){
                
                ANEFI_ServicesDTO.ConsultaPersonaJuridica personaJuridica = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(acc.id);   
                
                system.debug('Gestor '+JSON.serialize(personaJuridica.personaJuridicaOut));
                
                if(personaJuridica.personaJuridicaOut.direccionesElectronicas != null){
                    for(integer i=0 ; i<personaJuridica.personaJuridicaOut.direccionesElectronicas.size();i++){
                        if(personaJuridica.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                            correo_principal = personaJuridica.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                        }
                    }
                }
                
                if( acc.Total_pasivos__c != personaJuridica.personaJuridicaOut.totalPasivos ||
                   acc.AnnualRevenue != personaJuridica.personaJuridicaOut.totalIngresos ||
                   acc.Total_gastos__c != personaJuridica.personaJuridicaOut.totalGastos ||
                   acc.Total_activos__c != personaJuridica.personaJuridicaOut.totalActivos ||
                   acc.Tipo_de_persona_juridica__c != personaJuridica.personaJuridicaOut.codigoTipoPersonaJuridica ||
                   acc.Phone != personaJuridica.personaJuridicaOut.telefonoConvencional  ||
                   acc.Telefono_celular__c != personaJuridica.personaJuridicaOut.telefonoCelular ||
                   acc.Name != personaJuridica.personaJuridicaOut.razonSocial || 
                   acc.Politicamente_expuesto__c != personaJuridica.personaJuridicaOut.politicamenteExpuesto ||
                   acc.Description!= personaJuridica.personaJuridicaOut.observaciones  ||
                   acc.Numero_direccion_trabajo__c != personaJuridica.personaJuridicaOut.numeroDireccionTrabajo ||
                   acc.Numero_direccion_tributaria__c != personaJuridica.personaJuridicaOut.numeroDireccionResidenciaTributaria ||
                   acc.Numero_de_cuenta_bancaria__c != personaJuridica.personaJuridicaOut.numeroCuentaBancaria ||
                   acc.Interseccion_direccion_trabajo__c != personaJuridica.personaJuridicaOut.interseccionDireccionTrabajo ||
                   acc.Interseccion_direccion_tributaria__c != personaJuridica.personaJuridicaOut.interseccionDireccionResidenciaTributaria ||
                   acc.Numero_de_identificacion__c != personaJuridica.personaJuridicaOut.identificacion ||
                   acc.Fecha_de_constitucion__c != ( personaJuridica.personaJuridicaOut.fechaConstitucion != null? date.valueOf(personaJuridica.personaJuridicaOut.fechaConstitucion) : null )        ||
                   acc.Tipo_de_identificacion__c != personaJuridica.personaJuridicaOut.codigoTipoIdentificacion ||
                   acc.Tipo_de_cuenta_bancaria__c != personaJuridica.personaJuridicaOut.codigoTipoCuentaBancaria ||
                   acc.Cargo_representante_legal__c != personaJuridica.personaJuridicaOut.cargoRepresentanteLegal ||
                   acc.Capital_social__c != personaJuridica.personaJuridicaOut.capitalSocial ||               
                   acc.Correo_electronico__c != correo_principal ||
                   acc.Calle_principal_direccion_trabajo__c != personaJuridica.personaJuridicaOut.callePrincipalDireccionTrabajo ||
                   acc.Calle_principal_direccion_tributaria__c != personaJuridica.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria ||
                   
                   acc.Entidad_Financiera__r.Tipo_de_entidad__c != Integer.valueOf(personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria)||
                   acc.Entidad_Financiera__r.Name != personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria ||
                   acc.Codigo_actividad_economica__c != personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica ||
                   acc.Codigo_pais_nacionalidad__c != personaJuridica.personaJuridicaOut.codigoPaisNacionalidad ||
                   acc.Codigo_pais_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo ||
                   acc.Codigo_pais_direccion_tributaria__c != (String.isBlank(personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria ) == true? null:  personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria ) || 
                   acc.Codigo_canton_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo ||
                   acc.Codigo_canton_direccion_tributaria__c !=  (String.isBlank(personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria) ==true? null : personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria   )||
                   
                   acc.Secuencia_canton_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionTrabajo  ||
                   acc.Secuencia_canton_direccion_tributaria__c != ((personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionResidenciaTributaria ) == null? 0 :  personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionResidenciaTributaria )
                   
                  ){
                      
                      //---------------------------VALIDACIONES PARA TESTING EN CASO DE QUE RESULTADOS ESTEN IGUALES EN GESTOR Y VER DIFERENCIAS
                      /*
                      if (acc.Total_pasivos__c != personaJuridica.personaJuridicaOut.totalPasivos) {
                          system.debug('acc.Total_pasivos__c: ' + acc.Total_pasivos__c + ' - personaJuridica.personaJuridicaOut.totalPasivos: ' + personaJuridica.personaJuridicaOut.totalPasivos);
                      }
                      
                      if (acc.AnnualRevenue != personaJuridica.personaJuridicaOut.totalIngresos) {
                          system.debug('acc.AnnualRevenue: ' + acc.AnnualRevenue + ' - personaJuridica.personaJuridicaOut.totalIngresos: ' + personaJuridica.personaJuridicaOut.totalIngresos);
                      }
                      
                      if (acc.Total_gastos__c != personaJuridica.personaJuridicaOut.totalGastos) {
                          system.debug('acc.Total_gastos__c: ' + acc.Total_gastos__c + ' - personaJuridica.personaJuridicaOut.totalGastos: ' + personaJuridica.personaJuridicaOut.totalGastos);
                      }
                      
                      if (acc.Total_activos__c != personaJuridica.personaJuridicaOut.totalActivos) {
                          system.debug('acc.Total_activos__c: ' + acc.Total_activos__c + ' - personaJuridica.personaJuridicaOut.totalActivos: ' + personaJuridica.personaJuridicaOut.totalActivos);
                      }
                      
                      if (acc.Tipo_de_persona_juridica__c != personaJuridica.personaJuridicaOut.codigoTipoPersonaJuridica) {
                          system.debug('acc.Tipo_de_persona_juridica__c: ' + acc.Tipo_de_persona_juridica__c + ' - personaJuridica.personaJuridicaOut.codigoTipoPersonaJuridica: ' + personaJuridica.personaJuridicaOut.codigoTipoPersonaJuridica);
                      }
                      
                      if (acc.Phone != personaJuridica.personaJuridicaOut.telefonoConvencional) {
                          system.debug('acc.Phone: ' + acc.Phone + ' - personaJuridica.personaJuridicaOut.telefonoConvencional: ' + personaJuridica.personaJuridicaOut.telefonoConvencional);
                      }
                      
                      if (acc.Telefono_celular__c != personaJuridica.personaJuridicaOut.telefonoCelular) {
                          system.debug('acc.Telefono_celular__c: ' + acc.Telefono_celular__c + ' - personaJuridica.personaJuridicaOut.telefonoCelular: ' + personaJuridica.personaJuridicaOut.telefonoCelular);
                      }
                      
                      if (acc.Name != personaJuridica.personaJuridicaOut.razonSocial) {
                          system.debug('acc.Name: ' + acc.Name + ' - personaJuridica.personaJuridicaOut.razonSocial: ' + personaJuridica.personaJuridicaOut.razonSocial);
                      }
                      
                      if (acc.Politicamente_expuesto__c != personaJuridica.personaJuridicaOut.politicamenteExpuesto) {
                          system.debug('acc.Politicamente_expuesto__c: ' + acc.Politicamente_expuesto__c + ' - personaJuridica.personaJuridicaOut.politicamenteExpuesto: ' + personaJuridica.personaJuridicaOut.politicamenteExpuesto);
                      }
                      
                      if (acc.Description != personaJuridica.personaJuridicaOut.observaciones) {
                          system.debug('acc.Description: ' + acc.Description + ' - personaJuridica.personaJuridicaOut.observaciones: ' + personaJuridica.personaJuridicaOut.observaciones);
                      }
                      
                      if (acc.Numero_direccion_trabajo__c != personaJuridica.personaJuridicaOut.numeroDireccionTrabajo) {
                          system.debug('acc.Numero_direccion_trabajo__c: ' + acc.Numero_direccion_trabajo__c + ' - personaJuridica.personaJuridicaOut.numeroDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.numeroDireccionTrabajo);
                      }
                      
                      if (acc.Numero_direccion_tributaria__c != personaJuridica.personaJuridicaOut.numeroDireccionResidenciaTributaria) {
                          system.debug('acc.Numero_direccion_tributaria__c: ' + acc.Numero_direccion_tributaria__c + ' - personaJuridica.personaJuridicaOut.numeroDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.numeroDireccionResidenciaTributaria);
                      }
                      
                      if (acc.Numero_de_cuenta_bancaria__c != personaJuridica.personaJuridicaOut.numeroCuentaBancaria) {
                          system.debug('acc.Numero_de_cuenta_bancaria__c: ' + acc.Numero_de_cuenta_bancaria__c + ' - personaJuridica.personaJuridicaOut.numeroCuentaBancaria: ' + personaJuridica.personaJuridicaOut.numeroCuentaBancaria);
                      }
                      
                      if (acc.Interseccion_direccion_trabajo__c != personaJuridica.personaJuridicaOut.interseccionDireccionTrabajo) {
                          system.debug('acc.Interseccion_direccion_trabajo__c: ' + acc.Interseccion_direccion_trabajo__c + ' - personaJuridica.personaJuridicaOut.interseccionDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.interseccionDireccionTrabajo);
                      }
                      
                      if (acc.Interseccion_direccion_tributaria__c != personaJuridica.personaJuridicaOut.interseccionDireccionResidenciaTributaria) {
                          system.debug('acc.Interseccion_direccion_tributaria__c: ' + acc.Interseccion_direccion_tributaria__c + ' - personaJuridica.personaJuridicaOut.interseccionDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.interseccionDireccionResidenciaTributaria);
                      }
                      
                      if (acc.Numero_de_identificacion__c != personaJuridica.personaJuridicaOut.identificacion) {
                          system.debug('acc.Numero_de_identificacion__c: ' + acc.Numero_de_identificacion__c + ' - personaJuridica.personaJuridicaOut.identificacion: ' + personaJuridica.personaJuridicaOut.identificacion);
                      }               
                      
                      if (Date.valueof(acc.Fecha_de_constitucion__c ) != ( personaJuridica.personaJuridicaOut.fechaConstitucion != null ? date.valueOf(personaJuridica.personaJuridicaOut.fechaConstitucion) : null ) ) {
                          system.debug('acc.Fecha_de_constitucion__c: ' + String.valueOf(acc.Fecha_de_constitucion__c.year()) + '-' + String.valueOf(acc.Fecha_de_constitucion__c.month()) + '-' + String.valueOf(acc.Fecha_de_constitucion__c.day()) + ' - personaJuridica.personaJuridicaOut.fechaConstitucion: ' + personaJuridica.personaJuridicaOut.fechaConstitucion);
                          system.debug('Date value of '+date.valueof(acc.Fecha_de_constitucion__c) + ' - '+date.valueof(personaJuridica.personaJuridicaOut.fechaConstitucion));
                          system.debug('Date raw '+acc.Fecha_de_constitucion__c + ' - '+personaJuridica.personaJuridicaOut.fechaConstitucion);
                      }
                      
                      if (acc.Tipo_de_identificacion__c != personaJuridica.personaJuridicaOut.codigoTipoIdentificacion) {
                          system.debug('acc.Tipo_de_identificacion__c: ' + acc.Tipo_de_identificacion__c + ' - personaJuridica.personaJuridicaOut.codigoTipoIdentificacion: ' + personaJuridica.personaJuridicaOut.codigoTipoIdentificacion);
                      }
                      
                      if (acc.Tipo_de_cuenta_bancaria__c != personaJuridica.personaJuridicaOut.codigoTipoCuentaBancaria) {
                          system.debug('acc.Tipo_de_cuenta_bancaria__c: ' + acc.Tipo_de_cuenta_bancaria__c + ' - personaJuridica.personaJuridicaOut.codigoTipoCuentaBancaria: ' + personaJuridica.personaJuridicaOut.codigoTipoCuentaBancaria);
                      }
                      
                      if ( acc.Cargo_representante_legal__c != personaJuridica.personaJuridicaOut.cargoRepresentanteLegal) {
                          system.debug('acc.Cargo_representante_legal__c: ' + acc.Cargo_representante_legal__c + ' - personaJuridica.personaJuridicaOut.cargoRepresentanteLegal: ' + personaJuridica.personaJuridicaOut.cargoRepresentanteLegal);
                      }
                      
                      if (acc.Capital_social__c != personaJuridica.personaJuridicaOut.capitalSocial) {
                          system.debug('acc.Capital_social__c: ' + acc.Capital_social__c + ' - personaJuridica.personaJuridicaOut.capitalSocial: ' + personaJuridica.personaJuridicaOut.capitalSocial);
                      }
                      
                      if (acc.Calle_principal_direccion_trabajo__c != personaJuridica.personaJuridicaOut.callePrincipalDireccionTrabajo) {
                          system.debug('acc.Calle_principal_direccion_trabajo__c: ' + acc.Calle_principal_direccion_trabajo__c + ' - personaJuridica.personaJuridicaOut.callePrincipalDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.callePrincipalDireccionTrabajo);
                      }
                      
                      if (acc.Calle_principal_direccion_tributaria__c != personaJuridica.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria) {
                          system.debug('acc.Calle_principal_direccion_tributaria__c: ' + acc.Calle_principal_direccion_tributaria__c + ' - personaJuridica.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria);
                      }
                      
                      if (acc.Correo_electronico__c != correo_principal) {
                          system.debug('acc.Correo_electronico__c: ' + acc.Correo_electronico__c + ' - correo_principal: ' + correo_principal);
                      }
                      
                      if (acc.Entidad_Financiera__r.Tipo_de_entidad__c != Integer.valueOf(personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria)) {
                          system.debug('acc.Entidad_Financiera__r.Tipo_de_entidad__c: ' + acc.Entidad_Financiera__r.Tipo_de_entidad__c + ' - personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria: ' + personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria);
                      }
                      
                      if ( acc.Entidad_Financiera__r.Name != personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria) {
                          system.debug('acc.Entidad_Financiera__r.Name: ' + acc.Entidad_Financiera__r.Name + ' - personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria: ' + personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria);
                      }
                      
                      if(acc.Codigo_actividad_economica__c != personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica){
                          system.debug('acc.Codigo_actividad_economica__c: ' + acc.Codigo_actividad_economica__c + ' - codigoTipoActividadEconomica: ' + personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica);                                                    
                      }
                      
                      if(acc.Codigo_pais_nacionalidad__c != personaJuridica.personaJuridicaOut.codigoPaisNacionalidad ){                          
                          system.debug('acc.Codigo_pais_nacionalidad__c: ' + acc.Codigo_pais_nacionalidad__c + ' - codigoPaisNacionalidad: ' + personaJuridica.personaJuridicaOut.codigoPaisNacionalidad);                                                                              
                      }
                      
                      if(acc.Codigo_pais_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo ){                                                    
                          system.debug('acc.Codigo_pais_direccion_trabajo__c: ' + acc.Codigo_pais_direccion_trabajo__c + ' - codigoPaisDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo);                          
                      }
                      
                      if(acc.Codigo_pais_direccion_tributaria__c !=  personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria){                          
                          system.debug('acc.Codigo_pais_direccion_tributaria__c: ' + acc.Codigo_pais_direccion_tributaria__c + ' - codigoPaisDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria);                                                    
                      }
                      
                      if(acc.Codigo_canton_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo){                          
                          system.debug('acc.Codigo_canton_direccion_trabajo__c: ' + acc.Codigo_canton_direccion_trabajo__c + ' - codigoOrgGeoDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo);                                                    
                      }
                      
                      if(acc.Codigo_canton_direccion_tributaria__c !=  personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria){                          
                          system.debug('acc.Codigo_canton_direccion_tributaria__c: ' + acc.Codigo_canton_direccion_tributaria__c + ' - codigoOrgGeoDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria);                                                    
                      }
                      
                      if(acc.Secuencia_canton_direccion_trabajo__c !=  personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionTrabajo){
                          system.debug('acc.Secuencia_canton_direccion_trabajo__c: ' + acc.Secuencia_canton_direccion_trabajo__c + ' - secuenciaOrgGeoDireccionTrabajo: ' + personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionTrabajo);                                                    

                      }
                      
                      if(acc.Secuencia_canton_direccion_tributaria__c !=  personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionResidenciaTributaria){
                          system.debug('acc.Secuencia_canton_direccion_tributaria__c: ' + acc.Secuencia_canton_direccion_tributaria__c + ' - secuenciaOrgGeoDireccionResidenciaTributaria: ' + personaJuridica.personaJuridicaOut.secuenciaOrgGeoDireccionResidenciaTributaria);                                                    

                      }
                      */
                      
                      
                      //-----------------------------------------------
                      
                      system.debug('SYNC Juridico falso');
                      
                      updated = false;
                      
                  }
                
                
            }
            else{
                if(acc.RecordType.DeveloperName == 'Persona_Natural'){                           
                    
                    ANEFI_ServicesDTO.ConsultaPersonaNatural personaNatural = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaNaturalEnGestor(acc.Id); 
                    
                    system.debug('CHECK answer '+personaNatural);
                    
                    if(personaNatural.personaNaturalOut.direccionesElectronicas != null){
                        for(integer i=0 ; i<personaNatural.personaNaturalOut.direccionesElectronicas.size();i++){
                            if(personaNatural.personaNaturalOut.direccionesElectronicas[i].principal == 'S'){
                                correo_principal = personaNatural.personaNaturalOut.direccionesElectronicas[i].correoElectronico;
                            }
                        }
                    }
                    
                    system.debug('Gestor '+JSON.serialize(personaNatural.personaNaturalOut));
                    
                    if(acc.Ingresos_mensuales__c != personaNatural.personaNaturalOut.valorIngresosSueldoMensual   ||
                       acc.Total_gastos__c != personaNatural.personaNaturalOut.valorGastoMensual ||
                       acc.Total_patrimonio__c != personaNatural.personaNaturalOut.totalPatrimonio ||
                       acc.Total_pasivos__c != personaNatural.personaNaturalOut.totalPasivos ||
                       acc.ANEFI_Monthly_expenses__c != personaNatural.personaNaturalOut.totalEgresosMensuales ||
                       acc.Total_activos__c != personaNatural.personaNaturalOut.totalActivos       ||
                       acc.Phone != personaNatural.personaNaturalOut.telefonoOficina ||
                       acc.Telefono_domicilio__c != personaNatural.personaNaturalOut.telefonoDomicilio ||
                       acc.Telefono_celular__c != personaNatural.personaNaturalOut.telefonoCelular ||  
                       acc.PrimerNombre__c != personaNatural.personaNaturalOut.primerNombre ||
                       acc.SegundoNombre__c != personaNatural.personaNaturalOut.segundoNombre ||
                       acc.PrimerApellido__c != personaNatural.personaNaturalOut.primerApellido ||
                       acc.SegundoApellido__c != personaNatural.personaNaturalOut.segundoApellido ||  
                       acc.Referencia_direccion_domicilio__c != personaNatural.personaNaturalOut.referenciaDireccionDomicilio    ||  
                       acc.Politicamente_expuesto__c != personaNatural.personaNaturalOut.politicamenteExpuesto ||
                       acc.Paga_impuestos__c != personaNatural.personaNaturalOut.pagaImpuestos ||
                       acc.Numero_de_cuenta_bancaria__c != personaNatural.personaNaturalOut.numeroCuentaBancaria ||
                       acc.Calle_principal_direccion_trabajo__c != personaNatural.personaNaturalOut.lugarTrabajo ||
                       acc.Numero_de_identificacion__c != personaNatural.personaNaturalOut.identificacion ||
                       acc.Genero__c != personaNatural.personaNaturalOut.genero ||
                       String.valueOf(acc.Fecha_de_nacimiento__c)  !=  personaNatural.personaNaturalOut.fechaNacimiento  ||
                       acc.Es_direccion_fiscal_direccion_domicilio__c != personaNatural.personaNaturalOut.esDireccionFiscalDireccionDomicilio ||
                       acc.Correo_electronico__c != correo_principal ||
                       acc.Tipo_de_identificacion__c != personaNatural.personaNaturalOut.codigoTipoIdentificacion ||
                       acc.Tipo_de_empleo__c != personaNatural.personaNaturalOut.codigoTipoEmpleo ||
                       acc.Tipo_de_cuenta_bancaria__c != personaNatural.personaNaturalOut.codigoTipoCuentaBancaria ||
                       acc.Estado_civil__c != personaNatural.personaNaturalOut.codigoEstadoCivil ||
                       acc.ANEFI_work_position__c != personaNatural.personaNaturalOut.cargo ||
                       acc.Calle_principal_direccion_domicilio__c != personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio ||
                       
                       acc.Secuencia_canton_de_nacimiento__c != ((personaNatural.personaNaturalOut.secuenciaCantonNacimiento ) == null ? 0: personaNatural.personaNaturalOut.secuenciaCantonNacimiento ) ||
                       acc.Secuencia_canton_direccion_domicilio__c != personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio ||
                       acc.Codigo_actividad_economica__c != ((personaNatural.personaNaturalOut.codigoTipoActividadEconomica ) == ''? null : (personaNatural.personaNaturalOut.codigoTipoActividadEconomica ) ) ||
                       acc.Codigo_provincia_de_nacimiento__c != ((personaNatural.personaNaturalOut.codigoProvinciaNacimiento )== ''? null: (personaNatural.personaNaturalOut.codigoProvinciaNacimiento ) ) ||
                       acc.Codigo_provincia_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio) == ''? null: (personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio) )  ||
                       acc.Codigo_pais_nacionalidad__c != ((personaNatural.personaNaturalOut.codigoPaisNacionalidad) == ''? null: (personaNatural.personaNaturalOut.codigoPaisNacionalidad) )  ||
                       acc.Codigo_pais_de_nacimiento__c != ((personaNatural.personaNaturalOut.codigoPaisNacimiento ) == '' ? null: (personaNatural.personaNaturalOut.codigoPaisNacimiento) ) ||
                       acc.Codigo_pais_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio) == '' ?  null : (personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio) ) ||
                       acc.Entidad_Financiera__r.Name  != ((personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria) == '' ? null: (personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria)) ||
                       acc.Codigo_canton_nacimiento__c != ((personaNatural.personaNaturalOut.codigoCantonNacimiento) == '' ? null: (personaNatural.personaNaturalOut.codigoCantonNacimiento)) ||
                       acc.Codigo_canton_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio) == ''? null: (personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio)) ||
                       
                       acc.Entidad_Financiera__r.Tipo_de_entidad__c != Integer.valueOf(personaNatural.personaNaturalOut.codigoTipoEntidadFinancieraCuentaBancaria)
                      ){
                           /*
                           if (acc.Calle_principal_direccion_domicilio__c != personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio) {
                               system.debug('acc.Calle_principal_direccion_domicilio__c: ' + acc.Calle_principal_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio: ' + personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio);
                           }
                           
                           if (acc.Total_gastos__c != personaNatural.personaNaturalOut.valorGastoMensual) {
                               system.debug('acc.Total_gastos__c: ' + acc.Total_gastos__c + ' - personaNatural.personaNaturalOut.valorGastoMensual: ' + personaNatural.personaNaturalOut.valorGastoMensual);
                           }
                           
                           if (acc.Total_patrimonio__c != personaNatural.personaNaturalOut.totalPatrimonio) {
                               system.debug('acc.Total_patrimonio__c: ' + acc.Total_patrimonio__c + ' - personaNatural.personaNaturalOut.totalPatrimonio: ' + personaNatural.personaNaturalOut.totalPatrimonio);
                           }
                           
                           if (acc.Total_pasivos__c != personaNatural.personaNaturalOut.totalPasivos) {
                               system.debug('acc.Total_pasivos__c: ' + acc.Total_pasivos__c + ' - personaNatural.personaNaturalOut.totalPasivos: ' + personaNatural.personaNaturalOut.totalPasivos);
                           }
                           
                           if (acc.ANEFI_Monthly_expenses__c != personaNatural.personaNaturalOut.totalEgresosMensuales) {
                               system.debug('acc.ANEFI_Monthly_expenses__c: ' + acc.ANEFI_Monthly_expenses__c + ' - personaNatural.personaNaturalOut.totalEgresosMensuales: ' + personaNatural.personaNaturalOut.totalEgresosMensuales);
                           }
                           
                           if (acc.Total_activos__c != personaNatural.personaNaturalOut.totalActivos) {
                               system.debug('acc.Total_activos__c: ' + acc.Total_activos__c + ' - personaNatural.personaNaturalOut.totalActivos: ' + personaNatural.personaNaturalOut.totalActivos);
                           }
                           
                           if (acc.Phone != personaNatural.personaNaturalOut.telefonoOficina) {
                               system.debug('acc.Phone: ' + acc.Phone + ' - personaNatural.personaNaturalOut.telefonoOficina: ' + personaNatural.personaNaturalOut.telefonoOficina);
                           }
                           
                           if (acc.Telefono_domicilio__c != personaNatural.personaNaturalOut.telefonoDomicilio) {
                               system.debug('acc.Telefono_domicilio__c: ' + acc.Telefono_domicilio__c + ' - personaNatural.personaNaturalOut.telefonoDomicilio: ' + personaNatural.personaNaturalOut.telefonoDomicilio);
                           }
                           
                           if (acc.Telefono_celular__c != personaNatural.personaNaturalOut.telefonoCelular) {
                               system.debug('acc.Telefono_celular__c: ' + acc.Telefono_celular__c + ' - personaNatural.personaNaturalOut.telefonoCelular: ' + personaNatural.personaNaturalOut.telefonoCelular);
                           }
                           
                           if (acc.PrimerNombre__c != personaNatural.personaNaturalOut.primerNombre) {
                               system.debug('acc.PrimerNombre__c: ' + acc.PrimerNombre__c + ' - personaNatural.personaNaturalOut.primerNombre: ' + personaNatural.personaNaturalOut.primerNombre);
                           }
                           
                           if (acc.SegundoNombre__c != personaNatural.personaNaturalOut.segundoNombre) {
                               system.debug('acc.SegundoNombre__c: ' + acc.SegundoNombre__c + ' - personaNatural.personaNaturalOut.segundoNombre: ' + personaNatural.personaNaturalOut.segundoNombre);
                           }
                           
                           if (acc.PrimerApellido__c != personaNatural.personaNaturalOut.primerApellido) {
                               system.debug('acc.PrimerApellido__c: ' + acc.PrimerApellido__c + ' - personaNatural.personaNaturalOut.primerApellido: ' + personaNatural.personaNaturalOut.primerApellido);
                           }
                           
                           if (acc.SegundoApellido__c != personaNatural.personaNaturalOut.segundoApellido) {
                               system.debug('acc.SegundoApellido__c: ' + acc.SegundoApellido__c + ' - personaNatural.personaNaturalOut.segundoApellido: ' + personaNatural.personaNaturalOut.segundoApellido);
                           }
                           
                           if (acc.Referencia_direccion_domicilio__c != personaNatural.personaNaturalOut.referenciaDireccionDomicilio) {
                               system.debug('acc.Referencia_direccion_domicilio__c: ' + acc.Referencia_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.referenciaDireccionDomicilio: ' + personaNatural.personaNaturalOut.referenciaDireccionDomicilio);
                           }
                           
                           if (acc.Politicamente_expuesto__c != personaNatural.personaNaturalOut.politicamenteExpuesto) {
                               system.debug('acc.Politicamente_expuesto__c: ' + acc.Politicamente_expuesto__c + ' - personaNatural.personaNaturalOut.politicamenteExpuesto: ' + personaNatural.personaNaturalOut.politicamenteExpuesto);
                           }
                           
                           if (acc.Paga_impuestos__c != personaNatural.personaNaturalOut.pagaImpuestos) {
                               system.debug('acc.Paga_impuestos__c: ' + acc.Paga_impuestos__c + ' - personaNatural.personaNaturalOut.pagaImpuestos: ' + personaNatural.personaNaturalOut.pagaImpuestos);
                           }
                           
                           if (acc.Numero_de_cuenta_bancaria__c != personaNatural.personaNaturalOut.numeroCuentaBancaria) {
                               system.debug('acc.Numero_de_cuenta_bancaria__c: ' + acc.Numero_de_cuenta_bancaria__c + ' - personaNatural.personaNaturalOut.numeroCuentaBancaria: ' + personaNatural.personaNaturalOut.numeroCuentaBancaria);
                           }
                           
                           if (acc.Calle_principal_direccion_trabajo__c != personaNatural.personaNaturalOut.lugarTrabajo) {
                               system.debug('acc.Calle_principal_direccion_trabajo__c: ' + acc.Calle_principal_direccion_trabajo__c + ' - personaNatural.personaNaturalOut.lugarTrabajo: ' + personaNatural.personaNaturalOut.lugarTrabajo);
                           }
                           
                           if (acc.Numero_de_identificacion__c != personaNatural.personaNaturalOut.identificacion) {
                               system.debug('acc.Numero_de_identificacion__c: ' + acc.Numero_de_identificacion__c + ' - personaNatural.personaNaturalOut.identificacion: ' + personaNatural.personaNaturalOut.identificacion);
                           }
                           
                           if (acc.Genero__c != personaNatural.personaNaturalOut.genero) {
                               system.debug('acc.Genero__c: ' + acc.Genero__c + ' - personaNatural.personaNaturalOut.genero: ' + personaNatural.personaNaturalOut.genero);
                           }
                           
                           if (String.valueOf(acc.Fecha_de_nacimiento__c)  !=  personaNatural.personaNaturalOut.fechaNacimiento) {
                               system.debug('acc.Fecha_de_nacimiento__c: ' +String.valueOf(acc.Fecha_de_nacimiento__c)+ '- date.valueOf(personaNatural.personaNaturalOut.fechaNacimiento): ' + personaNatural.personaNaturalOut.fechaNacimiento);
                           }
                           
                           if (acc.Es_direccion_fiscal_direccion_domicilio__c != personaNatural.personaNaturalOut.esDireccionFiscalDireccionDomicilio) {
                               system.debug('acc.Es_direccion_fiscal_direccion_domicilio__c: ' + acc.Es_direccion_fiscal_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.esDireccionFiscalDireccionDomicilio: ' + personaNatural.personaNaturalOut.esDireccionFiscalDireccionDomicilio);
                           }
                           
                           if (acc.Correo_electronico__c != correo_principal) {
                               system.debug('acc.Correo_electronico__c: ' + acc.Correo_electronico__c + ' -correo_principal: ' + correo_principal);
                           }
                           
                           if (acc.Tipo_de_identificacion__c != personaNatural.personaNaturalOut.codigoTipoIdentificacion) {
                               system.debug('acc.Tipo_de_identificacion__c: ' + acc.Tipo_de_identificacion__c + ' - personaNatural.personaNaturalOut.codigoTipoIdentificacion: ' + personaNatural.personaNaturalOut.codigoTipoIdentificacion);
                           }
                           
                           if (acc.Tipo_de_empleo__c != personaNatural.personaNaturalOut.codigoTipoEmpleo) {
                               system.debug('acc.Tipo_de_empleo__c: ' + acc.Tipo_de_empleo__c + ' - personaNatural.personaNaturalOut.codigoTipoEmpleo: ' + personaNatural.personaNaturalOut.codigoTipoEmpleo);
                           }
                           
                           if (acc.Tipo_de_cuenta_bancaria__c != personaNatural.personaNaturalOut.codigoTipoCuentaBancaria) {
                               system.debug('acc.Tipo_de_cuenta_bancaria__c: ' + acc.Tipo_de_cuenta_bancaria__c + ' - personaNatural.personaNaturalOut.codigoTipoCuentaBancaria: ' + personaNatural.personaNaturalOut.codigoTipoCuentaBancaria);
                           }
                           
                           if (acc.Estado_civil__c != personaNatural.personaNaturalOut.codigoEstadoCivil) {
                               system.debug('acc.Estado_civil__c: ' + acc.Estado_civil__c + ' - personaNatural.personaNaturalOut.codigoEstadoCivil: ' + personaNatural.personaNaturalOut.codigoEstadoCivil);
                           }
                           
                           if (acc.ANEFI_work_position__c != personaNatural.personaNaturalOut.cargo) {
                               system.debug('acc.ANEFI_work_position__c: ' + acc.ANEFI_work_position__c + ' - personaNatural.personaNaturalOut.cargo: ' + personaNatural.personaNaturalOut.cargo);
                           }
                           
                           if (acc.Calle_principal_direccion_domicilio__c != personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio) {
                               system.debug('acc.Calle_principal_direccion_domicilio__c: ' + acc.Calle_principal_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio: ' + personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio);
                           }
                          
                          
                          if(acc.Secuencia_canton_de_nacimiento__c != personaNatural.personaNaturalOut.secuenciaCantonNacimiento){
                              system.debug('acc.Secuencia_canton_de_nacimiento__c: ' + acc.Secuencia_canton_de_nacimiento__c + ' - personaNatural.personaNaturalOut.secuenciaCantonNacimiento: ' + personaNatural.personaNaturalOut.secuenciaCantonNacimiento);
                              
                              
                          }
                          if(acc.Secuencia_canton_direccion_domicilio__c != personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio){
                              
                              system.debug('acc.Secuencia_canton_direccion_domicilio__c: ' + acc.Secuencia_canton_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio: ' + personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio);
                              
                              
                          }
      
                                              
                          if(acc.Codigo_actividad_economica__c != ((personaNatural.personaNaturalOut.codigoTipoActividadEconomica ) == ''? null : (personaNatural.personaNaturalOut.codigoTipoActividadEconomica ) )){
                              
                              system.debug('acc.Codigo_actividad_economica__c: ' + acc.Codigo_actividad_economica__c + ' - personaNatural.personaNaturalOut.codigoTipoActividadEconomica: ' + personaNatural.personaNaturalOut.codigoTipoActividadEconomica);
                              
                              
                          }
                          if(acc.Codigo_provincia_de_nacimiento__c != ((personaNatural.personaNaturalOut.codigoProvinciaNacimiento )== ''? null: (personaNatural.personaNaturalOut.codigoProvinciaNacimiento ) ) ){
                              system.debug('acc.Codigo_provincia_de_nacimiento__c: ' + acc.Codigo_provincia_de_nacimiento__c + ' - personaNatural.personaNaturalOut.codigoProvinciaNacimiento: ' + personaNatural.personaNaturalOut.codigoProvinciaNacimiento);
                              
                              
                          }
                          if(acc.Codigo_provincia_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio) == ''? null: (personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio) ) ){
                              system.debug('acc.Codigo_provincia_direccion_domicilio__c: ' + acc.Codigo_provincia_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio: ' + personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio);
                              
                              
                          }
                          if(acc.Codigo_pais_nacionalidad__c != ((personaNatural.personaNaturalOut.codigoPaisNacionalidad) == ''? null: (personaNatural.personaNaturalOut.codigoPaisNacionalidad) ) ){
                              system.debug('acc.Codigo_pais_nacionalidad__c: ' + acc.Codigo_pais_nacionalidad__c + ' - personaNatural.personaNaturalOut.codigoPaisNacionalidad: ' + personaNatural.personaNaturalOut.codigoPaisNacionalidad);
                              
                              
                          }
                          if(acc.Codigo_pais_de_nacimiento__c != ((personaNatural.personaNaturalOut.codigoPaisNacimiento ) == '' ? null: (personaNatural.personaNaturalOut.codigoPaisNacimiento) )){
                              system.debug('acc.Codigo_pais_de_nacimiento__c: ' + acc.Codigo_pais_de_nacimiento__c + ' - personaNatural.personaNaturalOut.codigoPaisNacimiento: ' + personaNatural.personaNaturalOut.codigoPaisNacimiento);
                              
                              
                          }
                          if(acc.Codigo_pais_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio) == '' ?  null : (personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio) ) ){
                              system.debug('acc.Codigo_pais_direccion_domicilio__c: ' + acc.Codigo_pais_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio: ' + personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio);
                              
                              
                          }
                          if(acc.Entidad_Financiera__r.Name  != ((personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria) == '' ? null: (personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria))){
                              system.debug('acc.Entidad_Financiera__r.Name: ' + acc.Entidad_Financiera__r.Name + ' - personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria: ' + personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria);
                              
                              
                          }
                          if(acc.Codigo_canton_nacimiento__c != ((personaNatural.personaNaturalOut.codigoCantonNacimiento) == '' ? null: (personaNatural.personaNaturalOut.codigoCantonNacimiento))){
                              system.debug('acc.Codigo_canton_nacimiento__c: ' + acc.Codigo_canton_nacimiento__c + ' - personaNatural.personaNaturalOut.codigoCantonNacimiento: ' + personaNatural.personaNaturalOut.codigoCantonNacimiento);
                              
                              
                          }
                          if(acc.Codigo_canton_direccion_domicilio__c != ((personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio) == ''? null: (personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio))){
                              system.debug('acc.Codigo_canton_direccion_domicilio__c: ' + acc.Codigo_canton_direccion_domicilio__c + ' - personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio: ' + personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio);
                              
                          }
                          
                           */
                           system.debug('SYNC Natural falso');
                           
                           updated = false;
                           
                       }
                    
                }
                
            }
            
            system.debug('Acc '+JSON.serialize(acc ));        
            
            if(acc.ANEFI_actualizado_en_Gestor__c != updated){
                acc.ANEFI_actualizado_en_Gestor__c = updated ;
                update acc;
            }
            
        }catch(Exception e){
            system.debug('Exception '+e);
            acc.ANEFI_actualizado_en_Gestor__c = false;
            update acc;
            
            return false;
            
        }
        
        
        
        return updated;        
    }
    
    
    @future(callout=true) 
    public static void updateFieldsToGestor (String accId, String accCodGestor) {
        system.debug('---------------------Future method UPDATE FIELDS------------------ ');       
        String response = ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestor(accId, accCodGestor); 
        system.debug('Respuesta servicio de actualizacion '+response);
        if(response == '204'){
            Account cliente = [SELECT Id, ANEFI_actualizado_en_Gestor__c FROM Account WHERE Id = :accId];
            cliente.ANEFI_actualizado_en_Gestor__c = true;
            update cliente;
        }
    }
    
    @AuraEnabled()
    public static Account consultarClienteExistePorIdentificacion(string identificacion, string tipoIdentificacion, string tipoCliente){
        
        Account newAccount = new Account();
                        
        if(tipoCliente == recordTypeIdPersonaJuridica){
            //Check persona juridica ya existe existe en gestor
            list<Account> personaJuridicaCRM = [Select id, Codigo_persona_en_Gestor__c from Account where recordtypeId =:recordTypeIdPersonaJuridica and  Tipo_de_identificacion__c =:tipoIdentificacion and Numero_de_identificacion__c =: identificacion ];
            
            ANEFI_ServicesDTO.ConsultaPersonaJuridica newpersonaJuridica = ANEFI_GestionarParticipeGestor.consultarClienteNumeroIdentificacionJuridico(identificacion, tipoIdentificacion) ;
            
            system.debug('Consulta en CRM '+personaJuridicaCRM);
            system.debug('Consulta en Gestor '+newpersonaJuridica);
            
            if(newpersonaJuridica != null && newpersonaJuridica.personaJuridicaOut != null){
                //EXISTE EN GESTOR
                /*
                if (personaJuridicaCRM.size() > 0) {
                    //EXISTE EN CRM
                    if(personaJuridicaCRM[0].Codigo_persona_en_Gestor__c == newpersonaJuridica.codigoPersonaEnGestor){
                        throw new AuraHandledException('La cuenta ya existe en Salesforce y está sincronizada con Gestor');  
                    }
                }else{ */
                    system.debug(JSON.serialize(newpersonaJuridica.personaJuridicaOut));
                    return newAccount;
                //}
                
            }else{
                throw new AuraHandledException('La cuenta no existe en Gestor');  
            }
            
            
            
            
        }else{
            if(tipoCliente == recordTypeIdPersonaNatural){
                
                list<Account> personaNaturalCRM = [Select id, Codigo_persona_en_Gestor__c from Account where recordtypeId =:recordTypeIdPersonaNatural and  Tipo_de_identificacion__c =:tipoIdentificacion and Numero_de_identificacion__c =: identificacion];
                
                
                ANEFI_ServicesDTO.ConsultaPersonaNatural newPersonaNatural = ANEFI_GestionarParticipeGestor.consultarClienteNumeroIdentificacionNatural(identificacion, tipoIdentificacion);
                
                system.debug('Consulta en CRM '+personaNaturalCRM);
                system.debug('newPersonaNatural final '+newPersonaNatural);
                
                if(newPersonaNatural != null && newPersonaNatural.personaNaturalOut != null){
                    //EXISTE EN GESTOR
                    
                    /* if (personaNaturalCRM.size()>0) {
                    //EXISTE EN CRM
                    if(personaNaturalCRM[0].Codigo_persona_en_Gestor__c == newPersonaNatural.codigoPersonaEnGestor){
                    throw new AuraHandledException('La cuenta ya existe en Salesforce y está sincronizada con Gestor');  
                    }
                    }else{ */
                    
                    system.debug(JSON.serialize(newPersonaNatural.personaNaturalOut) );
                    return newAccount;
                    //}
                    
                }else{
                    throw new AuraHandledException('La cuenta no existe en Gestor');  
                }   
            }
        }
        
        
        return newAccount;
    }
    
    
    @AuraEnabled()
    public static String parseInformacionPersonaJuridicaEnGestorJson(String clienteId){    
        try{
            
            ANEFI_ServicesDTO.ConsultaPersonaJuridica personaJuridica = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaJuridicaEnGestor(clienteId);        
            
            Account cliente = new Account();
            cliente.id = clienteId;        
            cliente.Total_pasivos__c = personaJuridica.personaJuridicaOut.totalPasivos; 
            cliente.AnnualRevenue = personaJuridica.personaJuridicaOut.totalIngresos;
            cliente.Total_gastos__c = personaJuridica.personaJuridicaOut.totalGastos;
            cliente.Total_activos__c = personaJuridica.personaJuridicaOut.totalActivos;
            cliente.Tipo_de_persona_juridica__c = personaJuridica.personaJuridicaOut.codigoTipoPersonaJuridica;
            cliente.Phone = personaJuridica.personaJuridicaOut.telefonoConvencional;     
            cliente.Telefono_celular__c = personaJuridica.personaJuridicaOut.telefonoCelular;
            cliente.Name = personaJuridica.personaJuridicaOut.razonSocial;  
            cliente.Politicamente_expuesto__c = personaJuridica.personaJuridicaOut.politicamenteExpuesto;
            cliente.Description = personaJuridica.personaJuridicaOut.observaciones;
            cliente.Numero_direccion_trabajo__c = personaJuridica.personaJuridicaOut.numeroDireccionTrabajo;
            cliente.Numero_direccion_tributaria__c = personaJuridica.personaJuridicaOut.numeroDireccionResidenciaTributaria;
            cliente.Numero_de_cuenta_bancaria__c = personaJuridica.personaJuridicaOut.numeroCuentaBancaria;
            cliente.Interseccion_direccion_trabajo__c = personaJuridica.personaJuridicaOut.interseccionDireccionTrabajo;
            cliente.Interseccion_direccion_tributaria__c = personaJuridica.personaJuridicaOut.interseccionDireccionResidenciaTributaria;
            cliente.Numero_de_identificacion__c = personaJuridica.personaJuridicaOut.identificacion;
            cliente.Fecha_de_constitucion__c = ( personaJuridica.personaJuridicaOut.fechaConstitucion != null ? date.valueOf(personaJuridica.personaJuridicaOut.fechaConstitucion) : null );        
            cliente.Tipo_de_identificacion__c = personaJuridica.personaJuridicaOut.codigoTipoIdentificacion;
            cliente.Tipo_de_cuenta_bancaria__c = personaJuridica.personaJuridicaOut.codigoTipoCuentaBancaria;
            cliente.Cargo_representante_legal__c = personaJuridica.personaJuridicaOut.cargoRepresentanteLegal;
            cliente.Capital_social__c = personaJuridica.personaJuridicaOut.capitalSocial;
            cliente.Calle_principal_direccion_trabajo__c = personaJuridica.personaJuridicaOut.callePrincipalDireccionTrabajo;
            cliente.Calle_principal_direccion_tributaria__c = personaJuridica.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria;
            
            if(personaJuridica.personaJuridicaOut.direccionesElectronicas != null){
                for(integer i=0 ; i<personaJuridica.personaJuridicaOut.direccionesElectronicas.size();i++){
                    if(personaJuridica.personaJuridicaOut.direccionesElectronicas[i].principal == 'S'){
                        cliente.Correo_electronico__c = personaJuridica.personaJuridicaOut.direccionesElectronicas[i].correoElectronico;
                    }
                }
            }
            
            //-nuevos campos a mapear con obj relacionados a cuenta               
            
            //Entidad Financiera  
            if( (personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria != null && personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria != '' ) && (personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria != null || personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria != '' )){
                list<ANEFI_Entidad_financiera__c> entidadFinancieraMap = [Select id, Codigo_fiducia__c, Nombre__c, Name, Numero_de_cuenta__c, Tipo_de_entidad__c  from ANEFI_Entidad_financiera__c where Tipo_de_entidad__c= : Integer.valueOf(personaJuridica.personaJuridicaOut.codigoTipoEntidadFinancieraCuentaBancaria) and name =: personaJuridica.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria ]; 
                if(entidadFinancieraMap.size()>0){
                    for(ANEFI_Entidad_financiera__c item : entidadFinancieraMap){
                        cliente.Entidad_financiera__c = item.Id;
                    }                
                }
            }else{
                 cliente.Entidad_financiera__c = null;
            }       
            
            if(personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica != null && personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica != ''){
                //Actividad Economica            
                list<ANEFI_Actividad_Economica__c> actividadEconomicaMap = [Select id, name from ANEFI_Actividad_Economica__c where name =: personaJuridica.personaJuridicaOut.codigoTipoActividadEconomica]; 
                if(actividadEconomicaMap.size()>0){
                    for(ANEFI_Actividad_Economica__c item : actividadEconomicaMap){
                        cliente.Actividad_Economica__c = item.Id;
                    }                
                }  
            }else{
                cliente.Actividad_Economica__c = null;
            }
         
            
            //Nacionalidad
            if(personaJuridica.personaJuridicaOut.codigoPaisNacionalidad != null && personaJuridica.personaJuridicaOut.codigoPaisNacionalidad != ''){
                list<ANEFI_Pais__c> nacionalidadMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c where Codigo_Pais__c =: personaJuridica.personaJuridicaOut.codigoPaisNacionalidad]; 
                if(nacionalidadMap.size()>0){
                    for(ANEFI_Pais__c item : nacionalidadMap){
                        cliente.Nacionalidad__c = item.Id;
                    }                
                }
            }else{
               cliente.Nacionalidad__c = null; 
            }
          
            
            //País dirección trabajo
            if(personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo != null && personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo != ''){
                list<ANEFI_Pais__c> paisDireccionTrabajoMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c where Codigo_Pais__c =: personaJuridica.personaJuridicaOut.codigoPaisDireccionTrabajo]; 
                if(paisDireccionTrabajoMap.size()>0){
                    for(ANEFI_Pais__c item : paisDireccionTrabajoMap){
                        cliente.Pais_direccion_trabajo__c = item.Id;
                    }                
                }
            }else{
                cliente.Pais_direccion_trabajo__c = null;
            }
            
            
            //País dirección tributaria
            if(personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria != null && personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria != ''){
                list<ANEFI_Pais__c> paisDireccionTributariaMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c where Codigo_Pais__c =: personaJuridica.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria]; 
                if(paisDireccionTributariaMap.size()>0){
                    for(ANEFI_Pais__c item : paisDireccionTributariaMap){
                        cliente.Pais_direccion_tributaria__c = item.Id;
                    }                
                }
            }else{
                cliente.Pais_direccion_tributaria__c  = null;
            }
            
            
            //Canton direccion trabajo
            if(personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo != null && personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo != ''){
                list<ANEFI_Canton__c> cantonDireccionTrabajoMap = [Select id, Name from ANEFI_Canton__c where Name =: personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionTrabajo]; 
                if(cantonDireccionTrabajoMap.size()>0){
                    for(ANEFI_Canton__c item : cantonDireccionTrabajoMap){
                        cliente.Canton_direccion_de_trabajo__c = item.Id;
                    }                
                }
            }else{
                cliente.Canton_direccion_de_trabajo__c = null;
            }
            
            
            //Canton direccion tributaria
            if(personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria != null && personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria != ''){
                list<ANEFI_Canton__c> cantonDireccionTributariaMap = [Select id, Name from ANEFI_Canton__c where Name =: personaJuridica.personaJuridicaOut.codigoOrgGeoDireccionResidenciaTributaria]; 
                if(cantonDireccionTributariaMap.size()>0){
                    for(ANEFI_Canton__c item : cantonDireccionTributariaMap){
                        cliente.Canton_direccion_tributaria__c = item.Id;
                    }                
                }      
            }else{
                cliente.Canton_direccion_tributaria__c  = null;
            }
                                       
            
            update cliente;                        
            
            return JSON.serialize(personaJuridica);
        }  catch(Exception e){
            system.debug('data exception '+e);   
            throw new AuraHandledException('No se pudo actualizar el cliente desde gestor, comuníquese con su administrador');
        }
        
    }
    
    @AuraEnabled()
    public static String parseInformacionPersonaNaturalEnGestorJson(String clienteId){  
        try{
            ANEFI_ServicesDTO.ConsultaPersonaNatural personaNatural = ANEFI_GestionarParticipeGestor.consultarInformacionPersonaNaturalEnGestor(clienteId);  
            
            Account cliente = new Account();
            cliente.id = clienteId;
            cliente.Ingresos_mensuales__c = personaNatural.personaNaturalOut.valorIngresosSueldoMensual;    
            cliente.Total_gastos__c = personaNatural.personaNaturalOut.valorGastoMensual;
            cliente.Total_patrimonio__c = personaNatural.personaNaturalOut.totalPatrimonio;
            cliente.Total_pasivos__c = personaNatural.personaNaturalOut.totalPasivos;
            cliente.ANEFI_Monthly_expenses__c = personaNatural.personaNaturalOut.totalEgresosMensuales;
            cliente.Total_activos__c = personaNatural.personaNaturalOut.totalActivos;        
            cliente.Phone = personaNatural.personaNaturalOut.telefonoOficina;
            cliente.Telefono_domicilio__c = personaNatural.personaNaturalOut.telefonoDomicilio;
            cliente.Telefono_celular__c = personaNatural.personaNaturalOut.telefonoCelular;        
            cliente.PrimerNombre__c = personaNatural.personaNaturalOut.primerNombre;
            cliente.SegundoNombre__c = personaNatural.personaNaturalOut.segundoNombre;
            cliente.PrimerApellido__c = personaNatural.personaNaturalOut.primerApellido;
            cliente.SegundoApellido__c = personaNatural.personaNaturalOut.segundoApellido;        
            cliente.Referencia_direccion_domicilio__c = personaNatural.personaNaturalOut.referenciaDireccionDomicilio;        
            cliente.Politicamente_expuesto__c = personaNatural.personaNaturalOut.politicamenteExpuesto;
            cliente.Paga_impuestos__c = personaNatural.personaNaturalOut.pagaImpuestos;
            cliente.Numero_de_cuenta_bancaria__c = personaNatural.personaNaturalOut.numeroCuentaBancaria;
            cliente.Calle_principal_direccion_trabajo__c = personaNatural.personaNaturalOut.lugarTrabajo;
            cliente.Numero_de_identificacion__c = personaNatural.personaNaturalOut.identificacion;
            cliente.Genero__c = personaNatural.personaNaturalOut.genero;
            cliente.Fecha_de_nacimiento__c = ( personaNatural.personaNaturalOut.fechaNacimiento != null ? date.valueOf(personaNatural.personaNaturalOut.fechaNacimiento) : null );
            cliente.Es_direccion_fiscal_direccion_domicilio__c = personaNatural.personaNaturalOut.esDireccionFiscalDireccionDomicilio;
            
            if(personaNatural.personaNaturalOut.direccionesElectronicas != null){
                for(integer i=0 ; i<personaNatural.personaNaturalOut.direccionesElectronicas.size();i++){
                    if(personaNatural.personaNaturalOut.direccionesElectronicas[i].principal == 'S'){
                        cliente.Correo_electronico__c = personaNatural.personaNaturalOut.direccionesElectronicas[i].correoElectronico;
                    }
                }
            }
            
            
            cliente.Tipo_de_identificacion__c = personaNatural.personaNaturalOut.codigoTipoIdentificacion;
            cliente.Tipo_de_empleo__c = personaNatural.personaNaturalOut.codigoTipoEmpleo;   
            cliente.Tipo_de_cuenta_bancaria__c = personaNatural.personaNaturalOut.codigoTipoCuentaBancaria;   
            cliente.Estado_civil__c = personaNatural.personaNaturalOut.codigoEstadoCivil;    
            cliente.ANEFI_work_position__c = personaNatural.personaNaturalOut.cargo;
            cliente.Calle_principal_direccion_domicilio__c = personaNatural.personaNaturalOut.callePrincipalDireccionDomicilio;  
            
            //-nuevos campos a mapear con obj relacionados a cuenta 

            //
            if( (personaNatural.personaNaturalOut.secuenciaCantonNacimiento == null )  || 
               (personaNatural.personaNaturalOut.codigoProvinciaNacimiento == null || personaNatural.personaNaturalOut.codigoProvinciaNacimiento == '' )||
               (personaNatural.personaNaturalOut.codigoCantonNacimiento == null || personaNatural.personaNaturalOut.codigoCantonNacimiento == '')){
                   cliente.Canton_de_nacimiento__c = null;
               }
            if( (personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio == null ) ||
               (personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio == null || personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio == '' )||
               (personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio == null || personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio == '')){
                   cliente.Canton_direccion_domicilio__c  = null;
               }
            
            if(personaNatural.personaNaturalOut.codigoTipoActividadEconomica == null || personaNatural.personaNaturalOut.codigoTipoActividadEconomica == ''){
                cliente.Actividad_Economica__c = null;
            }
            
            if( (personaNatural.personaNaturalOut.codigoPaisNacionalidad == null || personaNatural.personaNaturalOut.codigoPaisNacionalidad == '' )||
               (	personaNatural.personaNaturalOut.codigoPaisNacimiento == null || personaNatural.personaNaturalOut.codigoPaisNacimiento == '')){
                   cliente.Nacionalidad__c = null;
               }
            
            if( personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio == null ){
                   cliente.Pais_direccion_domicilio__c  = null;
               }
            
            //Secuencia canton nacimiento         
            list<ANEFI_Canton__c> secuenciaCantonNacimientoMap = [Select id, Secuencia__c from ANEFI_Canton__c  where Secuencia__c =: personaNatural.personaNaturalOut.secuenciaCantonNacimiento]; 
            if(secuenciaCantonNacimientoMap.size()>0){
                for(ANEFI_Canton__c item : secuenciaCantonNacimientoMap){
                    cliente.Canton_de_nacimiento__c = item.Id;
                }                
            }
            
            //Secuencia canton direccion domicilio       
            list<ANEFI_Canton__c> secuenciaCantonDomicilioMap = [Select id, Secuencia__c from ANEFI_Canton__c  where Secuencia__c =: personaNatural.personaNaturalOut.secuenciaCantonDireccionDomicilio]; 
            if(secuenciaCantonDomicilioMap.size()>0){
                for(ANEFI_Canton__c item : secuenciaCantonDomicilioMap){
                    cliente.Canton_direccion_domicilio__c = item.Id;
                }                
            }
            
            //Actividad Economica            
            list<ANEFI_Actividad_Economica__c> actividadEconomicaMap = [Select id, name from ANEFI_Actividad_Economica__c where name =: personaNatural.personaNaturalOut.codigoTipoActividadEconomica]; 
            if(actividadEconomicaMap.size()>0){
                for(ANEFI_Actividad_Economica__c item : actividadEconomicaMap){
                    cliente.Actividad_Economica__c = item.Id;
                }                
            }
            
            //provincia Nacimiento
            list<ANEFI_Canton__c> provinciaNacimientoMap = [Select id, Codigo_provincia__c from ANEFI_Canton__c  where Codigo_provincia__c =: personaNatural.personaNaturalOut.codigoProvinciaNacimiento]; 
            if(provinciaNacimientoMap.size()>0){
                for(ANEFI_Canton__c item : provinciaNacimientoMap){
                    cliente.Canton_de_nacimiento__c = item.Id;
                }                
            }
            
            //provincia direccion domicilio
            list<ANEFI_Canton__c> provinciaDireccionDomicilioMap = [Select id, Codigo_provincia__c from ANEFI_Canton__c  where Codigo_provincia__c =: personaNatural.personaNaturalOut.codigoProvinciaDireccionDomicilio]; 
            if(provinciaDireccionDomicilioMap.size()>0){
                for(ANEFI_Canton__c item : provinciaDireccionDomicilioMap){
                    cliente.Canton_direccion_domicilio__c = item.Id;
                }                
            }
            
            //Nacionalidad
            list<ANEFI_Pais__c> nacionalidadMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c where Codigo_Pais__c =: personaNatural.personaNaturalOut.codigoPaisNacionalidad]; 
            if(nacionalidadMap.size()>0){
                for(ANEFI_Pais__c item : nacionalidadMap){
                    cliente.Nacionalidad__c = item.Id;
                }                
            }
            
            //Nacimiento
            list<ANEFI_Pais__c> nacimientoMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c where Codigo_Pais__c =: personaNatural.personaNaturalOut.codigoPaisNacimiento]; 
            if(nacimientoMap.size()>0){
                for(ANEFI_Pais__c item : nacimientoMap){
                    cliente.Nacionalidad__c = item.Id;
                }                
            }
            
            //Direccion domicilio       
            list<ANEFI_Pais__c> direccionCantonDomicilioMap = [Select id, Codigo_Pais__c from ANEFI_Pais__c  where Codigo_Pais__c =: personaNatural.personaNaturalOut.codigoPaisDireccionDomicilio]; 
            if(direccionCantonDomicilioMap.size()>0){
                for(ANEFI_Pais__c item : direccionCantonDomicilioMap){
                    cliente.Pais_direccion_domicilio__c = item.Id;
                }                
            }
            
            //Entidad Financiera         
            if(personaNatural.personaNaturalOut.codigoTipoEntidadFinancieraCuentaBancaria != null && personaNatural.personaNaturalOut.codigoTipoEntidadFinancieraCuentaBancaria != '' && 
               personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria != null && personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria != ''){
                list<ANEFI_Entidad_financiera__c> entidadFinancieraMap = [Select id, Codigo_fiducia__c, Nombre__c, Name, Numero_de_cuenta__c, Tipo_de_entidad__c  from ANEFI_Entidad_financiera__c where Tipo_de_entidad__c= : Integer.valueOf(personaNatural.personaNaturalOut.codigoTipoEntidadFinancieraCuentaBancaria) and name =: personaNatural.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria ]; 
                if(entidadFinancieraMap.size()>0){
                    for(ANEFI_Entidad_financiera__c item : entidadFinancieraMap){
                        cliente.Entidad_financiera__c = item.Id;
                    }                
                }else{
                    cliente.Entidad_financiera__c = null;
                }
            } 
          
            
            //canton Nacimiento
            list<ANEFI_Canton__c> cantonNacimientoMap = [Select id, Name from ANEFI_Canton__c  where Name =: personaNatural.personaNaturalOut.codigoCantonNacimiento]; 
            if(cantonNacimientoMap.size()>0){
                for(ANEFI_Canton__c item : cantonNacimientoMap){
                    cliente.Canton_de_nacimiento__c = item.Id;
                }                
            }                        
            
            //Canton direccion domicilio       
            list<ANEFI_Canton__c> CantonDomicilioMap = [Select id, Name from ANEFI_Canton__c  where Name =: personaNatural.personaNaturalOut.codigoCantonDireccionDomicilio]; 
            if(CantonDomicilioMap.size()>0){
                for(ANEFI_Canton__c item : CantonDomicilioMap){
                    cliente.Canton_direccion_domicilio__c = item.Id;
                }                
            }
            
                            
            update cliente;
            return JSON.serialize(personaNatural);
        }  catch(Exception e){
            system.debug('data exception '+e);   
            throw new AuraHandledException('No se pudo actualizar el cliente desde gestor, comuníquese con su administrador');
        }
        
        
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