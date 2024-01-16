@isTest
global class ANEFI_MockupBuilderForTests {

    public static ANEFI_Entidad_financiera__c crearEntidadFinanciera(Boolean insertar){
        ANEFI_Entidad_financiera__c entidad = new ANEFI_Entidad_financiera__c();
        entidad.Name = 'ENTIDAD001';
        entidad.Codigo_fiducia__c = 'F001';
        if(insertar){
            insert entidad;
        }
        return entidad;
    }
    
    public static ANEFI_Actividad_Economica__c crearActividadEconomica(Boolean insertar){
        ANEFI_Actividad_Economica__c actividad = new ANEFI_Actividad_Economica__c();
        actividad.Name = 'ACTIVIDAD001';
        if(insertar){
            insert actividad;
        }
        return actividad;
    }

    public static ANEFI_Pais__c crearPais(Boolean insertar){
        ANEFI_Pais__c pais = new ANEFI_Pais__c();
        pais.Name = 'Pais Prueba';
        pais.Codigo_Pais__c = 'PAIS001';
        if(insertar){
            insert pais;
        }
        return pais;
    }

    public static ANEFI_Canton__c crearCanton(Boolean insertar){
        ANEFI_Canton__c canton = new ANEFI_Canton__c();
        canton.Name = 'CANTON001';
        canton.Nombre_canton__c = 'Canton Prueba';
        canton.Provincia__c = 'Provincia Prueba';
        canton.Codigo_provincia__c = 'PROVINCIA001';
        if(insertar){
            insert canton;
        }
        return canton;
    }

    public static Account crearClienteNatural(Boolean insertar){
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Natural' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'Cliente Natural Prueba';
        cuenta.PrimerNombre__c ='Prueba';
        cuenta.SegundoNombre__c = 'Cliente';
        cuenta.PrimerApellido__c = 'Anefi';
        cuenta.Tipo_de_identificacion__c = '1';
        cuenta.Numero_de_identificacion__c = '1234567890';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';

        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;

        if(insertar){
            System.debug('cuenta' + cuenta);
            insert cuenta;
        }

        return cuenta;
    }

    public static Account crearClienteJuridico(Boolean insertar){
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Jurídica' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'Cliente Jurídica Prueba';
        cuenta.Tipo_de_identificacion__c = '2';
        cuenta.Numero_de_identificacion__c = '1234567890123';
        cuenta.Fecha_de_constitucion__c = date.valueOf('2002-07-04');
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Activo__c = 'Activo';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Industry = 'Construcción e inmobiliario';
        cuenta.AnnualRevenue = 85522;
        cuenta.Total_activos__c = 1250;
        cuenta.Total_pasivos__c = 520;
        cuenta.Total_gastos__c = 30;
        if(insertar){
            insert cuenta;
        }

        return cuenta;
    }
    
    public static Contact crearContacto(Boolean insertar){
        Contact contacto = new Contact();
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Jurídica' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'Cliente Jurídica Prueba';
        cuenta.Tipo_de_identificacion__c = '2';
        cuenta.Numero_de_identificacion__c = '1234567890123';
        cuenta.Fecha_de_constitucion__c = date.valueOf('2002-07-04');
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Activo__c = 'Activo';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Industry = 'Construcción e inmobiliario';
        cuenta.AnnualRevenue = 85522;
        cuenta.Total_activos__c = 1250;
        cuenta.Total_pasivos__c = 520;
        cuenta.Total_gastos__c = 30;        
        insert cuenta;
        
        contacto.AccountId = cuenta.Id;
        contacto.FirstName = 'Juan';
        contacto.LastName = 'Cortes Domingeuz perez';
        contacto.Email = 'juan@cortes.com';
        insert contacto;        

        return contacto;
    }
    
    public static Account crearClienteExistenteEnGestor(Boolean insertar){
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Natural' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'Cliente Existente En Gestor';
        cuenta.PrimerNombre__c = 'Test';
        cuenta.PrimerApellido__c = 'test2';
        cuenta.Tipo_de_identificacion__c = '1';
        cuenta.Numero_de_identificacion__c = '1234567891';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;
        cuenta.Codigo_persona_en_Gestor__c = '1028437';

        if(insertar){
            insert cuenta;
        }

        return cuenta;
    }
    
    public static ANEFI_ServicesDTO.MovimientosCuentaParticipeInput crearMovimientosCuentaParticipeInput(){
        ANEFI_ServicesDTO.MovimientosCuentaParticipeInput movimientosCuentaParticipeInput = new ANEFI_ServicesDTO.MovimientosCuentaParticipeInput();
        movimientosCuentaParticipeInput.codigoProducto = 'F001';
        movimientosCuentaParticipeInput.codigoCliente = '1028437';
        movimientosCuentaParticipeInput.fechaDesde = '2020-08-01';
        movimientosCuentaParticipeInput.fechaHasta = '2020-08-01';
        movimientosCuentaParticipeInput.numeroCuenta = '10806';
        movimientosCuentaParticipeInput.pageNumber = 1;
        movimientosCuentaParticipeInput.pageSize = 10;
        movimientosCuentaParticipeInput.tipoTransaccion = 'aporte';
        return movimientosCuentaParticipeInput;
    }

    public static void inicializarANEFIConfiguracionGestorWeb(){
        ANEFI_Configuracion_Gestor_Web__c configuracion = new ANEFI_Configuracion_Gestor_Web__c();
        configuracion.Clave__c = 'GESTORGE';
        configuracion.Gestor_Token_App__c = 'anefi';
        configuracion.Gestor_Token_Env__c = 'cHJ1ZWJh';
        configuracion.Instancia__c = 'PRUEBAS';
        configuracion.URL__c = 'http://8.242.216.210:8100/gestor-api-rest';
        configuracion.Usuario__c = 'GESTOR';
        insert configuracion;
    }

    public static void inicializarANEFIAPIName(){
        List<ANEFI_API_Name__c> APIs = new List<ANEFI_API_Name__c>();

        APIs.add( new ANEFI_API_Name__c(name = 'consultaCuentasParticipe',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaMovimientosParticipe',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/movimientos'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaPersonaJuridica',URL_Name__c = '/gw/personas/{codigoPersona}/juridica'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaPersonaNatural',URL_Name__c = '/gw/personas/{codigoPersona}/natural'));
        APIs.add( new ANEFI_API_Name__c(name = 'login',URL_Name__c = '/nn/gw/autorizacion/login'));
        APIs.add( new ANEFI_API_Name__c(name = 'refreshToken',URL_Name__c = '/nn/gw/autorizacion/refreshToken'));
        APIs.add( new ANEFI_API_Name__c(name = 'registroAporte',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe/{numeroCuenta}/aportes'));
        APIs.add( new ANEFI_API_Name__c(name = 'registroCuentaParticipe',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe'));
        APIs.add( new ANEFI_API_Name__c(name = 'registroPersonaJuridica',URL_Name__c = '/gw/personas/juridica'));
        APIs.add( new ANEFI_API_Name__c(name = 'registroPersonaNatural',URL_Name__c = '/gw/personas/natural'));
        APIs.add( new ANEFI_API_Name__c(name = 'validacionListasNegras',URL_Name__c = '/gw/personas/validarListasNegras'));
        APIs.add( new ANEFI_API_Name__c(name = 'validacionRegistrosCliente',URL_Name__c = '/gw/personas/validarRegistrosCliente'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaSaldosParticipe',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/saldos'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaRendimientoCuenta',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe/{numeroCuenta}/valorRendimiento'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaRendimientoProducto',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/rendimiento'));
        APIs.add( new ANEFI_API_Name__c(name = 'actualizarPersonaNatural',URL_Name__c = '/gw/personas/{codigoPersona}/natural'));
        APIs.add( new ANEFI_API_Name__c(name = 'actualizarPersonaJuridica',URL_Name__c = '/gw/personas/{codigoPersona}/juridica'));
        APIs.add( new ANEFI_API_Name__c(name = 'registrarReferenciaBancaria',URL_Name__c = '/gw/personas/{codigoPersona}/referenciasBancarias'));
        APIs.add( new ANEFI_API_Name__c(name = 'actualizarReferenciaBancaria',URL_Name__c = '/gw/personas/{codigoPersona}/referenciasBancarias/{numeroCuenta}'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaSaldosCuentasParticipe',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/saldosParticipes'));
        APIs.add( new ANEFI_API_Name__c(name = 'registroRescate',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe/{numeroCuenta}/rescates'));
        APIs.add( new ANEFI_API_Name__c(name = 'cuentaReferenciaBancaria',URL_Name__c = '/gw/personas/{codigoPersonaGestor}/referenciasBancarias?codigoMoneda=1&estado=ACT'));
        APIs.add( new ANEFI_API_Name__c(name = 'cuentaReferenciaBancariaTerceros',URL_Name__c = '/gw/personas/{codigoPersonaGestor}/referenciasBancariasTerceros?codigoMoneda=1&estado=ACT'));
        APIs.add( new ANEFI_API_Name__c(name = 'cuentasBancarias',URL_Name__c = '/gw/empresas/-/productos/{codigoProducto}/cuentasBancarias?codigoMoneda=1&estado=ACT'));
        APIs.add( new ANEFI_API_Name__c(name = 'saldosDiariosPeriodo',URL_Name__c = '/gw/empresas/-/productos/F/participes/{codigoCliente}/saldosDiariosPorPeriodo'));
        APIs.add( new ANEFI_API_Name__c(name = 'valorRendimiento',URL_Name__c = '/gw/empresas/1/productos/{codigoProducto}/participes/{codigoParticipe}/cuentasParticipe/{cuentaParticipe}/valorRendimiento'));
        APIs.add( new ANEFI_API_Name__c(name = 'consultaConfiguracionMontos',URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/parametrosParticipacion/montos'));
        
        
        insert APIs;
    }
    
    public static ANEFI_ServicesDTO.RegistroReferenciaBancariaInput crearReferenciaBancariaInput(){
        ANEFI_ServicesDTO.RegistroReferenciaBancariaInput registroReferenciaBancariaInput = new ANEFI_ServicesDTO.RegistroReferenciaBancariaInput();
        ANEFI_Entidad_financiera__c entidadFinanciera = crearEntidadFinanciera(true);
        registroReferenciaBancariaInput.codigoEntidadFinanciera = entidadFinanciera.Id;
        registroReferenciaBancariaInput.codigoMoneda = '1';
        registroReferenciaBancariaInput.codigoTipoCuenta = 'A';
        registroReferenciaBancariaInput.codigoTipoEntidadFinanciera = '1111';
        registroReferenciaBancariaInput.estado = 'ACT';
        registroReferenciaBancariaInput.fechaIngreso = '2020-09-24';
        registroReferenciaBancariaInput.numeroCuenta = '1452333';
        registroReferenciaBancariaInput.observaciones = 'Creación de referencia bancaria';
        registroReferenciaBancariaInput.principal = 'S';
        
        return registroReferenciaBancariaInput;
    }
    
    public static Account crearClienteYContactoEnGestor(Boolean insertar){
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Natural' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'Cliente Existente En Gestor';
        cuenta.Tipo_de_identificacion__c = '1';
        cuenta.Numero_de_identificacion__c = '1234567891';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;
        cuenta.Codigo_persona_en_Gestor__c = '1028437'; 
        cuenta.Fecha_de_nacimiento__c = Date.today();
              
        insert cuenta;
        
        Contact contacto = new Contact();        
        contacto.AccountId = cuenta.id;
        contacto.FirstName = 'Milena';
        contacto.MiddleName = 'Andrea';
        contacto.LastName = 'Osorio Perez';
        contacto.Email = 'milena@perez.com';
        contacto.Phone = '+59342382808';
        contacto.Estado_civil__c = 'C';
        contacto.Tipo_de_identificacion__c = '1';
        contacto.Numero_de_identificacion__c = '1234567891';
        insert contacto;        

        return cuenta;
    }
    
    public static Account crearClienteJuridicoEnGestor(Boolean insertar){
        RecordType personaJuridicaRT = [SELECT id FROM RecordType WHERE Name='Persona Jurídica' AND SobjectType='Account' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaJuridicaRT.id;
        cuenta.Name = 'Cliente Jurídico';
        cuenta.Tipo_de_identificacion__c = '2';
        cuenta.Numero_de_identificacion__c = '1234567891986';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;
        cuenta.Codigo_persona_en_Gestor__c = '1028437';
        cuenta.Fecha_de_constitucion__c = Date.today();

        if(insertar){
            insert cuenta;
        }

        return cuenta;
    }
    
    public static Account crearClienteNaturalSoloNombre(Boolean insertar){
        RecordType personaNaturalRT = [SELECT id FROM RecordType WHERE Name='Persona Natural' AND SobjectType='Account' LIMIT 1];
        
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaNaturalRT.id;
        cuenta.Name = 'ClientePrueba';
        cuenta.Tipo_de_identificacion__c = '1';
        cuenta.Numero_de_identificacion__c = '1234567890';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';

        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;

        if(insertar){
            insert cuenta;
        }

        return cuenta;
    }
    
    public static Opportunity crearOportunidad(Boolean insertar){
        RecordType personaJuridicaRT = [SELECT id FROM RecordType WHERE Name='Persona Jurídica' AND SobjectType='Account' LIMIT 1];
        RecordType oportunidadJuridicaRT = [SELECT id FROM RecordType WHERE Name='Persona Jurídica' AND SobjectType='Opportunity' LIMIT 1];
        Account cuenta = new Account();
        cuenta.RecordTypeId = personaJuridicaRT.id;
        cuenta.Name = 'Cliente Jurídico';
        cuenta.Tipo_de_identificacion__c = '2';
        cuenta.Numero_de_identificacion__c = '1234567891986';
        cuenta.Telefono_celular__c = '+593984682687';
        cuenta.Phone = '+59342382808';
        cuenta.Correo_electronico__c = 'prueba@correo.com';
        cuenta.Estado_civil__c = 'S';
        cuenta.Genero__c = 'M';
        cuenta.ANEFI_Country__c = 'ECUADOR';
        cuenta.ANEFI_Province__c = 'GUAYAS';
        cuenta.Ciudad__c = 'GUAYAQUIL';
        cuenta.Activo__c = 'Activo';
        cuenta.Politicamente_expuesto__c = 'DIR';
        cuenta.Pais_direccion_domicilio__c = crearPais(true).id;
        cuenta.Canton_direccion_domicilio__c = crearCanton(true).id;
        cuenta.Codigo_persona_en_Gestor__c = '1028437';
        cuenta.Fecha_de_constitucion__c = Date.today();
        cuenta.Actividad_Economica__c = crearActividadEconomica(true).id;
        cuenta.Tipo_de_persona_juridica__c = '2';      
        cuenta.Nacionalidad__c = crearPais(true).id;
        cuenta.Total_activos__c = 10;
        cuenta.Total_pasivos__c = 12;
        cuenta.AnnualRevenue = 12;
        cuenta.Total_gastos__c = 12;
        cuenta.Entidad_financiera__c = crearEntidadFinanciera(true).Id;
        cuenta.Tipo_de_cuenta_bancaria__c = 'A';
        cuenta.Numero_de_cuenta_bancaria__c = '1221';
        cuenta.Pais_direccion_trabajo__c = crearPais(true).id;
        cuenta.Canton_direccion_de_trabajo__c = crearCanton(true).id;
        cuenta.Numero_direccion_trabajo__c = '1233';
        cuenta.Calle_principal_direccion_trabajo__c = '1221';
        cuenta.Interseccion_direccion_trabajo__c = '121212';        
        insert cuenta;
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.AccountId = cuenta.Id;
        oportunidad.RecordTypeId = oportunidadJuridicaRT.id;
        oportunidad.Name = 'Oportunidad fideicomiso';
        oportunidad.StageName = 'Cerrada ganada';
        oportunidad.Amount = 15;
        oportunidad.CloseDate = Date.today();
        oportunidad.Producto_de_Interes__c = 'F001';
        oportunidad.Cliente_hizo_el_pago__c = true;
        oportunidad.Firmo_el_contrato__c = true;
        oportunidad.Se_recopilo_cedula__c = true;
        oportunidad.Se_recopilo_nombramiento__c = true;
        oportunidad.Se_recopilo_RUC__c = true;
        oportunidad.Forma_de_Pago__c = 'CHEQ';
        oportunidad.Fecha_efectiva_primer_aporte__c = Date.today();        
        oportunidad.Numero_documento_deposito__c = '12312';
        oportunidad.Transaccion_cooparticipe__c = 'NO';
        oportunidad.Complementarios__c = 'N';
        oportunidad.Trader__c = '692212';
        oportunidad.Moneda__c = '1';
        oportunidad.Estado_sincronizacion_Gestor__c = 'ERROR SINCRONIZACIÓN';
        oportunidad.Tipo_de_registro_candidato__c = 'Persona Jurídica';
        insert oportunidad;        
        
        return oportunidad;
    }
    
    public static void crearUsuarioNotificacion(){
        ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion = new ANEFI_Usuario_notificacion_Gestor__c();
		usuarioNotificacion.Correo_electronico__c = 'prueba@prueba.com';        
        usuarioNotificacion.Nombre__c = 'administrador';      
        insert usuarioNotificacion;        
    }
    
    public static void inicializarANEFIParametrosEmpresa(){
        List<ANEFI_Parametros_Empresa__c> parametrosEmpresa = new List<ANEFI_Parametros_Empresa__c>();

        parametrosEmpresa.add( new ANEFI_Parametros_Empresa__c(name = 'Direccion_Quito',Valor__c= 'Direccion_Quito'));
        parametrosEmpresa.add( new ANEFI_Parametros_Empresa__c(name = 'Direccion_Guayaquil',Valor__c= 'Direccion_Guayaquil'));
        parametrosEmpresa.add( new ANEFI_Parametros_Empresa__c(name = 'Email_ANEFI',Valor__c= 'Email_ANEFI'));
        
        insert parametrosEmpresa;
    }

	   
}