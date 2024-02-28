import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import consultarInformacionPersonaNaturalEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarInformacionPersonaNaturalEnGestor';
import consultarInformacionPersonaJuridicaEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarInformacionPersonaJuridicaEnGestor';
import consultarInformacionPersonaJuridicaEnGestorJson from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarInformacionPersonaJuridicaEnGestorJson';
import parseInformacionPersonaJuridicaEnGestorJson from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.parseInformacionPersonaJuridicaEnGestorJson';
import parseInformacionPersonaNaturalEnGestorJson from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.parseInformacionPersonaNaturalEnGestorJson';

import consultarRelacion from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.consultarRelacion';
import actualizarPersonaEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestor';
import registrarReferenciaBancariaEnGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.registrarReferenciaBancariaEnGestor';
import actualizarPersonaEnGestorCorreo from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.actualizarPersonaEnGestorCorreo';
import getStatusFromGestor from '@salesforce/apex/ANEFI_ConsultarClienteEnGestorController.markUpdatedOrNot';



import COD_GESTOR from '@salesforce/schema/Account.Codigo_persona_en_Gestor__c';

import ID_FIELD from '@salesforce/schema/Account.Id';
import NOMBRE_CUENTA_FIELD from '@salesforce/schema/Account.Name';
import TIPO_IDENTIFICACION_FIELD from '@salesforce/schema/Account.Tipo_de_identificacion__c';
import PrimerNombre_FIELD from '@salesforce/schema/Account.PrimerNombre__c';
import SegundoNombre_FIELD from '@salesforce/schema/Account.SegundoNombre__c';
import PrimerApellido_FIELD from '@salesforce/schema/Account.PrimerApellido__c';
import SegundoApellido_FIELD from '@salesforce/schema/Account.SegundoApellido__c';

import NUMERO_IDENTIFICACION_FIELD from '@salesforce/schema/Account.Numero_de_identificacion__c';
import TELEFONO_CELULAR_FIELD from '@salesforce/schema/Account.Telefono_celular__c';
import TELEFONO_FIELD from '@salesforce/schema/Account.Phone';
import CORREO_ELECTRONICO_FIELD from '@salesforce/schema/Account.Correo_electronico__c';
import ESTADO_CIVIL_FIELD from '@salesforce/schema/Account.Estado_civil__c';
import GENERO_FIELD from '@salesforce/schema/Account.Genero__c';
import POLITICAMENTE_EXPUESTO_FIELD from '@salesforce/schema/Account.Politicamente_expuesto__c';
import PAGA_IMPUESTOS_FIELD from '@salesforce/schema/Account.Paga_impuestos__c';
import NACIONALIDAD_FIELD from '@salesforce/schema/Account.Nacionalidad__c';
import FECHA_NACIMIENTO_FIELD from '@salesforce/schema/Account.Fecha_de_nacimiento__c';
import ACTIVIDAD_ECONOMICA_FIELD from '@salesforce/schema/Account.Actividad_Economica__c';
import CODIGO_GESTOR_FIELD from '@salesforce/schema/Account.Codigo_persona_en_Gestor__c';
import PAIS_DIRECCION_DOMICILIO_FIELD from '@salesforce/schema/Account.Pais_direccion_domicilio__c';
import CANTON_DIRECCION_DOMICILIO_FIELD from '@salesforce/schema/Account.Canton_direccion_domicilio__c';
import CALLE_PRINCIPAL_DIRECCION_DOMICILIO_FIELD from '@salesforce/schema/Account.Calle_principal_direccion_domicilio__c';
import REFERENCIA_DIRECCION_DOMICILIO_FIELD from '@salesforce/schema/Account.Referencia_direccion_domicilio__c';
import DIRECCION_FISCAL_FIELD from '@salesforce/schema/Account.Es_direccion_fiscal_direccion_domicilio__c';
import TELEFONO_DOMICILIO_FIELD from '@salesforce/schema/Account.Telefono_domicilio__c';

import TOTAL_ACTIVOS_FIELD from '@salesforce/schema/Account.Total_activos__c';
import TOTAL_PASIVOS_FIELD from '@salesforce/schema/Account.Total_pasivos__c';
import TOTAL_PATRIMONIO_FIELD from '@salesforce/schema/Account.Total_patrimonio__c';
import ENTIDAD_FINANCIERA_FIELD from '@salesforce/schema/Account.Entidad_financiera__c';
import TIPO_CUENTA_BANCARIA_FIELD from '@salesforce/schema/Account.Tipo_de_cuenta_bancaria__c';
import NUMERO_CUENTA_BANCARIA_FIELD from '@salesforce/schema/Account.Numero_de_cuenta_bancaria__c';

import CANTON_NACIMIENTO_FIELD from '@salesforce/schema/Account.Canton_de_nacimiento__c';
import TIPO_EMPLEO_FIELD from '@salesforce/schema/Account.Tipo_de_empleo__c';

import TIPO_PERSONA_JURIDICA_FIELD from '@salesforce/schema/Account.Tipo_de_persona_juridica__c';
import FECHA_CONSTITUCION_FIELD from '@salesforce/schema/Account.Fecha_de_constitucion__c';
import INGRESOS_ANUALES_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import TOTAL_GASTOS_FIELD from '@salesforce/schema/Account.Total_gastos__c';
import NUMERO_DIRECCION_TRABAJO_FIELD from '@salesforce/schema/Account.Numero_direccion_trabajo__c';
import CALLE_PRINCIPAL_DIRECCION_TRABAJO_FIELD from '@salesforce/schema/Account.Calle_principal_direccion_trabajo__c';
import INTERSECCION_DIRECCION_TRABAJO_FIELD from '@salesforce/schema/Account.Interseccion_direccion_trabajo__c';
import NUMERO_DIRECCION_TRIBUTARIA_FIELD from '@salesforce/schema/Account.Numero_direccion_tributaria__c';
import CALLE_PRINCIPAL_DIRECCION_TRIBUTARIA_FIELD from '@salesforce/schema/Account.Calle_principal_direccion_tributaria__c';
import INTERSECCION_DIRECCION_TRIBUTARIA_FIELD from '@salesforce/schema/Account.Interseccion_direccion_tributaria__c';
import ID_REPRESENTANTE_FIELD from '@salesforce/schema/Account.Identificacion_representante_legal__c';
import CARGO_REPRESENTANTE_FIELD from '@salesforce/schema/Account.Cargo_representante_legal__c';
import PAIS_DIRECCION_TRABAJO_FIELD from '@salesforce/schema/Account.Pais_direccion_trabajo__c';
import PAIS_DIRECCION_TRIBUTARIA_FIELD from '@salesforce/schema/Account.Pais_direccion_tributaria__c';
import SINCRONIZADO_GESTOR_FIELD from '@salesforce/schema/Account.ANEFI_actualizado_en_Gestor__c';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

const CLIENTE_FIELDS = [COD_GESTOR,NUMERO_CUENTA_BANCARIA_FIELD];

const estadosComponente = Object.freeze({
    "cargando": 1,
    "sincronizado": 2,
    "noSincronizado": 3,
    "noExisteEnGestor": 4,
    "informacionGestor": 5,
    "error": 6
})

export default class Anefi_consultarClienteEnGestor extends NavigationMixin(LightningElement) {

    @api recordId;

    @track informacionEnGestor;
    @track direccionDomicilioEnGestor;
    @track informacionFinancieraEnGestor;
    @track informacionDireccionTrabajoEnGestor;
    @track informacionDireccionTributariaEnGestor;
    @track informacionAdicionalEnGestor;

    @track cargandoVisible = true;
    @track sincronizadoVisible = false;
    @track noSincronizadoVisible = false;
    @track errorVisible = false;
    @track noExisteEnGestorVisible = false;
    @track informacionGestorVisible = false;
    @track codigoEstadoCivil = '';
    @track crearReferenciaBancariaVisible = false;
    @track clienteCodigoGestor = false;
    @track actualizarReferenciaBancariaVisible = false;
    @track numeroCuentaBancariaActual = '';
    @track actualizarCorreoElectronico = false;
    @track buttonTrue = false;
    correoprincipal;
    esDireccionEstadoCuenta;
    actualizarCorreo;
    @track juridico = false;
    

    @track error;
    @track fechaIngreso;    
    @track valorCorreoElectronicoPrincipal = '';
    cliente;
    clienteGestor;
    
    activeSections = ['A', 'B', 'B1', 'B2', 'C'];   
    
    connectedCallback() {
        console.log('In connected call back function....');
        getStatusFromGestor({clienteId: this.recordId})
            .then((data) => {                
                console.log('REVISION CORRECTA '+data);

            })
            .catch((error) => {
                console.log('In connected call back error....');

                console.log('Error is', error); 
            });
    }

    @wire(getRecord, { recordId: '$recordId', fields: CLIENTE_FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data);
            this.clienteCodigoGestor = getFieldValue(data, COD_GESTOR);
            this.numeroCuentaBancariaActual = getFieldValue(data, NUMERO_CUENTA_BANCARIA_FIELD);
            //this.cliente = data;
            console.log('recordTypeInfo.name;' + data.recordTypeInfo.name);
            if (this.clienteCodigoGestor) {
                //this.cambiarEstado(estadosComponente.noSincronizado);
                this.cliente = data;
                this.cambiarEstado(estadosComponente.sincronizado);
            }
            else {
                this.cliente = data;
                this.cambiarEstado(estadosComponente.noSincronizado);
            }

            if(data.recordTypeInfo.name == 'Persona Jurídica'){
                this.juridico = true;
            }
        }
        else if (error) {
            console.log(error);
            this.error = error;
            this.cambiarEstado(estadosComponente.error);
        }
    }


    @wire(getRecord, { recordId: "$recordId", fields: [SINCRONIZADO_GESTOR_FIELD] })
    accountStatusGestor;
  
    get isUpdated() {
        console.log('REVISION value '+getFieldValue(this.accountStatusGestor.data, SINCRONIZADO_GESTOR_FIELD));
        return getFieldValue(this.accountStatusGestor.data, SINCRONIZADO_GESTOR_FIELD);
      }

    get esJuridico() {
        let resp = false;
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Jurídica') {
            resp = true;
            this.juridico= true;
        }
        console.log('resp'+ resp);
        return resp;
    }

    get esNatural() {
        let resp = false;
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Natural') {
            resp = true;
        }
        return resp;
    }    

    consultarInformacionPersonaNatural() {
        consultarInformacionPersonaNaturalEnGestor({ clienteId: this.recordId })
            .then((data) => {
                this.clienteGestor = data;                
                console.log(data);
                if (data.clienteExisteEnGestor && data.personaNaturalOut) {
                    let informacionCliente = [];
                    let nombreCliente = data.personaNaturalOut.primerNombre;
                    if (data.personaNaturalOut.segundoNombre) {
                        nombreCliente += " " + data.personaNaturalOut.segundoNombre;
                    }
                    if (data.personaNaturalOut.primerApellido) {
                        nombreCliente += " " + data.personaNaturalOut.primerApellido;
                    }
                    if (data.personaNaturalOut.segundoApellido) {
                        nombreCliente += " " + data.personaNaturalOut.segundoApellido;
                    }
                    this.codigoEstadoCivil = data.personaNaturalOut.codigoEstadoCivil;
                    informacionCliente.push({ tipo: 'texto', nombre: 'Nombre de la cuenta', valor: nombreCliente, apiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Tipo de identificación', valor: data.personaNaturalOut.codigoTipoIdentificacion, apiName: TIPO_IDENTIFICACION_FIELD, objectApiName: '' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Número de identificación', valor: data.personaNaturalOut.identificacion, apiName: '', objectApiName: '' });
                    informacionCliente.push({ tipo: 'telefono', nombre: 'Teléfono celular', valor: data.personaNaturalOut.telefonoCelular, apiName: '', objectApiName: '' });
                    informacionCliente.push({ tipo: 'telefono', nombre: 'Teléfono oficina', valor: data.personaNaturalOut.telefonoOficina, apiName: '', objectApiName: '' });
                    informacionCliente.push({ tipo: 'email', nombre: 'Correo electrónico', valor: data.personaNaturalOut.correoElectronico, apiName: '', objectApiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Estado Civil', valor: this.codigoEstadoCivil, apiName: ESTADO_CIVIL_FIELD, objectApiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Género', valor: data.personaNaturalOut.genero, apiName: GENERO_FIELD, objectApiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Políticamente expuesto', valor: data.personaNaturalOut.politicamenteExpuesto, apiName: POLITICAMENTE_EXPUESTO_FIELD, objectApiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Paga impuestos?', valor: data.personaNaturalOut.pagaImpuestos, apiName: PAGA_IMPUESTOS_FIELD, objectApiName: '' });
                    informacionCliente.push({ tipo: 'referencia', nombre: 'Nacionalidad', valor: data.personaNaturalOut.codigoPaisNacionalidad, apiName: '', objectApiName: 'ANEFI_Pais__c' });
                    informacionCliente.push({ tipo: 'referencia', nombre: 'País de nacimiento', valor: data.personaNaturalOut.codigoPaisNacimiento, apiName: '', objectApiName: 'ANEFI_Pais__c' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Fecha de Nacimiento', valor: data.personaNaturalOut.fechaNacimiento, apiName: '', objectApiName: '' });
                    informacionCliente.push({ tipo: 'referencia', nombre: 'Actividad Económica', valor: data.personaNaturalOut.codigoTipoActividadEconomica, apiName: '', objectApiName: 'ANEFI_Actividad_Economica__c' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Código persona en Gestor', valor: data.codigoPersonaEnGestor, apiName: '', objectApiName: '' });
                    this.informacionEnGestor = informacionCliente;
                    let direccionDomicilio = [];
                    direccionDomicilio.push({ tipo: 'referencia', nombre: 'País dirección domicilio', valor: data.personaNaturalOut.codigoPaisDireccionDomicilio, apiName: '', objectApiName: 'ANEFI_Pais__c' });
                    direccionDomicilio.push({ tipo: 'referencia', nombre: 'Cantón dirección domicilio', valor: data.personaNaturalOut.codigoCantonDireccionDomicilio, apiName: '', objectApiName: 'ANEFI_Canton__c' });
                    direccionDomicilio.push({ tipo: 'texto', nombre: 'Provincia dirección domicilio', valor: data.personaNaturalOut.codigoProvinciaDireccionDomicilio, apiName: '', objectApiName: '' });
                    direccionDomicilio.push({ tipo: 'texto', nombre: 'Calle principal dirección domicilio', valor: data.personaNaturalOut.callePrincipalDireccionDomicilio, apiName: '', objectApiName: '' });
                    direccionDomicilio.push({ tipo: 'texto', nombre: 'Referencia dirección domicilio', valor: data.personaNaturalOut.referenciaDireccionDomicilio, apiName: '', objectApiName: '' });
                    direccionDomicilio.push({ tipo: 'lista', nombre: 'Es dirección fiscal?', valor: data.personaNaturalOut.esDireccionFiscalDireccionDomicilio, apiName: DIRECCION_FISCAL_FIELD, objectApiName: '' });
                    direccionDomicilio.push({ tipo: 'telefono', nombre: 'Teléfono domicilio', valor: data.personaNaturalOut.telefonoDomicilio, apiName: '', objectApiName: '' });
                    this.direccionDomicilioEnGestor = direccionDomicilio;
                    let informacionFinanciera = [];
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total activos', valor: data.personaNaturalOut.totalActivos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total pasivos', valor: data.personaNaturalOut.totalPasivos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total patrimonio', valor: data.personaNaturalOut.totalPatrimonio, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'referencia', nombre: 'Entidad financiera', valor: data.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria, apiName: '', objectApiName: 'ANEFI_Entidad_financiera__c' });
                    informacionFinanciera.push({ tipo: 'lista', nombre: 'Tipo de cuenta bancaria', valor: data.personaNaturalOut.codigoTipoCuentaBancaria, apiName: TIPO_CUENTA_BANCARIA_FIELD, objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'texto', nombre: 'Número de cuenta bancaria', valor: data.personaNaturalOut.numeroCuentaBancaria, apiName: '', objectApiName: '' });
                    this.informacionFinancieraEnGestor = informacionFinanciera;
                    let informacionAdicional = [];
                    informacionAdicional.push({ tipo: 'referencia', nombre: 'Cantón de Nacimiento', valor: data.personaNaturalOut.codigoCantonNacimiento, apiName: '', objectApiName: 'ANEFI_Canton__c' });
                    informacionAdicional.push({ tipo: 'texto', nombre: 'Provincia de nacimiento', valor: data.personaNaturalOut.codigoProvinciaNacimiento, apiName: '', objectApiName: '' });
                    informacionAdicional.push({ tipo: 'lista', nombre: 'Tipo de empleo', valor: data.personaNaturalOut.codigoTipoEmpleo, apiName: TIPO_EMPLEO_FIELD, objectApiName: '' });
                    this.informacionAdicionalEnGestor = informacionAdicional;
                    this.cambiarEstado(estadosComponente.informacionGestor);
                }
                else {
                    this.cambiarEstado(estadosComponente.noExisteEnGestor);
                }
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.cambiarEstado(estadosComponente.error);
            });
    }

    consultarInformacionPersonaJuridica() {
        consultarInformacionPersonaJuridicaEnGestorJson({ clienteId: this.recordId })
            .then((data) => {
                
                console.log(data);
                //const jsonStringResult =  JSON.stringify(data);
                const jsonResult = JSON.parse(data);
                //console.log('.object  ->>' + Object.values(data.personaJuridicaOut.direccionesElectronicas) );
                this.clienteGestor = jsonResult;
                
 
                
                if (jsonResult.clienteExisteEnGestor && jsonResult.personaJuridicaOut) {
                     
                
                    let informacionCliente = [];

                    informacionCliente.push({ tipo: 'texto', nombre: 'Nombre de la cuenta', valor: jsonResult.personaJuridicaOut.nombre, apiName: '' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Tipo de identificación', valor: jsonResult.personaJuridicaOut.codigoTipoIdentificacion, apiName: TIPO_IDENTIFICACION_FIELD, objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Número de identificación', valor: jsonResult.personaJuridicaOut.identificacion, apiName: '', objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Tipo de persona jurídica', valor: jsonResult.personaJuridicaOut.codigoTipoPersonaJuridica, apiName: TIPO_PERSONA_JURIDICA_FIELD, objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Fecha de constitución', valor: jsonResult.personaJuridicaOut.fechaConstitucion, apiName: '', objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'lista', nombre: 'Políticamente expuesto', valor: jsonResult.personaJuridicaOut.politicamenteExpuesto, apiName: POLITICAMENTE_EXPUESTO_FIELD, objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'telefono', nombre: 'Teléfono', valor: jsonResult.personaJuridicaOut.telefonoConvencional, apiName: '', objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'telefono', nombre: 'Teléfono celular', valor: jsonResult.personaJuridicaOut.telefonoCelular, apiName: '', objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'referencia', nombre: 'Nacionalidad', valor: jsonResult.personaJuridicaOut.codigoPaisNacionalidad, apiName: '', objectApiName: 'ANEFI_Pais__c' ,valueCheckBox:''});
                    informacionCliente.push({ tipo: 'referencia', nombre: 'Actividad Económica', valor: jsonResult.personaJuridicaOut.codigoTipoActividadEconomica, apiName: '', objectApiName: 'ANEFI_Actividad_Economica__c',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'texto', nombre: 'Código persona en Gestor', valor: jsonResult.codigoPersonaEnGestor, apiName: '', objectApiName: '',valueCheckBox:'' });
                    informacionCliente.push({ tipo: 'checkbox', nombre: 'Correos electronicos', valor: this.getValuesCorreoElectronico(jsonResult.personaJuridicaOut.direccionesElectronicas), apiName: '', objectApiName: '',valueCheckBox:this.valorCorreoElectronicoPrincipal });
                    
                    this.informacionEnGestor = informacionCliente;

                    let informacionFinanciera = [];
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Ingresos anuales', valor: jsonResult.personaJuridicaOut.totalIngresos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total activos', valor: jsonResult.personaJuridicaOut.totalActivos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total pasivos', valor: jsonResult.personaJuridicaOut.totalPasivos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'moneda', nombre: 'Total gastos', valor: jsonResult.personaJuridicaOut.totalGastos, apiName: '', objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'referencia', nombre: 'Entidad financiera', valor: jsonResult.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria, apiName: '', objectApiName: 'ANEFI_Entidad_financiera__c' });
                    informacionFinanciera.push({ tipo: 'lista', nombre: 'Tipo de cuenta bancaria', valor: jsonResult.personaJuridicaOut.codigoTipoCuentaBancaria, apiName: TIPO_CUENTA_BANCARIA_FIELD, objectApiName: '' });
                    informacionFinanciera.push({ tipo: 'texto', nombre: 'Número de cuenta bancaria', valor: jsonResult.personaJuridicaOut.numeroCuentaBancaria, apiName: '', objectApiName: '' });
                    this.informacionFinancieraEnGestor = informacionFinanciera;

                    let direccionTrabajo = [];
                    direccionTrabajo.push({ tipo: 'referencia', nombre: 'País dirección trabajo', valor: jsonResult.personaJuridicaOut.codigoPaisDireccionTrabajo, apiName: '', objectApiName: 'ANEFI_Pais__c' });
                    direccionTrabajo.push({ tipo: 'texto', nombre: 'Número dirección trabajo', valor: jsonResult.personaJuridicaOut.numeroDireccionTrabajo, apiName: '', objectApiName: '' });
                    direccionTrabajo.push({ tipo: 'texto', nombre: 'Calle principal dirección trabajo', valor: jsonResult.personaJuridicaOut.callePrincipalDireccionTrabajo, apiName: '', objectApiName: '' });
                    direccionTrabajo.push({ tipo: 'texto', nombre: 'Intersección dirección trabajo', valor: jsonResult.personaJuridicaOut.interseccionDireccionTrabajo, apiName: '', objectApiName: '' });
                    this.informacionDireccionTrabajoEnGestor = direccionTrabajo;

                    let direccionTributaria = [];
                    direccionTributaria.push({ tipo: 'referencia', nombre: 'País dirección tributaria', valor: jsonResult.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria, apiName: '', objectApiName: 'ANEFI_Pais__c' });
                    direccionTributaria.push({ tipo: 'texto', nombre: 'Número dirección tributaria', valor: jsonResult.personaJuridicaOut.numeroDireccionResidenciaTributaria, apiName: '', objectApiName: '' });
                    direccionTributaria.push({ tipo: 'texto', nombre: 'Calle principal dirección tributaria', valor: jsonResult.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria, apiName: '', objectApiName: '' });
                    direccionTributaria.push({ tipo: 'texto', nombre: 'Intersección dirección tributaria', valor: jsonResult.personaJuridicaOut.interseccionDireccionResidenciaTributaria, apiName: '', objectApiName: '' });
                    this.informacionDireccionTributariaEnGestor = direccionTributaria;

                    let informacionAdicional = [];
                    informacionAdicional.push({ tipo: 'texto', nombre: 'Identificación representante legal', valor: jsonResult.personaJuridicaOut.representanteLegal, apiName: '', objectApiName: '' });
                    informacionAdicional.push({ tipo: 'texto', nombre: 'Cargo representante legal', valor: jsonResult.personaJuridicaOut.cargoRepresentanteLegal, apiName: '', objectApiName: '' });
                    this.informacionAdicionalEnGestor = informacionAdicional;

                    this.cambiarEstado(estadosComponente.informacionGestor);
                }
                else {
                    this.cambiarEstado(estadosComponente.noExisteEnGestor);
                }
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.cambiarEstado(estadosComponente.error);
            });
    }

     getValuesCorreoElectronico(correosArray){

        var correos = [];
        for (var i = 0; i < correosArray.length; i++) {

            console.log('value correo ->' + correosArray[i]['correoElectronico']);
            correos.push({label : correosArray[i]['correoElectronico'], value : correosArray[i]['correoElectronico']});
            this.valorCorreoElectronicoPrincipal = correosArray[i]['correoElectronico'];
            if(correosArray[i]['principal'] ==='S'){
                this.valorCorreoElectronicoPrincipal = correosArray[i]['correoElectronico'];
            }
            console.log('value principal ->' + correosArray[i]['principal']);
        }
         
        return correos;
    }
    actualizarInformacionPersonaNatural() {
        console.log("sincronizando");
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        let nombreCuenta = this.clienteGestor.personaNaturalOut.primerNombre;
        if (this.clienteGestor.personaNaturalOut.segundoNombre) {
            nombreCuenta += " " + this.clienteGestor.personaNaturalOut.segundoNombre;
        }
        if (this.clienteGestor.personaNaturalOut.primerApellido) {
            nombreCuenta += " " + this.clienteGestor.personaNaturalOut.primerApellido;
        }
        if (this.clienteGestor.personaNaturalOut.segundoApellido) {
            nombreCuenta += " " + this.clienteGestor.personaNaturalOut.segundoApellido;
        }
         
        console.log("nombreCuenta" + nombreCuenta);
        console.log("this.codigoEstadoCivil" + this.codigoEstadoCivil);
        
        fields[NOMBRE_CUENTA_FIELD.fieldApiName] = nombreCuenta;
        fields[PrimerNombre_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.primerNombre;
        fields[SegundoNombre_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.segundoNombre;
        fields[PrimerApellido_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.primerApellido;
        fields[SegundoApellido_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.segundoApellido;                        
        fields[TIPO_IDENTIFICACION_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.codigoTipoIdentificacion;
        fields[NUMERO_IDENTIFICACION_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.identificacion;
        fields[TELEFONO_CELULAR_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.telefonoCelular;
        fields[TELEFONO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.telefonoDomicilio;
        fields[CORREO_ELECTRONICO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.correoElectronico;
        fields[ESTADO_CIVIL_FIELD.fieldApiName] = this.codigoEstadoCivil;
        fields[GENERO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.genero;
        fields[POLITICAMENTE_EXPUESTO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.politicamenteExpuesto;
        fields[PAGA_IMPUESTOS_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.pagaImpuestos;
        fields[FECHA_NACIMIENTO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.fechaNacimiento;
        fields[CODIGO_GESTOR_FIELD.fieldApiName] = this.clienteGestor.codigoPersonaEnGestor;
        fields[CALLE_PRINCIPAL_DIRECCION_DOMICILIO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.callePrincipalDireccionDomicilio;
        fields[REFERENCIA_DIRECCION_DOMICILIO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.referenciaDireccionDomicilio;
        fields[DIRECCION_FISCAL_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.esDireccionFiscalDireccionDomicilio;
        fields[TELEFONO_DOMICILIO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.telefonoDomicilio;
        fields[TOTAL_ACTIVOS_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.totalActivos;
        fields[TOTAL_PASIVOS_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.totalPasivos;
        fields[TOTAL_PATRIMONIO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.totalPatrimonio;
        fields[TIPO_CUENTA_BANCARIA_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.codigoTipoCuentaBancaria;
        fields[NUMERO_CUENTA_BANCARIA_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.numeroCuentaBancaria;
        fields[TIPO_EMPLEO_FIELD.fieldApiName] = this.clienteGestor.personaNaturalOut.codigoTipoEmpleo;
        consultarRelacion({ objectApiName: 'ANEFI_Pais__c', codigo: this.clienteGestor.personaNaturalOut.codigoPaisNacionalidad })
            .then((paisNacionalidad) => {                
                fields[NACIONALIDAD_FIELD.fieldApiName] = paisNacionalidad;

                consultarRelacion({ objectApiName: 'ANEFI_Actividad_Economica__c', codigo: this.clienteGestor.personaNaturalOut.codigoTipoActividadEconomica })
                    .then((actividadEconomica) => {                        
                        fields[ACTIVIDAD_ECONOMICA_FIELD.fieldApiName] = actividadEconomica;

                        consultarRelacion({ objectApiName: 'ANEFI_Pais__c', codigo: this.clienteGestor.personaNaturalOut.codigoPaisDireccionDomicilio })
                            .then((paisDireccionDomicilio) => {                                
                                fields[PAIS_DIRECCION_DOMICILIO_FIELD.fieldApiName] = paisDireccionDomicilio;

                                consultarRelacion({ objectApiName: 'ANEFI_Canton__c', codigo: this.clienteGestor.personaNaturalOut.codigoCantonDireccionDomicilio })
                                    .then((cantonDireccionDomicilio) => {                                        
                                        fields[CANTON_DIRECCION_DOMICILIO_FIELD.fieldApiName] = cantonDireccionDomicilio;

                                        consultarRelacion({ objectApiName: 'ANEFI_Entidad_financiera__c', codigo: this.clienteGestor.personaNaturalOut.codigoEntidadFinancieraCuentaBancaria })
                                            .then((entidadFinanciera) => {                                                
                                                fields[ENTIDAD_FINANCIERA_FIELD.fieldApiName] = entidadFinanciera;

                                                consultarRelacion({ objectApiName: 'ANEFI_Canton__c', codigo: this.clienteGestor.personaNaturalOut.codigoCantonNacimiento })
                                                    .then((cantonNacimiento) => {                                                        
                                                        fields[CANTON_NACIMIENTO_FIELD.fieldApiName] = cantonNacimiento;

                                                        const recordInput = { fields };
                                                        updateRecord(recordInput)
                                                            .then(() => {
                                                                this.cambiarEstado(estadosComponente.sincronizado);
                                                                this.dispatchEvent(
                                                                    new ShowToastEvent({
                                                                        title: 'Confirmación',
                                                                        message: 'Cliente actualizado',
                                                                        variant: 'success'
                                                                    })
                                                                );
                                                            })
                                                            .catch(error => {
                                                                console.log(JSON.stringify(error));
                                                                let mensajeError = error.body.message;
                                                                if( error.body.output && error.body.output.fieldErrors){   
                                                                    for (const prop in error.body.output.fieldErrors) {                
                                                                        let fieldErrorObject = error.body.output.fieldErrors[prop][0];                
                                                                        mensajeError = `${mensajeError} Campo: ${fieldErrorObject.fieldLabel} Detalle: ${fieldErrorObject.message}`;
                                                                    }           
                                                                }   
                                                                this.cambiarEstado(estadosComponente.error);
                                                                this.dispatchEvent(
                                                                    new ShowToastEvent({
                                                                        title: 'Error creating record',
                                                                        message: mensajeError,
                                                                        variant: 'error'
                                                                    })
                                                                );
                                                            });
                                                    })
                                                    .catch(error => {
                                                        this.cambiarEstado(estadosComponente.error);
                                                    });
                                            })
                                            .catch(error => {
                                                this.cambiarEstado(estadosComponente.error);
                                            });
                                    })
                                    .catch(error => {
                                        this.cambiarEstado(estadosComponente.error);
                                    });
                            })
                            .catch(error => {
                                this.cambiarEstado(estadosComponente.error);
                            });
                    })
                    .catch(error => {
                        this.cambiarEstado(estadosComponente.error);
                    });
            })
            .catch(error => {
                this.cambiarEstado(estadosComponente.error);
            });
    }
    actualizarInformacionPersonaJuridicaCorreo() {
        console.log("sincronizando");
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[CORREO_ELECTRONICO_FIELD.fieldApiName] = this.actualizarCorreo;
        const recordInput = { fields };
        updateRecord(recordInput)
        console.log('update' + recordInput)
    }   
    actualizarInformacionPersonaJuridica() {
        console.log("sincronizando");
        let idRepresentante = this.clienteGestor.personaJuridicaOut.representanteLegal;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[NOMBRE_CUENTA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.nombre;
        fields[TIPO_IDENTIFICACION_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.codigoTipoIdentificacion;
        fields[NUMERO_IDENTIFICACION_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.identificacion;
        fields[TIPO_PERSONA_JURIDICA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.codigoTipoPersonaJuridica;
        fields[FECHA_CONSTITUCION_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.fechaConstitucion;
        fields[POLITICAMENTE_EXPUESTO_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.politicamenteExpuesto;
        fields[TELEFONO_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.telefonoConvencional;
        fields[TELEFONO_CELULAR_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.telefonoCelular;
        fields[CODIGO_GESTOR_FIELD.fieldApiName] = this.clienteGestor.codigoPersonaEnGestor;
        fields[INGRESOS_ANUALES_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.totalIngresos;
        fields[TOTAL_ACTIVOS_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.totalActivos;
        fields[TOTAL_PASIVOS_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.totalPasivos;
        fields[TOTAL_GASTOS_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.totalGastos;
        fields[TIPO_CUENTA_BANCARIA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.codigoTipoCuentaBancaria;
        fields[NUMERO_CUENTA_BANCARIA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.numeroCuentaBancaria;
        fields[NUMERO_DIRECCION_TRABAJO_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.numeroDireccionTrabajo;
        fields[CALLE_PRINCIPAL_DIRECCION_TRABAJO_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.callePrincipalDireccionTrabajo;
        fields[INTERSECCION_DIRECCION_TRABAJO_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.interseccionDireccionTrabajo;
        fields[NUMERO_DIRECCION_TRIBUTARIA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.numeroDireccionResidenciaTributaria;
        fields[CALLE_PRINCIPAL_DIRECCION_TRIBUTARIA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.callePrincipalDireccionResidenciaTributaria;
        fields[INTERSECCION_DIRECCION_TRIBUTARIA_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.interseccionDireccionResidenciaTributaria;
        fields[ID_REPRESENTANTE_FIELD.fieldApiName] = idRepresentante.toString();
        fields[CARGO_REPRESENTANTE_FIELD.fieldApiName] = this.clienteGestor.personaJuridicaOut.cargoRepresentanteLegal;
        fields[CORREO_ELECTRONICO_FIELD.fieldApiName] = this.valorCorreoElectronicoPrincipal;
        consultarRelacion({ objectApiName: 'ANEFI_Pais__c', codigo: this.clienteGestor.personaJuridicaOut.codigoPaisNacionalidad })
            .then((paisNacionalidad) => {
                fields[NACIONALIDAD_FIELD.fieldApiName] = paisNacionalidad;

                consultarRelacion({ objectApiName: 'ANEFI_Actividad_Economica__c', codigo: this.clienteGestor.personaJuridicaOut.codigoTipoActividadEconomica })
                    .then((actividadEconomica) => {
                        fields[ACTIVIDAD_ECONOMICA_FIELD.fieldApiName] = actividadEconomica;

                        consultarRelacion({ objectApiName: 'ANEFI_Pais__c', codigo: this.clienteGestor.personaJuridicaOut.codigoPaisDireccionTrabajo })
                            .then((paisDireccionTrabajo) => {
                                fields[PAIS_DIRECCION_TRABAJO_FIELD.fieldApiName] = paisDireccionTrabajo;

                                consultarRelacion({ objectApiName: 'ANEFI_Pais__c', codigo: this.clienteGestor.personaJuridicaOut.codigoPaisDireccionResidenciaTributaria })
                                    .then((paisDireccionTributaria) => {
                                        fields[PAIS_DIRECCION_TRIBUTARIA_FIELD.fieldApiName] = paisDireccionTributaria;

                                        consultarRelacion({ objectApiName: 'ANEFI_Entidad_financiera__c', codigo: this.clienteGestor.personaJuridicaOut.codigoEntidadFinancieraCuentaBancaria })
                                            .then((entidadFinanciera) => {
                                                fields[ENTIDAD_FINANCIERA_FIELD.fieldApiName] = entidadFinanciera;

                                                const recordInput = { fields };
                                                updateRecord(recordInput)
                                                    .then(() => {
                                                        this.cambiarEstado(estadosComponente.sincronizado);
                                                           this.dispatchEvent(
                                                            new ShowToastEvent({
                                                                title: 'Confirmación',
                                                                message: 'Cliente actualizado',
                                                                variant: 'success'
                                                            })
                                                        );
                                                    })
                                                    .catch(error => {
                                                        this.dispatchEvent(
                                                            new ShowToastEvent({
                                                                title: 'Error creando el registro',
                                                                message: error.body.message,
                                                                variant: 'error'
                                                            })
                                                        );
                                                    });
                                            })
                                            .catch(error => {
                                            });
                                    })
                                    .catch(error => {
                                    });
                            })
                            .catch(error => {
                            });
                    })
                    .catch(error => {
                    });
            })
            .catch(error => {
            });
    }

    handleSynchronize() {
        this.cambiarEstado(estadosComponente.cargando);
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Jurídica') {
            this.actualizarInformacionPersonaJuridica();
        }
        else if (clienteRecordTypeName == 'Persona Natural') {
            this.actualizarInformacionPersonaNatural();
        }
    }

    handleSearch() {
        this.cambiarEstado(estadosComponente.cargando);
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Jurídica') {
            this.consultarInformacionPersonaJuridica();
        }
        else if (clienteRecordTypeName == 'Persona Natural') {
            this.consultarInformacionPersonaNatural();
        }
    }
    
    consultarInformacionPersonaJuridicaACRM() {
        parseInformacionPersonaJuridicaEnGestorJson({ clienteId: this.recordId })
            .then((data) => {
                
                console.log(data);
                //const jsonStringResult =  JSON.stringify(data);
                const jsonResult = JSON.parse(data);
                //console.log('.object  ->>' + Object.values(data.personaJuridicaOut.direccionesElectronicas) );
                this.clienteGestor = jsonResult;
                console.log('DATA RETURN '+jsonResult);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Confirmación',
                        message: 'Cliente actualizado desde Gestor',
                        variant: 'success'
                    })
                );
                this.cambiarEstado(estadosComponente.sincronizado);
                window.location.reload();
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.cambiarEstado(estadosComponente.error);
            });
    }


    consultarInformacionPersonaNaturalACRM() {
        parseInformacionPersonaNaturalEnGestorJson({ clienteId: this.recordId })
            .then((data) => {
                
                console.log(data);
                //const jsonStringResult =  JSON.stringify(data);
                const jsonResult = JSON.parse(data);
                //console.log('.object  ->>' + Object.values(data.personaJuridicaOut.direccionesElectronicas) );
                this.clienteGestor = jsonResult;
                console.log('DATA RETURN '+jsonResult);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Confirmación',
                        message: 'Cliente actualizado desde Gestor',
                        variant: 'success'
                    })
                );
                this.cambiarEstado(estadosComponente.sincronizado);
                 window.location.reload();
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.cambiarEstado(estadosComponente.error);
            });
    }

    handleConsultarActualizarHaciaCRM() {
        this.cambiarEstado(estadosComponente.cargando);
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Jurídica') {
            this.consultarInformacionPersonaJuridicaACRM();
        }
         else if (clienteRecordTypeName == 'Persona Natural') {
            this.consultarInformacionPersonaNaturalACRM();
        }
    }

    /**
     * Cambia el estado actual del componente
     * @param estado al que se desea cambiar el componente
     */
    cambiarEstado(estado) {
        switch (estado) {
            case estadosComponente.cargando:
                this.cargandoVisible = true;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = false;  
                this.crearReferenciaBancariaVisible = false;  
                this.actualizarReferenciaBancariaVisible = false;
                this.actualizarCorreoElectronico = false;            
                break;
            case estadosComponente.sincronizado:
                this.cargandoVisible = false;
                this.sincronizadoVisible = true;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = false; 
                this.crearReferenciaBancariaVisible = false;    
                this.actualizarReferenciaBancariaVisible = false;
                this.actualizarCorreoElectronico = false;            
                break;
            case estadosComponente.noSincronizado:
                this.cargandoVisible = false;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = true;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = false;  
                this.crearReferenciaBancariaVisible = false; 
                this.actualizarReferenciaBancariaVisible = false;
                this.actualizarCorreoElectronico = false;              
                break;
            case estadosComponente.error:
                this.cargandoVisible = false;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = true;  
                this.crearReferenciaBancariaVisible = false;
                this.actualizarReferenciaBancariaVisible = false; 
                this.actualizarCorreoElectronico = false;              
                break;
            case estadosComponente.informacionGestor:
                this.cargandoVisible = false;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = true;
                this.errorVisible = false; 
                this.crearReferenciaBancariaVisible = false;
                this.actualizarReferenciaBancariaVisible = false; 
                this.actualizarCorreoElectronico = false;
                this.buttonTrue = false;

                break;
            case estadosComponente.error:
                this.cargandoVisible = false;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = true;    
                this.crearReferenciaBancariaVisible = false; 
                this.actualizarReferenciaBancariaVisible = false;    
                this.actualizarCorreoElectronico = false;        
                break;
                case estadosComponente.noExisteEnGestor:
                    this.cargandoVisible = false;
                    this.sincronizadoVisible = false;
                    this.noSincronizadoVisible = false;
                    this.noExisteEnGestorVisible = true;
                    this.informacionGestorVisible = false;
                    this.errorVisible = false;  
                    this.crearReferenciaBancariaVisible = false; 
                    this.actualizarReferenciaBancariaVisible = false; 
                    this.actualizarCorreoElectronico = false;                
                    break;            
            default:
                this.cargandoVisible = false;
                this.sincronizadoVisible = false;
                this.noSincronizadoVisible = false;
                this.noExisteEnGestorVisible = false;
                this.informacionGestorVisible = false;
                this.errorVisible = false;    
                this.crearReferenciaBancariaVisible = false;   
                this.actualizarReferenciaBancariaVisible = false;  
                this.actualizarCorreoElectronico = false;        
                break;
        }
    }



    handleUpdatePerson(){
        this.cambiarEstado(estadosComponente.cargando);
        actualizarPersonaEnGestor({ clienteId: this.recordId, clienteCodigoGestor: this.clienteCodigoGestor })
            .then((data) => {
                console.log(data);
                if(data){
                    console.log('Entra a mostrar el mensaje');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Confirmación',
                            message: 'Cliente actualizado en Gestor',
                            variant: 'success'
                        })
                    );
                    this.cambiarEstado(estadosComponente.sincronizado);
                }
                else{                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error actualizando cliente en Gestor',
                            message: 'Error actualizando cliente en Gestor',
                            variant: 'error'
                        })
                    );
                    this.cambiarEstado(estadosComponente.sincronizado);
                }
                
			})
            .catch(error => {
                console.log(JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error actualizando cliente en Gestor',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.cambiarEstado(estadosComponente.error);
            });
    }

    regInpFormAction() {
        var isValidVal = true;
        var inputFields = this.template.querySelectorAll('.reqInpFld');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
             
        });
         inputFields = this.template.querySelectorAll('.hijo-campo');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
             
        });
        return isValidVal;
    }

    handleUpdatePersonCorreo(){
        //expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        if(this.regInpFormAction()) {
            this.cambiarEstado(estadosComponente.cargando);
            console.log('this.correoprincipal' + this.correoprincipal);
            actualizarPersonaEnGestorCorreo({ clienteId: this.recordId, clienteCodigoGestor: this.clienteCodigoGestor, principal: this.correoprincipal , esDireccionEstadoCuenta: this.esDireccionEstadoCuenta, correoElectronico: this.actualizarCorreo})
                .then((data) => {
                    console.log('Data' + data);
                    if(data == '200' || data == '204'){
                        if(this.correoprincipal == 'S'){
                            this.actualizarInformacionPersonaJuridicaCorreo();
                        }    
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Confirmación',
                                message: 'Correo electrónico actualizado',
                                variant: 'success'
                            })
                        );
                        this.cambiarEstado(estadosComponente.sincronizado);
                    }
                    else{                    
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error actualizando correo electrónico',
                                message: 'Error actualizando correo electrónico',
                                variant: 'error'
                            })
                        );
                        this.cambiarEstado(estadosComponente.sincronizado);
                    }
                    
                })
                .catch(error => {
                    console.log(JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error actualizando correo electrónico',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    this.cambiarEstado(estadosComponente.error);
                });
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Debe de rellenar todos los campos obligatorios',
                    variant: 'error'
                })
            );
        }
    }

    handleCrearReferenciaBancaria(){          
        this.crearReferenciaBancariaVisible = true;        
        
    }

    handleActualizarReferenciaBancaria(){
        this.actualizarReferenciaBancariaVisible = true;
    }

    handleCerrarModal(event) {       
        this.crearReferenciaBancariaVisible = false;
    }

    handleCerrarModalActualizarReferencia(event) {       
        this.actualizarReferenciaBancariaVisible = false;
    }    

    handleFinalizarCreacionReferenciaBancaria(){
        this.cambiarEstado(estadosComponente.sincronizado);
    }

    //Mejora actualizar correo

    handleActualizarCorreoElectronico(){
        this.actualizarCorreoElectronico = true;
    }

    handleCerrarModalActualizarCorreoElectronico(event) {       
        this.actualizarCorreoElectronico = false;
    }  

    get optionsCorreoElectronicoPrincipal() {
        return [
            { label: 'Si', value: 'S' },
            { label: 'No', value: 'N' },
        ];
    }

    get optionsEsDireccionEstadoCuenta() {
        return [
            { label: 'Si', value: 'S' },
            { label: 'No', value: 'N' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
        let Buttontrue = false;
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        console.log('clienteRecordTypeName' + clienteRecordTypeName);
        if (clienteRecordTypeName == 'Persona Jurídica') {
            Buttontrue = true;
        }

    }

    handleChangeCorreoPrincipal(event) {
        this.correoprincipal = event.detail.value;
    };

    handleChangeEsDireccionEstadoCuenta(event) {
        this.esDireccionEstadoCuenta = event.detail.value;
    };

    handleChangeActualizarCorreo(event) {
        this.actualizarCorreo = event.detail.value;
    };

    handleSynchronize() {
        this.cambiarEstado(estadosComponente.cargando);
        let clienteRecordTypeName = this.cliente.recordTypeInfo.name;
        if (clienteRecordTypeName == 'Persona Jurídica') {
            this.actualizarInformacionPersonaJuridica();
        }
        else if (clienteRecordTypeName == 'Persona Natural') {
            this.actualizarInformacionPersonaNatural();
        }
    }
    
}