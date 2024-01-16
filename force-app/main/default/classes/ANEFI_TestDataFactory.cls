@IsTest
public class ANEFI_TestDataFactory {
    public static testmethod void crearDatos(){
        /*Crear actividad econónomica*/
        ANEFI_Actividad_Economica__c actividadEconomica = new ANEFI_Actividad_Economica__c();
        actividadEconomica.Name = '0001';
        actividadEconomica.Descripcion__c = 'Comercio';
        actividadEconomica.Nivel__c = 1;
        insert actividadEconomica;	
        
        ANEFI_Pais__c pais = new ANEFI_Pais__c();
        pais.Alias__c = 'ECU';
        pais.Codigo_Pais__c = '01';
        pais.Name = 'ECUADOR';
        insert pais;
        
        ANEFI_Canton__c canton = new ANEFI_Canton__c();
        canton.Codigo_provincia__c = '001';
        canton.Name = '001';
        canton.Nombre_canton__c = 'Quito';
        canton.Pais__c = pais.Id;
        canton.Provincia__c = '1';
        canton.Secuencia__c = 2;
        insert canton;
        
        /*Se crea entidad financiera*/
        ANEFI_Entidad_financiera__c entidadFinanciera = new ANEFI_Entidad_financiera__c();
        entidadFinanciera.Codigo_fiducia__c = 'F001';
        entidadFinanciera.Name = '001';
        entidadFinanciera.Nombre__c = 'Banco';
        entidadFinanciera.Numero_de_cuenta__c = '104522';
        entidadFinanciera.Tipo_de_entidad__c = 1;
        insert entidadFinanciera;
        
        /*Se crea el cliente de tipo jurídico*/
        Account clienteJuridico = new Account();
        clienteJuridico.Name = 'Celema S.A';
        clienteJuridico.Actividad_Economica__c = actividadEconomica.Id;
        clienteJuridico.Activo__c = 'Activo';
        clienteJuridico.Calle_principal_direccion_trabajo__c = 'primera';
        clienteJuridico.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Jurídica').getRecordTypeId();
        clienteJuridico.Tipo_de_identificacion__c = '2';
        clienteJuridico.Numero_de_identificacion__c = '1053258974854';
        clienteJuridico.Tipo_de_persona_juridica__c = '	2';
        clienteJuridico.Fecha_de_constitucion__c = system.date.today();
        clienteJuridico.Politicamente_expuesto__c = 'NO';
        clienteJuridico.Phone = '+593 2 450 0178';
        clienteJuridico.Nacionalidad__c = pais.Id;
        clienteJuridico.Pais_direccion_trabajo__c  = pais.Id;
        clienteJuridico.Canton_direccion_de_trabajo__c  = canton.Id;
        clienteJuridico.Interseccion_direccion_trabajo__c  = '1131';
        clienteJuridico.Numero_direccion_trabajo__c  = '2121';
        clienteJuridico.AnnualRevenue = 1400;
        clienteJuridico.Total_activos__c  = 120;
        clienteJuridico.Total_pasivos__c = 10;
        clienteJuridico.Total_gastos__c = 10;
        clienteJuridico.Entidad_financiera__c = entidadFinanciera.Id;
        clienteJuridico.Numero_de_cuenta_bancaria__c = '27855';
        clienteJuridico.Tipo_de_cuenta_bancaria__c  = 'A';       
        insert clienteJuridico;
        
        /*Se crea oportunidad con estado cerrada ganada*/
        Opportunity oportunidad = new Opportunity();
        oportunidad.AccountId = clienteJuridico.Id;
        oportunidad.Name = 'Celema S.A - CP-1';
        oportunidad.Amount = 690;
        oportunidad.CloseDate = system.Date.today();
        oportunidad.ANEFI_Business_line__c = 'Fondos';
        oportunidad.Producto_de_Interes__c = 'F001';
        oportunidad.Fecha_efectiva_primer_aporte__c = system.date.today();
        oportunidad.Entidad_financiera__c = entidadFinanciera.Id;
        oportunidad.StageName = 'Firma de contrato';
        oportunidad.Firmo_el_contrato__c  = true;
        oportunidad.Cliente_hizo_el_pago__c = true;
        oportunidad.Se_recopilo_nombramiento__c = true;
        oportunidad.Se_recopilo_RUC__c = true;
        oportunidad.Trader__c = '692212';
        oportunidad.Complementarios__c = 'S';
        oportunidad.Transaccion_cooparticipe__c = 'SI';
        oportunidad.Numero_documento_deposito__c = '54222';
        oportunidad.Forma_de_Pago__c  = 'CHEQ';
        oportunidad.Moneda__c = '1';
        oportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Jurídica').getRecordTypeId();
        insert oportunidad;
        
        /*Se crea cliente natural*/
        Account clienteNatural = new Account();
        clienteNatural.Name = 'Julian Rendón';
        clienteNatural.Nacionalidad__c = pais.Id;
        clienteNatural.Paga_impuestos__c = 'S';
        clienteNatural.Fecha_de_nacimiento__c = system.Date.today();
        clienteNatural.Genero__c = 'M';
        clienteNatural.Politicamente_expuesto__c = 'NO';
        clienteNatural.Actividad_Economica__c = actividadEconomica.Id;
        clienteNatural.Activo__c = 'Activo';
        clienteNatural.Tipo_de_identificacion__c = '1';
        clienteNatural.Numero_de_identificacion__c = '1053258974'; 
        clienteNatural.Phone = '+593 2 450 0178';        
        clienteNatural.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        clienteNatural.Pais_direccion_domicilio__c  = pais.Id;
        clienteNatural.Canton_direccion_domicilio__c  = canton.Id;
        clienteNatural.Telefono_domicilio__c  = '58522';
        clienteNatural.Calle_principal_direccion_domicilio__c = 'primera';        
        clienteNatural.Es_direccion_fiscal_direccion_domicilio__c  = 'S';     
        clienteNatural.Total_activos__c  = 120;
        clienteNatural.Total_pasivos__c = 10;
        clienteNatural.Total_patrimonio__c = 10;
        clienteNatural.Entidad_financiera__c = entidadFinanciera.Id;
        clienteNatural.Numero_de_cuenta_bancaria__c = '27855';
        clienteNatural.Tipo_de_cuenta_bancaria__c  = 'A';        
        insert clienteNatural;
        
        /*Se crea oportunidad natural con estado cerrada ganada*/
        Opportunity oportunidadNatural = new Opportunity();
        oportunidadNatural.AccountId = clienteNatural.Id;
        oportunidadNatural.Name = 'Julian Rendón - CP-1';
        oportunidadNatural.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        oportunidadNatural.Amount = 690;
        oportunidadNatural.CloseDate = system.Date.today();
        oportunidadNatural.ANEFI_Business_line__c = 'Fondos';
        oportunidadNatural.Producto_de_Interes__c = 'F001';
        oportunidadNatural.Fecha_efectiva_primer_aporte__c = system.date.today();
        oportunidadNatural.Entidad_financiera__c = entidadFinanciera.Id;
        oportunidadNatural.StageName = 'Firma de contrato';
        oportunidadNatural.Firmo_el_contrato__c  = true;
        oportunidadNatural.Cliente_hizo_el_pago__c = true;
        oportunidadNatural.Se_recopilo_cedula__c = true;        
        oportunidadNatural.Trader__c = '692212';
        oportunidadNatural.Complementarios__c = 'S';
        oportunidadNatural.Transaccion_cooparticipe__c = 'SI';
        oportunidadNatural.Numero_documento_deposito__c = '54222';
        oportunidadNatural.Forma_de_Pago__c  = 'CHEQ';
        oportunidadNatural.Moneda__c = '1';
        insert oportunidadNatural;
        
        /*Se crea cliente sincronizado en Gestor*/
        Account clienteSincronizadoEnGestor = new Account();
        clienteSincronizadoEnGestor.Name = 'Coomeva S.A';
        clienteSincronizadoEnGestor.Codigo_persona_en_Gestor__c = '1028437';
        clienteSincronizadoEnGestor.Tipo_de_identificacion__c = '1';
        clienteSincronizadoEnGestor.Numero_de_identificacion__c = '1058741478';       
        insert clienteSincronizadoEnGestor;
        
        /*Se crea oportunidad de tipo persona natural con campos faltantes*/        
        Opportunity oportunidadCamposFaltantes = new Opportunity();
        oportunidadCamposFaltantes.AccountId = clienteSincronizadoEnGestor.Id;
        oportunidadCamposFaltantes.Name = 'Oportunidad - CP-1';
        oportunidadCamposFaltantes.Amount = 690;
        oportunidadCamposFaltantes.CloseDate = system.Date.today();        
        oportunidadCamposFaltantes.StageName = 'Propuesta'; 
        oportunidadCamposFaltantes.ANEFI_Business_line__c = 'Fondos';
        oportunidadCamposFaltantes.Producto_de_Interes__c = 'F001';
        oportunidadCamposFaltantes.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        oportunidadCamposFaltantes.Estado_sincronizacion_Gestor__c = 'ERROR SINCRONIZACIÓN';
        oportunidadCamposFaltantes.Transaccion_cooparticipe__c = '';
        oportunidadCamposFaltantes.Complementarios__c = '';
        insert oportunidadCamposFaltantes;
        
        
        /*Se crea oportunidad de tipo persona jurídica con campos faltantes*/        
        Opportunity oportunidadJuridicaCampos = new Opportunity();
        oportunidadJuridicaCampos.AccountId = clienteSincronizadoEnGestor.Id;
        oportunidadJuridicaCampos.Name = 'Oportunidad - FS-2';
        oportunidadJuridicaCampos.Amount = 690;
        oportunidadJuridicaCampos.CloseDate = system.Date.today();        
        oportunidadJuridicaCampos.StageName = 'Propuesta';        
        oportunidadJuridicaCampos.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Jurídica').getRecordTypeId();
        oportunidadJuridicaCampos.Transaccion_cooparticipe__c = '';
        oportunidadJuridicaCampos.Complementarios__c = '';
        insert oportunidadJuridicaCampos;
        
        /*Se crea oportunidad de tipo persona jurídica con campos faltantes*/        
        Opportunity oportunidadJuridicaCP1 = new Opportunity();
        oportunidadJuridicaCP1.AccountId = clienteSincronizadoEnGestor.Id;
        oportunidadJuridicaCP1.Name = 'Oportunidad CP-1';
        oportunidadJuridicaCP1.Amount = 690;
        oportunidadJuridicaCP1.CloseDate = system.Date.today();        
        oportunidadJuridicaCP1.StageName = 'Propuesta';        
        oportunidadJuridicaCP1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Jurídica').getRecordTypeId();
        oportunidadJuridicaCP1.Transaccion_cooparticipe__c = '';
        oportunidadJuridicaCP1.Complementarios__c = '';
        oportunidadJuridicaCP1.ANEFI_Business_line__c = 'Fondos';
        oportunidadJuridicaCP1.Producto_de_Interes__c = 'F001';
        insert oportunidadJuridicaCP1;
        
        /*Se crea cliente natural con contacto asociado*/
        Account clienteNaturalConContacto = new Account();
        clienteNaturalConContacto.Name = 'Olivia Jimenez';
        clienteNaturalConContacto.Nacionalidad__c = pais.Id;
          clienteNaturalConContacto.Paga_impuestos__c = 'S';
        clienteNaturalConContacto.Fecha_de_nacimiento__c = system.Date.today();
        clienteNaturalConContacto.Genero__c = 'M';
        clienteNaturalConContacto.Politicamente_expuesto__c = 'NO';
        clienteNaturalConContacto.Actividad_Economica__c = actividadEconomica.Id;
        clienteNaturalConContacto.Activo__c = 'Activo';
        clienteNaturalConContacto.Tipo_de_identificacion__c = '1';
        clienteNaturalConContacto.Numero_de_identificacion__c = '1562222222'; 
        clienteNaturalConContacto.Phone = '+593 2 450 0178';        
        clienteNaturalConContacto.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        clienteNaturalConContacto.Pais_direccion_domicilio__c  = pais.Id;
        clienteNaturalConContacto.Canton_direccion_domicilio__c  = canton.Id;
        clienteNaturalConContacto.Telefono_domicilio__c  = '58522';
        clienteNaturalConContacto.Calle_principal_direccion_domicilio__c = 'primera';        
        clienteNaturalConContacto.Es_direccion_fiscal_direccion_domicilio__c  = 'S';     
        clienteNaturalConContacto.Total_activos__c  = 120;
        clienteNaturalConContacto.Total_pasivos__c = 10;
        clienteNaturalConContacto.Total_patrimonio__c = 10;
        clienteNaturalConContacto.Entidad_financiera__c = entidadFinanciera.Id;
        clienteNaturalConContacto.Numero_de_cuenta_bancaria__c = '27855';
        clienteNaturalConContacto.Tipo_de_cuenta_bancaria__c  = 'A';        
        insert clienteNaturalConContacto;
        
        /*Se crea contacto para cliente natural*/
        Contact contactoNatural = new Contact();
        contactoNatural.AccountId = clienteNaturalConContacto.id;
        contactoNatural.FirstName = 'Milena';
        contactoNatural.MiddleName = 'Andrea';
        contactoNatural.LastName = 'Osorio Perez';
        contactoNatural.Email = 'milena@perez.com';
        contactoNatural.Phone = '+593 2 450 0178';
        contactoNatural.Estado_civil__c = 'C';
        contactoNatural.Tipo_de_identificacion__c = '1';
        contactoNatural.Numero_de_identificacion__c = '1234567891';
        insert contactoNatural;
        
        /*Se crea oportunidad para cliente natural con contacto*/
        Opportunity oportunidadNaturalContacto = new Opportunity();
        oportunidadNaturalContacto.AccountId = clienteNaturalConContacto.id;
        oportunidadNaturalContacto.Name = 'Milena Perez - CP-1';
        oportunidadNaturalContacto.Amount = 690;
        oportunidadNaturalContacto.CloseDate = system.Date.today();
        oportunidadNaturalContacto.ANEFI_Business_line__c = 'Fondos';
        oportunidadNaturalContacto.Producto_de_Interes__c = 'F001';
        oportunidadNaturalContacto.Fecha_efectiva_primer_aporte__c = system.date.today();
        oportunidadNaturalContacto.Entidad_financiera__c = entidadFinanciera.Id;
        oportunidadNaturalContacto.StageName = 'Firma de contrato';
        oportunidadNaturalContacto.Firmo_el_contrato__c  = true;
        oportunidadNaturalContacto.Cliente_hizo_el_pago__c = true;
        oportunidadNaturalContacto.Se_recopilo_cedula__c = true;        
        oportunidadNaturalContacto.Trader__c = '692212';
        oportunidadNaturalContacto.Complementarios__c = 'S';
        oportunidadNaturalContacto.Transaccion_cooparticipe__c = 'SI';
        oportunidadNaturalContacto.Numero_documento_deposito__c = '54222';
        oportunidadNaturalContacto.Forma_de_Pago__c  = 'CHEQ';
        oportunidadNaturalContacto.Moneda__c = '1';
        oportunidadNaturalContacto.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        insert oportunidadNaturalContacto;
        
        /*Se crea cliente natural con el nombre completo asociado*/
        Account clienteNaturalNombreCompleto = new Account();
        clienteNaturalNombreCompleto.Name = 'Ricardo Andres Salazar Moreno';
        clienteNaturalNombreCompleto.Nacionalidad__c = pais.Id;
        clienteNaturalNombreCompleto.Paga_impuestos__c = 'S';
        clienteNaturalNombreCompleto.Fecha_de_nacimiento__c = system.Date.today();
        clienteNaturalNombreCompleto.Genero__c = 'M';
        clienteNaturalNombreCompleto.Politicamente_expuesto__c = 'NO';
        clienteNaturalNombreCompleto.Actividad_Economica__c = actividadEconomica.Id;
        clienteNaturalNombreCompleto.Activo__c = 'Activo';
        clienteNaturalNombreCompleto.Tipo_de_identificacion__c = '1';
        clienteNaturalNombreCompleto.Numero_de_identificacion__c = '1485963214'; 
        clienteNaturalNombreCompleto.Phone = '+593 2 450 0178';        
        clienteNaturalNombreCompleto.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        clienteNaturalNombreCompleto.Pais_direccion_domicilio__c  = pais.Id;
        clienteNaturalNombreCompleto.Canton_direccion_domicilio__c  = canton.Id;
        clienteNaturalNombreCompleto.Telefono_domicilio__c  = '58522';
        clienteNaturalNombreCompleto.Calle_principal_direccion_domicilio__c = 'primera';        
        clienteNaturalNombreCompleto.Es_direccion_fiscal_direccion_domicilio__c  = 'S';     
        clienteNaturalNombreCompleto.Total_activos__c  = 120;
        clienteNaturalNombreCompleto.Total_pasivos__c = 10;
        clienteNaturalNombreCompleto.Total_patrimonio__c = 10;
        clienteNaturalNombreCompleto.Entidad_financiera__c = entidadFinanciera.Id;
        clienteNaturalNombreCompleto.Numero_de_cuenta_bancaria__c = '27855';
        clienteNaturalNombreCompleto.Tipo_de_cuenta_bancaria__c  = 'A';           
        insert clienteNaturalNombreCompleto;     
        
        /*Se crea oportunidad para cliente natural con nombre completo*/
        Opportunity oportunidadNaturalNombreCompleto = new Opportunity();
        oportunidadNaturalNombreCompleto.AccountId = clienteNaturalNombreCompleto.id;
        oportunidadNaturalNombreCompleto.Name = 'Ricardo Andres Salazar Moreno - CP-1';
        oportunidadNaturalNombreCompleto.Amount = 690;
        oportunidadNaturalNombreCompleto.CloseDate = system.Date.today();
        oportunidadNaturalNombreCompleto.ANEFI_Business_line__c = 'Fondos';
        oportunidadNaturalNombreCompleto.Producto_de_Interes__c = 'F001';
        oportunidadNaturalNombreCompleto.Fecha_efectiva_primer_aporte__c = system.date.today();
        oportunidadNaturalNombreCompleto.Entidad_financiera__c = entidadFinanciera.Id;
        oportunidadNaturalNombreCompleto.StageName = 'Firma de contrato';
        oportunidadNaturalNombreCompleto.Firmo_el_contrato__c  = true;
        oportunidadNaturalNombreCompleto.Cliente_hizo_el_pago__c = true;
        oportunidadNaturalNombreCompleto.Se_recopilo_cedula__c = true;        
        oportunidadNaturalNombreCompleto.Trader__c = '692212';
        oportunidadNaturalNombreCompleto.Complementarios__c = 'S';
        oportunidadNaturalNombreCompleto.Transaccion_cooparticipe__c = 'SI';
        oportunidadNaturalNombreCompleto.Numero_documento_deposito__c = '54222';
        oportunidadNaturalNombreCompleto.Forma_de_Pago__c  = 'CHEQ';
        oportunidadNaturalNombreCompleto.Moneda__c = '1';
        oportunidadNaturalNombreCompleto.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        insert oportunidadNaturalNombreCompleto;
        
        /*Se crea cliente natural con código de persona en Gestor*/
        Account clienteNaturalCodigoPersona = new Account();
        clienteNaturalCodigoPersona.Name = 'Cliente con código en Gestor';
        clienteNaturalCodigoPersona.Nacionalidad__c = pais.Id;
        clienteNaturalCodigoPersona.Paga_impuestos__c = 'S';
        clienteNaturalCodigoPersona.Fecha_de_nacimiento__c = system.Date.today();
        clienteNaturalCodigoPersona.Genero__c = 'M';
        clienteNaturalCodigoPersona.Politicamente_expuesto__c = 'NO';
        clienteNaturalCodigoPersona.Actividad_Economica__c = actividadEconomica.Id;
        clienteNaturalCodigoPersona.Activo__c = 'Activo';
        clienteNaturalCodigoPersona.Tipo_de_identificacion__c = '1';
        clienteNaturalCodigoPersona.Numero_de_identificacion__c = '1485963219'; 
        clienteNaturalCodigoPersona.Phone = '+593 2 450 0178';        
        clienteNaturalCodigoPersona.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        clienteNaturalCodigoPersona.Pais_direccion_domicilio__c  = pais.Id;
        clienteNaturalCodigoPersona.Canton_direccion_domicilio__c  = canton.Id;
        clienteNaturalCodigoPersona.Telefono_domicilio__c  = '58522';
        clienteNaturalCodigoPersona.Calle_principal_direccion_domicilio__c = 'primera';        
        clienteNaturalCodigoPersona.Es_direccion_fiscal_direccion_domicilio__c  = 'S';     
        clienteNaturalCodigoPersona.Total_activos__c  = 120;
        clienteNaturalCodigoPersona.Total_pasivos__c = 10;
        clienteNaturalCodigoPersona.Total_patrimonio__c = 10;
        clienteNaturalCodigoPersona.Entidad_financiera__c = entidadFinanciera.Id;
        clienteNaturalCodigoPersona.Numero_de_cuenta_bancaria__c = '27855';
        clienteNaturalCodigoPersona.Tipo_de_cuenta_bancaria__c  = 'A'; 
        clienteNaturalCodigoPersona.Codigo_persona_en_Gestor__c = '1028437';
        insert clienteNaturalCodigoPersona;     
        
        /*Se crea oportunidad para cliente natural con código en Gestor*/
        Opportunity oportunidadNaturalCodigoGestor = new Opportunity();
        oportunidadNaturalCodigoGestor.AccountId = clienteNaturalCodigoPersona.id;
        oportunidadNaturalCodigoGestor.Name = 'Oportunidad Gestor';
        oportunidadNaturalCodigoGestor.Amount = 690;
        oportunidadNaturalCodigoGestor.CloseDate = system.Date.today();
        oportunidadNaturalCodigoGestor.ANEFI_Business_line__c = 'Fondos';
        oportunidadNaturalCodigoGestor.Producto_de_Interes__c = 'F001';
        oportunidadNaturalCodigoGestor.Fecha_efectiva_primer_aporte__c = system.date.today();
        oportunidadNaturalCodigoGestor.Entidad_financiera__c = entidadFinanciera.Id;
        oportunidadNaturalCodigoGestor.StageName = 'Firma de contrato';
        oportunidadNaturalCodigoGestor.Firmo_el_contrato__c  = true;
        oportunidadNaturalCodigoGestor.Cliente_hizo_el_pago__c = true;
        oportunidadNaturalCodigoGestor.Se_recopilo_cedula__c = true;        
        oportunidadNaturalCodigoGestor.Trader__c = '692212';
        oportunidadNaturalCodigoGestor.Complementarios__c = 'S';
        oportunidadNaturalCodigoGestor.Transaccion_cooparticipe__c = 'SI';
        oportunidadNaturalCodigoGestor.Numero_documento_deposito__c = '54222';
        oportunidadNaturalCodigoGestor.Forma_de_Pago__c  = 'CHEQ';
        oportunidadNaturalCodigoGestor.Moneda__c = '1';
        oportunidadNaturalCodigoGestor.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Persona Natural').getRecordTypeId();
        insert oportunidadNaturalCodigoGestor;    
        
        ANEFI_Configuracion_Gestor_Web__c configuracionGestorWeb = new ANEFI_Configuracion_Gestor_Web__c();
        configuracionGestorWeb.Clave__c = 'GESTORGE';
        configuracionGestorWeb.Gestor_Token_App__c = 'anefi';
        configuracionGestorWeb.Gestor_Token_Env__c = 'cHJ1ZWJh';
        configuracionGestorWeb.Instancia__c = 'PRUEBAS';
        configuracionGestorWeb.URL__c = 'http://8.242.216.210:8100/gestor-api-rest';
        configuracionGestorWeb.Usuario__c = '	GESTOR';
        insert configuracionGestorWeb;
        
        ANEFI_Configuracion_Gestor_Web__c configuracionGestorWebProduccion = new ANEFI_Configuracion_Gestor_Web__c();
        configuracionGestorWebProduccion.Clave__c = 'GESTORGE';
        configuracionGestorWebProduccion.Gestor_Token_App__c = 'anefi';
        configuracionGestorWebProduccion.Gestor_Token_Env__c = 'cHJ1ZWJh';
        configuracionGestorWebProduccion.Instancia__c = 'PRODUCCION';
        configuracionGestorWebProduccion.URL__c = 'http://8.242.216.210:8100/gestor-api-rest';
        configuracionGestorWebProduccion.Usuario__c = '	GESTOR';
        configuracionGestorWebProduccion.SetupOwnerId = UserInfo.getUserId();
        insert configuracionGestorWebProduccion;
        
        ANEFI_API_Name__c loginApi = new ANEFI_API_Name__c();
        loginApi.Name = 'login';
        loginApi.URL_Name__c = '/nn/gw/autorizacion/login';
        insert loginApi;
        
        ANEFI_API_Name__c validacionRegistrosClienteApi = new ANEFI_API_Name__c();
        validacionRegistrosClienteApi.Name = 'validacionRegistrosCliente';
        validacionRegistrosClienteApi.URL_Name__c = '/gw/personas/validarRegistrosCliente';
        insert validacionRegistrosClienteApi;
        
        ANEFI_API_Name__c validacionListasNegrasApi = new ANEFI_API_Name__c();
        validacionListasNegrasApi.Name = 'validacionListasNegras';
        validacionListasNegrasApi.URL_Name__c = '/gw/personas/validarListasNegras';
        insert validacionListasNegrasApi;
        
        ANEFI_API_Name__c registroPersonaJuridicaApi = new ANEFI_API_Name__c();
        registroPersonaJuridicaApi.Name = 'registroPersonaJuridica';
        registroPersonaJuridicaApi.URL_Name__c = '/gw/personas/juridica';
        insert registroPersonaJuridicaApi;
        
        ANEFI_API_Name__c registroPersonaNaturalApi = new ANEFI_API_Name__c();
        registroPersonaNaturalApi.Name = 'registroPersonaNatural';
        registroPersonaNaturalApi.URL_Name__c = '/gw/personas/natural';
        insert registroPersonaNaturalApi;
        
        ANEFI_API_Name__c registroCuentaParticipeApi = new ANEFI_API_Name__c();
        registroCuentaParticipeApi.Name = 'registroCuentaParticipe';
        registroCuentaParticipeApi.URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe';
        insert registroCuentaParticipeApi;
        
        ANEFI_API_Name__c registroAporteApi = new ANEFI_API_Name__c();
        registroAporteApi.Name = 'registroAporte';
        registroAporteApi.URL_Name__c = '/gw/empresas/{codigoEmpresa}/productos/{codigoProducto}/participes/{codigoCliente}/cuentasParticipe/{numeroCuenta}/aportes';
        insert registroAporteApi;    
        
        ANEFI_API_Name__c actualizacionPersonaNaturalApi = new ANEFI_API_Name__c();
        actualizacionPersonaNaturalApi.Name = 'actualizarPersonaNatural';
        actualizacionPersonaNaturalApi.URL_Name__c = '/gw/personas/{codigoPersona}/natural';
        insert actualizacionPersonaNaturalApi;
        
        /*Se crea un usuario para notificación de respuesta de servicios de Gestor*/
        ANEFI_Usuario_notificacion_Gestor__c usuarioNotificacion = new ANEFI_Usuario_notificacion_Gestor__c();
        usuarioNotificacion.Correo_electronico__c = 'jbarco@prueba.com';
        usuarioNotificacion.Nombre__c = 'Julia Barco';
        insert usuarioNotificacion;
        
        /*Se crea parámetros generales*/
        ANEFI_Parametros_Generales__c parametrosGenerales = new ANEFI_Parametros_Generales__c();
        parametrosGenerales.Ruta_publica_logo_Anefi__c = 'Ruta prueba';
        insert parametrosGenerales;
        
    }
}