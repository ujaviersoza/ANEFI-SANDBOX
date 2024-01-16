public class ANEFI_ServicesDTO {

    public class Oportunidad {
        public Id oportunidadId;
        public String tipoPersona;
        public Id clienteId;
        public Id propietarioId;
        public String oportunidadNombre;
        public Integer codigoPersonaEnGestor;
        public String numeroCuentaParticipe;
        public String codigoProducto;
        public String codigoTrader;
        public String codigoCuentaContable;
        public String complementarios;
        public String transaccionCooparticipe;
        public String numeroTransaccionAporte;
        public String fechaEfectiva;
        public String numeroDocumento;
        public String codigoTipoFormaPago;
        public String codigoMoneda;
        public String codigoTipoEntidadFondo;
        public String codigoEntidadFondo;
        public String numeroCuentaFondo;
        public Decimal monto;
    }
    
    /*DTO para almacenar la respuesta de la petición y el token en caso de que se haya hecho un reintento*/
    public class RequestsHandlerResponse{
        public HttpResponse response;
        public LoginOUT loginOUT;
    }
    
    /***********DTOS para servicio de autenticación en Gestor*******/
    public class LoginInput {
        public String usuario;
        public String clave;
    }
    
    public class ResponseDataLoginOut{
        public LoginOut data;
    }
    
    public class LoginOUT{
        @AuraEnabled
        public String tokenType;
        @AuraEnabled
        public String accessToken;
        @AuraEnabled
        public Integer expiresIn;
        @AuraEnabled
        public String refreshToken;
        @AuraEnabled
        public String estadoClave;
    }
    
    /***********DTOS para servicio de validación de listas negras en Gestor*******/
    public class ListasNegrasJuridicaInput{
        public String identificacion;
        public String nombre;
    }
    
    public class ListasNegrasNaturalInput{
        public String identificacion;
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;
    }
    
    public class ResponseDataListasNegrasOut{
        public ListasNegrasOut data;
    }
    
    public class ListasNegrasOut{
        public Boolean personaReportada;
        public List<ItemOcurrenciaPersonaListaNegra> ocurrencias;
    }
    
    public class ItemOcurrenciaPersonaListaNegra{
        public String codigoLista;
        public String nombreLista;
        public String mensaje;
        public String accion;
    }
    
    /***********DTOS para servicio de validación en registros de clientes*******/
    public class RegistroClienteInput{
        public String codigoTipoIdentificacion;
        public String identificacion;
    }
    
    public class ResponseDataRegistroClienteOut{
        public RegistroClienteOut data;
    }
    
    public class RegistroClienteOut{
        public String tipoRelacion;
        public List<ItemOcurrenciaRegistroCliente> ocurrencias;
    }
    
    public class ItemOcurrenciaRegistroCliente{
        public Integer codigoPersona;
        public String participe;
        public String fideicomitente;
        public String beneficiario;    
    }
    
    /*DTOS para crear notificaciones personalizadas*/
    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }

    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
    
    /*DTO para almacenar respuesta general de sincronización de oportunidad con Gestor*/
    public class RespuestaSincronizacionOportunidad
    {
        public Boolean personaBloqueadaEnListasNegras {get; set;}
        public Boolean errorEnSincronizacion {get;set;}
        public Integer codigoPersonaEnGestor {get;set;}
        public String numeroCuentaParticipe {get;set;}
        public String numeroTransaccionAporte {get;set;}
    }

    /*DTO para almacenar respuesta general de creacion de rescate en Gestor*/
    public class RespuestaCreacionRescate
    {
        public Boolean personaBloqueadaEnListasNegras {get; set;}
        public Boolean errorEnSincronizacion {get;set;}
        public Integer codigoPersonaEnGestor {get;set;}
        public String numeroCuentaParticipe {get;set;}
        public String numeroTransaccionAporte {get;set;}
    }
    
    /*DTOs para servicio de creación de Representante Legal en Gestor*/
    public class RegistroRepresentanteLegalInput{
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;
        public String codigoTipoIdentificacion;
        public String identificacion;
        public String correoElectronico;
        public String codigoPaisNacionalidad;
        public String pagaImpuestos;
        public String codigoTipoTelefonoCelular;
        public String telefonoCelular;
        public String codigoPaisNacimiento;
        public Integer secuenciaProvinciaNacimiento;
        public String codigoProvinciaNacimiento;
        public Integer secuenciaCantonNacimiento;
        public String codigoCantonNacimiento;
        public String fechaNacimiento;
        public String codigoEstadoCivil;
        public String genero;
        public String codigoTipoDireccionDomicilio;
        public String codigoPaisDireccionDomicilio;
        public Integer secuenciaProvinciaDireccionDomicilio;
        public String codigoProvinciaDireccionDomicilio;
        public Integer secuenciaCantonDireccionDomicilio;
        public String codigoCantonDireccionDomicilio;
        public String callePrincipalDireccionDomicilio;
        public String referenciaDireccionDomicilio;
        public String esDireccionFiscalDireccionDomicilio;
        public String codigoTipoTelefonoDomicilio;
        public String telefonoDomicilio;
        public String codigoTipoEmpleo;
        public String codigoTipoActividadEconomica;
        public String politicamenteExpuesto;
        public String lugarTrabajo;
        public String cargo;
        public String codigoTipoTelefonoOficina;
        public String telefonoOficina;
        public String codigoTotalActivo;
        public Decimal totalActivos;
        public String codigoTotalPasivo;
        public Decimal totalPasivos;
        public Decimal totalPatrimonio;
        public Decimal valorIngresosSueldoMensual;
        public Decimal valorGastoMensual;
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        public String codigoEntidadFinancieraCuentaBancaria;
        public String numeroCuentaBancaria;
        public String codigoTipoCuentaBancaria;        
    }    
    /*DTOs para servicio de creación de persona natural en Gestor*/
    public class RegistroPersonaNaturalInput{
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;
        public String codigoTipoIdentificacion;
        public String identificacion;
        public String correoElectronico;
        public String codigoPaisNacionalidad;
        public String pagaImpuestos;
        public String codigoTipoTelefonoCelular;
        public String telefonoCelular;
        public String codigoPaisNacimiento;
        public Integer secuenciaProvinciaNacimiento;
        public String codigoProvinciaNacimiento;
        public Integer secuenciaCantonNacimiento;
        public String codigoCantonNacimiento;
        public String fechaNacimiento;
        public String codigoEstadoCivil;
        public String genero;
        public String codigoTipoDireccionDomicilio;
        public String codigoPaisDireccionDomicilio;
        public Integer secuenciaProvinciaDireccionDomicilio;
        public String codigoProvinciaDireccionDomicilio;
        public Integer secuenciaCantonDireccionDomicilio;
        public String codigoCantonDireccionDomicilio;
        public String callePrincipalDireccionDomicilio;
        public String referenciaDireccionDomicilio;
        public String esDireccionFiscalDireccionDomicilio;
        public String codigoTipoTelefonoDomicilio;
        public String telefonoDomicilio;
        public String codigoTipoEmpleo;
        public String codigoTipoActividadEconomica;
        public String politicamenteExpuesto;
        public String lugarTrabajo;
        public String cargo;
        public String codigoTipoTelefonoOficina;
        public String telefonoOficina;
        public String codigoTotalActivo;
        public Decimal totalActivos;
        public String codigoTotalPasivo;
        public Decimal totalPasivos;
        public Decimal totalPatrimonio;
        public Decimal valorIngresosSueldoMensual;
        public Decimal valorGastoMensual;
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        public String codigoEntidadFinancieraCuentaBancaria;
        public String numeroCuentaBancaria;
        public String codigoTipoCuentaBancaria;      
        public List<direccionesElectronicas> direccionesElectronicas;  
    }
    
    /*DTOs para servicio de creación de persona jurídica en Gestor*/
    public Class RegistroPersonaJuridicaInput{
        public String callePrincipalDireccionResidenciaTributaria;
        public String callePrincipalDireccionTrabajo;
        public Decimal capitalSocial;
        public String cargoRepresentanteLegal;
        public String codigoOrgGeoDireccionResidenciaTributaria;
        public String codigoOrgGeoDireccionTrabajo;
        public String codigoPaisDireccionResidenciaTributaria;
        public String codigoPaisDireccionTrabajo;
        public String codigoPaisNacionalidad;
        public String codigoTipoActividadEconomica;
        public String codigoTipoIdentificacion;
        public String codigoTipoPersonaJuridica;
        public String fechaConstitucion;
        public String identificacion;
        public String interseccionDireccionResidenciaTributaria;
        public String interseccionDireccionTrabajo;
        public String nombre;
        public String numeroDireccionResidenciaTributaria;
        public String numeroDireccionTrabajo;
        public String observaciones;
        public String politicamenteExpuesto;
        public String razonSocial;
        public String tipoIdRepresentanteLegal;
        public String idRepresentanteLegal;
        public Integer secuenciaOrgGeoDireccionResidenciaTributaria;
        public Integer secuenciaOrgGeoDireccionTrabajo;
        public String telefonoCelular;
        public String telefonoConvencional;
        public String tipoPersona;
        public Decimal totalActivos;
        public Decimal totalGastos;
        public Decimal totalIngresos;
        public Decimal totalPasivos;
		public String codigoTipoEntidadFinancieraCuentaBancaria;
		public String codigoEntidadFinancieraCuentaBancaria;
		public String numeroCuentaBancaria;
		public String codigoTipoCuentaBancaria;    
        public List<direccionesElectronicas> direccionesElectronicas;  
        
    }
    
    public class ResponseDataRegistroPersonaOut{
        public RegistroPersonaOut data;
    }
    
    public class RegistroPersonaOut{        
        public Integer codigoPersona;        
    }
    
    /*DTOs para servicio de creación de cuenta de participe*/
    public Class RegistroCuentaParticipeInput{
        public String fechaCreacion;
        public String codigoAgencia;
        public String codigoTrader;
        public String codigoCuentaContable;
        public String complementarios;
        public String transaccionCooparticipe;
        public String canal;
    }
    
    public class ResponseDataRegistroCuentaParticipeOut{
        public RegistroCuentaParticipeOut data;
    }
    
    public class RegistroCuentaParticipeOut{        
        public String numeroCuenta;        
    }
    
    /*DTOs para servicio de creación de aporte en Gestor*/
    public Class RegistroAporteInput{
        public String codigoAgencia;
        public String codigoTipoTransaccion;
        public String fechaEfectiva;
        public String numeroDocumento;
        public String codigoTipoFormaPago;
        public String codigoMoneda;
        public String codigoTipoEntidadFondo;
        public String codigoEntidadFondo;
        public String numeroCuentaFondo;
        public Decimal monto;
        public String canal;
    }
    
    public class ResponseDataRegistroAporteOut{
        public RegistroAporteOut data;
    }
    
    public class RegistroAporteOut{        
        public String numeroTransaccion;        
    }
    
    /*DTO para calcular los nombres y apellidos de un cliente tipo persona natural*/
    public class NombresApellidosClienteNatural{        
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;
    }
    
    /*DTOs para servicio de consulta de persona natural en Gestor*/    
    public class ResponseDataPersonaNaturalOut{
        public PersonaNaturalOut data ;        
    }
    
    public class PersonaNaturalOut{
        @AuraEnabled
        public String tipoPersona;
        @AuraEnabled
        public String primerNombre;
        @AuraEnabled
        public String segundoNombre;
        @AuraEnabled
        public String primerApellido;
        @AuraEnabled
        public String segundoApellido;
        @AuraEnabled
        public String codigoTipoIdentificacion;
        @AuraEnabled
        public String identificacion;
        @AuraEnabled
        public String correoElectronico;
        @AuraEnabled
        public String codigoPaisNacionalidad;
        @AuraEnabled
        public String pagaImpuestos;
        @AuraEnabled
        public String codigoTipoTelefonoCelular;
        @AuraEnabled
        public String telefonoCelular;
        @AuraEnabled
        public String codigoPaisNacimiento;
        @AuraEnabled
        public Integer secuenciaProvinciaNacimiento;
        @AuraEnabled
        public String codigoProvinciaNacimiento;
        @AuraEnabled
        public Integer secuenciaCantonNacimiento;
        @AuraEnabled
        public String codigoCantonNacimiento;
        @AuraEnabled
        public Integer secuenciaParroquiaNacimiento;
        @AuraEnabled
        public String codigoParroquiaNacimiento;
        @AuraEnabled
        public String fechaNacimiento;
        @AuraEnabled
        public String codigoEstadoCivil;
        @AuraEnabled
        public String genero;
        @AuraEnabled
        public String codigoTipoDireccionDomicilio;
        @AuraEnabled
        public String codigoPaisDireccionDomicilio;
        @AuraEnabled
        public Integer secuenciaProvinciaDireccionDomicilio;
        @AuraEnabled
        public String codigoProvinciaDireccionDomicilio;
        @AuraEnabled
        public Integer secuenciaCantonDireccionDomicilio;
        @AuraEnabled
        public String codigoCantonDireccionDomicilio;
        @AuraEnabled
        public Integer secuenciaParroquiaDireccionDomicilio;
        @AuraEnabled
        public String codigoParroquiaDireccionDomicilio;
        @AuraEnabled
        public String callePrincipalDireccionDomicilio;
        @AuraEnabled
        public String referenciaDireccionDomicilio;
        @AuraEnabled
        public String esDireccionFiscalDireccionDomicilio;
        @AuraEnabled
        public String codigoTipoTelefonoDomicilio;
        @AuraEnabled
        public String telefonoDomicilio;
        @AuraEnabled
        public String codigoTipoEmpleo;
        @AuraEnabled
        public String codigoTipoActividadEconomica;
        @AuraEnabled
        public String politicamenteExpuesto;
        @AuraEnabled
        public String lugarTrabajo;
        @AuraEnabled
        public String cargo;
        @AuraEnabled
        public String codigoTipoTelefonoOficina;
        @AuraEnabled
        public String telefonoOficina;        
        @AuraEnabled
        public Decimal totalActivos;        
        @AuraEnabled
        public Decimal totalPasivos;
        @AuraEnabled
        public Decimal totalPatrimonio;
        @AuraEnabled
        public String codigoTipoIngresoSueldoMensual;        
        @AuraEnabled
        public Decimal valorIngresosSueldoMensual;
        @AuraEnabled
        public String codigoTipoIngresoAhorros;
        @AuraEnabled
        public Decimal valorIngresosAhorros;
        @AuraEnabled
        public Decimal valorIngresosOtros;
        @AuraEnabled
        public String codigoTipoGastoMensual;
        @AuraEnabled
        public Decimal valorGastoMensual;
        @AuraEnabled
        public Decimal totalIngresosMensuales;
        @AuraEnabled
        public Decimal totalEgresosMensuales;
        @AuraEnabled
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        @AuraEnabled
        public String codigoEntidadFinancieraCuentaBancaria;
        @AuraEnabled
        public String numeroCuentaBancaria;
        @AuraEnabled
        public String codigoTipoCuentaBancaria;    
        @AuraEnabled
        public String nombreConyuge;
        @AuraEnabled
        public String codigoTipoDependienteConyuge;
        @AuraEnabled
        public String codigoTipoIdentificacionConyuge;
        @AuraEnabled
        public String identificacionConyuge;
    }
    
    /*DTOs para servicio de consulta de persona jurídica en Gestor*/
    public class ResponseDataPersonaJuridicaOut{
        public PersonaJuridicaOut data ;        
    }
    
    public class PersonaJuridicaOut{
        @AuraEnabled
        public String tipoPersona;
        @AuraEnabled
        public String codigoTipoPersonaJuridica;
        @AuraEnabled
        public String nombre;
        @AuraEnabled
        public String razonSocial;
        @AuraEnabled
        public String codigoTipoIdentificacion;
        @AuraEnabled
        public String identificacion;
        @AuraEnabled
        public String codigoPaisNacionalidad;
        @AuraEnabled
        public String codigoTipoActividadEconomica;
        @AuraEnabled
        public String politicamenteExpuesto;
        @AuraEnabled
        public String fechaConstitucion;
        @AuraEnabled
        public Decimal capitalSocial;
        @AuraEnabled
        public String observaciones;
        @AuraEnabled
        public String telefonoConvencional;
        @AuraEnabled
        public String telefonoCelular;
        @AuraEnabled
        public String callePrincipalDireccionTrabajo;
        @AuraEnabled
        public String numeroDireccionTrabajo;
        @AuraEnabled
        public String interseccionDireccionTrabajo;
        @AuraEnabled
        public String codigoPaisDireccionTrabajo;
        @AuraEnabled
        public Integer secuenciaOrgGeoDireccionTrabajo;
        @AuraEnabled
        public String codigoOrgGeoDireccionTrabajo;
        @AuraEnabled
        public String callePrincipalDireccionResidenciaTributaria;
        @AuraEnabled
        public String numeroDireccionResidenciaTributaria;
        @AuraEnabled
        public String interseccionDireccionResidenciaTributaria;
        @AuraEnabled
        public String codigoPaisDireccionResidenciaTributaria;
        @AuraEnabled
        public Integer secuenciaOrgGeoDireccionResidenciaTributaria;
        @AuraEnabled
        public String codigoOrgGeoDireccionResidenciaTributaria;
        @AuraEnabled
        public Decimal totalActivos;
        @AuraEnabled
        public Decimal totalPasivos;        
        @AuraEnabled
        public Decimal totalIngresos;
        @AuraEnabled
        public Decimal totalGastos;
        @AuraEnabled
        public Integer representanteLegal;
        @AuraEnabled
        public String cargoRepresentanteLegal;        
        @AuraEnabled
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        @AuraEnabled
        public String codigoEntidadFinancieraCuentaBancaria;
        @AuraEnabled
        public String numeroCuentaBancaria;
        @AuraEnabled
        public String codigoTipoCuentaBancaria;  
        @AuraEnabled
        public direccionesElectronicas[] direccionesElectronicas;
        //@AuraEnabled 
        //public List<direccionesElectronicas> direccionesElectronicas;
    }

    public class direccionesElectronicas {
		public String correoElectronico;	//string
		public String principal;	//string
		public String esDireccionEstadoCuenta;	//string
	}
    /*DTO para validación de registro en clientes y consulta de persona natural en Gestor*/
    public class ConsultaPersonaNatural{
        @AuraEnabled
        public Boolean clienteExisteEnGestor;
        @AuraEnabled
        public String codigoPersonaEnGestor;
        @AuraEnabled
        public PersonaNaturalOut personaNaturalOut;
    }
    
    /*DTO para validación de registro en clientes y consulta de persona jurídica en Gestor*/
    public class ConsultaPersonaJuridica{
        @AuraEnabled
        public Boolean clienteExisteEnGestor;
        @AuraEnabled
        public String codigoPersonaEnGestor;
        @AuraEnabled
        public PersonaJuridicaOut personaJuridicaOut;
    }
    
    /*DTOs para servicio de consulta de cuentas de participe*/
    public class ItemCuentaParticipe{
        @AuraEnabled
        public String codigoProducto;
        @AuraEnabled
        public String nombreProducto;
        @AuraEnabled
        public String codigoAgencia;
        @AuraEnabled
        public String nombreAgencia;
        @AuraEnabled
        public Integer codigoTrader;
        @AuraEnabled
        public String nombreTrader;
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public String codigoTipoCuenta;
        @AuraEnabled
        public String nombreTipoCuenta;
        @AuraEnabled
        public String fechaApertura;
        @AuraEnabled
        public String estado;
    }
    
    public class CuentasParticipeOut{
        public List<ItemCuentaParticipe> data;
    }
    
    /**************DTOs para servicio de consulta de movimientos de cuenta de participe***************/
    public class MovimientosCuentaParticipeOut{
        @AuraEnabled
    	public List<ItemTransaccionCuentaParticipe> data;
        @AuraEnabled
        public Links links;
        @AuraEnabled
        public Meta meta;             
    }
    
    public class ItemTransaccionCuentaParticipe{
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public String numeroTransaccion;
        @AuraEnabled
        public String fechaTransaccion;//fecha en formato yyyy-MM-dd
        @AuraEnabled
        public String codigoTipoTransaccion;
        @AuraEnabled
        public String nombreTipoTransaccion;
        @AuraEnabled
        public String tipoMovimiento;
        @AuraEnabled
        public Decimal valorBruto;
        @AuraEnabled
        public Decimal valorRetenciones;
        @AuraEnabled
        public Decimal valorComisiones;
        @AuraEnabled
        public Decimal valorNeto;
        @AuraEnabled
        public Decimal numeroUnidades;
        @AuraEnabled
        public String estado;
    }
    
    public class Links{
        @AuraEnabled
        public String self;
        @AuraEnabled
        public String first;
        @AuraEnabled
        public String prev;
        @AuraEnabled
        public String next;
        @AuraEnabled
        public String last;
    }
    
    public class Meta{
        @AuraEnabled
        public Integer totalPages;
        @AuraEnabled
        public String fechaConsultaSaldos;
        @AuraEnabled
        public Integer totalElements;
    }
    
    public class MovimientosCuentaParticipeInput{
        @AuraEnabled
        public String codigoProducto;
        @AuraEnabled
        public String codigoCliente;
        @AuraEnabled
        public String fechaDesde;
        @AuraEnabled
        public String fechaHasta;
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public Integer pageNumber;
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public String tipoTransaccion;
    }
    
    /*DTOs para servicio de consulta de saldos de cuenta de partícipe en Gestor*/
    public class ResponseDataSaldosParticipeOut{
        @AuraEnabled
        public SaldosCuentasParticipeOut data; 
        
    }
    
    public class SaldosCuentasParticipeOut{
        @AuraEnabled
        public String fechaConsultaSaldo;
        @AuraEnabled
        public List<ItemSaldoCuentaParticipe> cuentasParticipe;
        
    }
    
    public class ItemSaldoCuentaParticipe{
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public Decimal capital;
        @AuraEnabled
        public Decimal saldoInteres;
        @AuraEnabled
        public Decimal saldoTotal;
        @AuraEnabled
        public Decimal saldoBloqueado;
        @AuraEnabled
        public Decimal saldoDisponible;
        @AuraEnabled
        public Decimal saldoUnidades;
        @AuraEnabled
        public Decimal valorUnidad;
        @AuraEnabled
        public Decimal porcentajeParticipacion;
        @AuraEnabled
        public Decimal rendimiento;    
        @AuraEnabled
        public Decimal sumaTransaccionesRescateTransito;
        @AuraEnabled
        public Decimal saldoDisponibleEfectivo;    
        
    }
    
    /*DTOs para servicio de consulta de valor de rendimiento de cuenta de partícipe en Gestor*/
    public class ValorRendimientoCuentaOut{
        @AuraEnabled
        public valorRendimientoCuenta data;
    }
    public class ValorRendimientoCuenta{
        @AuraEnabled
        public Decimal valorRendimiento;
    }
    
    /*DTOs para almacenar respuesta de consulta de información adicional en Gestor*/
    public class InformacionAdicionalCuenta{
        @AuraEnabled
        public String fechaConsultaSaldo;
        @AuraEnabled
        public List<ItemSaldoCuentaParticipe> cuentasParticipe;
        @AuraEnabled
        public Decimal valorRendimiento;
        @AuraEnabled
        public Decimal porcentajeRendimientoProducto;
    }
    
    /*DTOs para servicio de consulta de porcentaje de rendimiento de producto en Gestor*/
    public class PorcentajeRendimientoProductoOut{
        @AuraEnabled
        public  PorcentajeRendimientoProducto data;
    }
    public class PorcentajeRendimientoProducto{
        @AuraEnabled
        public Decimal porcentajeRendimiento;
    }
    
    /*DTOs para servicio de actualización de persona jurídica en Gestor*/
    public Class ActualizarPersonaJuridicaInput{
        public String nombre;
        public String razonSocial;
        public String codigoTipoIdentificacion;
        public String identificacion;
        public String codigoPaisNacionalidad;
        public String codigoTipoActividadEconomica;
        public String politicamenteExpuesto;
        public String fechaConstitucion;
        public Decimal capitalSocial;
        public String observaciones;
        public String telefonoConvencional;
        public String telefonoCelular;
        public String callePrincipalDireccionTrabajo;
        public String numeroDireccionTrabajo;
        public String interseccionDireccionTrabajo;
        public String codigoPaisDireccionTrabajo;
        public Integer secuenciaOrgGeoDireccionTrabajo;
        public String codigoOrgGeoDireccionTrabajo;       
        public String callePrincipalDireccionResidenciaTributaria;
        public String numeroDireccionResidenciaTributaria;
        public String interseccionDireccionResidenciaTributaria;
        public String codigoPaisDireccionResidenciaTributaria;
        public Integer secuenciaOrgGeoDireccionResidenciaTributaria;
        public String codigoOrgGeoDireccionResidenciaTributaria;
        public Decimal totalActivos;
        public Decimal totalPasivos;
        public Decimal totalIngresos;        
        public Decimal totalGastos;
        public String tipoIdRepresentanteLegal;
        public String idRepresentanteLegal;        
        public String cargoRepresentanteLegal;
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        public String codigoEntidadFinancieraCuentaBancaria;
        public String numeroCuentaBancaria;
		public String codigoTipoCuentaBancaria;		
		public List<direccionesElectronicas> direccionesElectronicas;        
    }

/*DTOs para servicio de actualización de persona jurídica en Gestor*/
    public Class ActualizarPersonaJuridicaInputCorreo{
        public List<direccionesElectronicas> direccionesElectronicas;
    }    
    
    /*DTOs para servicio de actualización de persona natural en Gestor*/
    public class ActualizarPersonaNaturalInput{
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;  
        public String codigoTipoIdentificacion;
        public String identificacion;
        public String codigoPaisNacionalidad;
        public String pagaImpuestos;
        public String codigoTipoTelefonoCelular;
        public String telefonoCelular;
        public String codigoPaisNacimiento;
        public Integer secuenciaProvinciaNacimiento;
        public String codigoProvinciaNacimiento;
        public Integer secuenciaCantonNacimiento;
        public String codigoCantonNacimiento;
        public String fechaNacimiento;
        public String codigoEstadoCivil;
        public String genero;
        public String codigoTipoDireccionDomicilio;
        public String codigoPaisDireccionDomicilio;
        public Integer secuenciaProvinciaDireccionDomicilio;
        public String codigoProvinciaDireccionDomicilio;
        public Integer secuenciaCantonDireccionDomicilio;
        public String codigoCantonDireccionDomicilio;
        public String callePrincipalDireccionDomicilio;
        public String referenciaDireccionDomicilio;
        public String esDireccionFiscalDireccionDomicilio;
        public String codigoTipoTelefonoDomicilio;
        public String telefonoDomicilio;
        public String codigoTipoEmpleo;
        public String codigoTipoActividadEconomica;
        public String politicamenteExpuesto;
        public String lugarTrabajo;
        public String cargo;
        public String codigoTipoTelefonoOficina;
        public String telefonoOficina;
        public String codigoTotalActivo;
        public Decimal totalActivos;
        public String codigoTotalPasivo;
		public Decimal totalPasivos;
        public Decimal totalPatrimonio;
        public String codigoTipoIngresoSueldoMensual;
        public Decimal valorIngresosSueldoMensual;
        public String codigoTipoGastoMensual;
        public Decimal valorGastoMensual;
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        public String codigoEntidadFinancieraCuentaBancaria;
        public String numeroCuentaBancaria;
        public String codigoTipoCuentaBancaria;         
    }
    
    /*DTOs para servicio de actualización de representante legal en Gestor*/
    public class ActualizarRepresentanteLegalInput{
        public String primerNombre;
        public String segundoNombre;
        public String primerApellido;
        public String segundoApellido;  
        public String codigoTipoIdentificacion;
        public String identificacion;
        public String codigoPaisNacionalidad;
        public String pagaImpuestos;
        public String codigoTipoTelefonoCelular;
        public String telefonoCelular;
        public String codigoPaisNacimiento;
        public Integer secuenciaProvinciaNacimiento;
        public String codigoProvinciaNacimiento;
        public Integer secuenciaCantonNacimiento;
        public String codigoCantonNacimiento;
        public String fechaNacimiento;
        public String codigoEstadoCivil;
        public String genero;
        public String codigoTipoDireccionDomicilio;
        public String codigoPaisDireccionDomicilio;
        public Integer secuenciaProvinciaDireccionDomicilio;
        public String codigoProvinciaDireccionDomicilio;
        public Integer secuenciaCantonDireccionDomicilio;
        public String codigoCantonDireccionDomicilio;
        public String callePrincipalDireccionDomicilio;
        public String referenciaDireccionDomicilio;
        public String esDireccionFiscalDireccionDomicilio;
        public String codigoTipoTelefonoDomicilio;
        public String telefonoDomicilio;
        public String codigoTipoEmpleo;
        public String codigoTipoActividadEconomica;
        public String politicamenteExpuesto;
        public String lugarTrabajo;
        public String cargo;
        public String codigoTipoTelefonoOficina;
        public String telefonoOficina;
        public String codigoTotalActivo;
        public Decimal totalActivos;
        public String codigoTotalPasivo;
		public Decimal totalPasivos;
        public Decimal totalPatrimonio;
        public String codigoTipoIngresoSueldoMensual;
        public Decimal valorIngresosSueldoMensual;
        public String codigoTipoGastoMensual;
        public Decimal valorGastoMensual;
        public String codigoTipoEntidadFinancieraCuentaBancaria;
        public String codigoEntidadFinancieraCuentaBancaria;
        public String numeroCuentaBancaria;
        public String codigoTipoCuentaBancaria;         
    }

    public class RegistroReferenciaBancariaInput{
        @AuraEnabled
        public String codigoTipoEntidadFinanciera;
        @AuraEnabled
        public String codigoEntidadFinanciera;
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public String codigoTipoCuenta;
        @AuraEnabled
        public String codigoMoneda;
        @AuraEnabled
        public String fechaIngreso;
        @AuraEnabled
        public String principal;
        @AuraEnabled
        public String estado;
        @AuraEnabled
        public String observaciones;
    }
    
    public class ActualizacionReferenciaBancariaInput{
        public String codigoTipoEntidadFinanciera;
        public String codigoEntidadFinanciera;        
        public String codigoTipoCuenta;
        public String codigoMoneda;
        public String fechaIngreso;
        public String principal;
        public String estado;
        public String observaciones;
    }
    /**************DTOs para servicio de consulta de saldos de cuentas de partícipes por producto***************/
    public class SaldosCuentasParticipePorProductoOut{
        @AuraEnabled
    	public List<ItemSaldosParticipe> data;
        @AuraEnabled
        public Links links;
        @AuraEnabled
        public Meta meta;             
    }
    public class ItemSaldosParticipe{
        @AuraEnabled
        public Integer codigoCliente;
        @AuraEnabled
        public String nombreCliente;
        @AuraEnabled
        public String numeroCuenta;
        @AuraEnabled
        public Decimal capital;
        @AuraEnabled
        public Decimal saldoInteres;
        @AuraEnabled
        public Decimal saldoTotal;        
        @AuraEnabled
        public Decimal rendimiento;
		@AuraEnabled
        public Integer codigoTrader;
		@AuraEnabled
        public String nombreTrader;      
    }
    
    public class SaldosCuentasParticipeInput{
        @AuraEnabled
        public String codigoProducto {get;set;}        
        @AuraEnabled
        public String fechaDesde {get;set;}
        @AuraEnabled
        public String fechaHasta {get;set;}        
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer pageSize {get;set;}       
    }
}