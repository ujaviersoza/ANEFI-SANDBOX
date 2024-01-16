@isTest
global class ANEFI_GestorHttpCalloutMock implements HttpCalloutMock {
    // Metodo de la interfaz
    public Integer statusCode = 201;
    global HTTPResponse respond(HTTPRequest request) {        
        // Crea una repsuesta falsa dependiendo el requerimiento
        String endpoint  = request.getEndpoint();   
        String metodoHTTP = request.getMethod();
        HttpResponse response = new HttpResponse();
        System.debug('endpoint mock ->' + endpoint);
        if(endpoint.endsWith('/parametrosParticipacion/montos')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"data": {"montoMinimoEgreso": 0,"montoMinimoIngreso": 0,"montoMinimoIncremento":0,"montoMinimoSaldo": 0,"diasSaldoMinimo": 0,"diasEsperaDesembolso": 0,"diasEntreDesembolsos": 0,"numeroDesembolsos": 0,"tipoComision": "string","valorComision": 0,"diasEfectivizacion": 0,"controlarDisponibilidadSoloPrimerAporte":"string","codigoImpuestoPorPermanencia": "string","codigoRetencionPorPermanencia": "string","fechaMinimaRescate":"string","disponibilidadEgresos": [{"numeroRango": 0,"diasDesde": 0,"diasHasta": 0,"porcentajeEgresoDesde": 0,"porcentajeEgresoHasta": 0,"codigoRetencion": "string","codigoPorcentajeRetencion": "string"}]}}');
            response.setStatusCode(200);
        }else if(endpoint.endsWith('/gw/personas/validarRegistrosCliente')){
            System.debug('Usando mock de consulta de registros clientes');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"data": {"tipoRelacion": "CLIENTE",' + 
            '"ocurrencias": [{"codigoPersona": 1028437,"participe": "SIN_PORTAL","fideicomitente": "NO","beneficiario": "NO"}]}}');
            response.setStatusCode(200);
        }
        else if(endpoint.endsWith('/nn/gw/autorizacion/login')){
            System.debug('Usando mock autorización');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"data": {"tokenType": "TIPO","accessToken": "TOKEN","expiresIn": 100,"refreshToken": "NO","estadoClave": "ESTADO"}}');
            response.setStatusCode(201);
        }
        else if(endpoint.endsWith('/juridica')){
            System.debug('Usando mock consulta persona jurídica');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": {'+
                '"tipoPersona": "J",'+
                '"codigoTipoPersonaJuridica": "2",'+
                '"nombre": "CREAMHELADO S.A",'+
                '"razonSocial": "CREAMHELADO S.A",'+
                '"codigoTipoIdentificacion": "2",'+
                '"identificacion": "1234567890123",'+
                '"codigoPaisNacionalidad": "001",'+
                '"codigoTipoActividadEconomica": "G461002",'+
                '"politicamenteExpuesto": "DIR",'+
                '"fechaConstitucion": "2002-07-04",'+
                '"capitalSocial": null,'+
                '"observaciones": "",'+
                '"telefonoConvencional": "852222",'+
                '"telefonoCelular": "856222",'+
                '"callePrincipalDireccionTrabajo": "primera",'+
                '"numeroDireccionTrabajo": "5255",'+
                '"interseccionDireccionTrabajo": "segunda",'+
                '"codigoPaisDireccionTrabajo": "001",'+
                '"secuenciaOrgGeoDireccionTrabajo": 2,'+
                '"codigoOrgGeoDireccionTrabajo": "21701",'+
                '"callePrincipalDireccionResidenciaTributaria": "",'+
                '"numeroDireccionResidenciaTributaria": "",'+
                '"interseccionDireccionResidenciaTributaria": "",'+
                '"codigoPaisDireccionResidenciaTributaria": "",'+
                '"secuenciaOrgGeoDireccionResidenciaTributaria": null,'+
                '"codigoOrgGeoDireccionResidenciaTributaria": "",'+
                '"totalActivos": 1250,'+
                '"totalPasivos": 520,'+
                '"totalIngresos": 8522,'+
                '"totalGastos": 30,'+
                '"representanteLegal": null,'+
                '"cargoRepresentanteLegal": "",'+
                '"codigoTipoEntidadFinancieraCuentaBancaria": "5",'+
                '"codigoEntidadFinancieraCuentaBancaria": "78113",'+
                '"numeroCuentaBancaria": "852222",'+
                '"codigoTipoCuentaBancaria": "A"}}');
            response.setStatusCode(200);
        }
        else if(endpoint.endsWith('/natural') && metodoHTTP.equals('GET')){
            System.debug('Usando mock consulta persona natural');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": {' +
                 '"tipoPersona": "F",' +
                 '"primerNombre": "Primer Nombre",' +
                 '"segundoNombre": "Segundo Nombre",' +
                 '"primerApellido": "Primer Apellido",' +
                 '"segundoApellido": "Segundo Apellido",' +
                 '"codigoTipoIdentificacion": "1",' +
                 '"identificacion": "1234567890",' +
                 '"correoElectronico": "prueba@correo.com",' +
                 '"codigoPaisNacionalidad": "PAIS001",' +
                 '"pagaImpuestos": "S",' +
                 '"codigoTipoTelefonoCelular": "3",' +
                 '"telefonoCelular": "1234567890",' +
                 '"codigoPaisNacimiento": "PAIS001",' +
                 '"secuenciaProvinciaNacimiento": null,' +
                 '"codigoProvinciaNacimiento": "",' +
                 '"secuenciaCantonNacimiento": null,' +
                 '"codigoCantonNacimiento": "",' +
                 '"secuenciaParroquiaNacimiento": null,' +
                 '"codigoParroquiaNacimiento": "",' +
                 '"fechaNacimiento": "1975-07-16",' +
                 '"codigoEstadoCivil": "SO",' +
                 '"genero": "M",' +
                 '"codigoTipoDireccionDomicilio": "D",' +
                 '"codigoPaisDireccionDomicilio": "PAIS001",' +
                 '"secuenciaProvinciaDireccionDomicilio": 1,' +
                 '"codigoProvinciaDireccionDomicilio": "217",' +
                 '"secuenciaCantonDireccionDomicilio": 2,' +
                 '"codigoCantonDireccionDomicilio": "CANTON001",' +
                 '"secuenciaParroquiaDireccionDomicilio": null,' +
                 '"codigoParroquiaDireccionDomicilio": "",' +
                 '"callePrincipalDireccionDomicilio": "Primera",' +
                 '"referenciaDireccionDomicilio": "45222",' +
                 '"esDireccionFiscalDireccionDomicilio": "S",' +
                 '"codigoTipoTelefonoDomicilio": "1",' +
                 '"telefonoDomicilio": "1234567",' +
                 '"codigoTipoEmpleo": "",' +
                 '"codigoTipoActividadEconomica": "ACTIVIDAD001",' +
                 '"politicamenteExpuesto": "DIR",' +
                 '"lugarTrabajo": "Droguería la alemana",' +
                 '"cargo": "Jefe / Supervisor / Responsable",' +
                 '"codigoTipoTelefonoOficina": "2",' +
                 '"telefonoOficina": "1234567",' +
                 '"totalActivos": 12500,' +
                 '"totalPasivos": 120,' +
                 '"totalPatrimonio": 321,' +
                 '"codigoTipoIngresoSueldoMensual": "",' +
                 '"valorIngresosSueldoMensual": null,' +
                 '"codigoTipoIngresoAhorros": "",' +
                 '"valorIngresosAhorros": null,' +
                 '"codigoTipoIngresoOtros": "",' +
                 '"valorIngresosOtros": null,' +
                 '"codigoTipoGastoMensual": "",' +
                 '"valorGastoMensual": null,' +
                 '"totalIngresosMensuales": 0,' +
                 '"totalEgresosMensuales": 0,' +
                 '"codigoTipoEntidadFinancieraCuentaBancaria": "1",' +
                 '"codigoEntidadFinancieraCuentaBancaria": "ENTIDAD001",' +
                 '"numeroCuentaBancaria": "1234567890",' +
                 '"codigoTipoCuentaBancaria": "A",' +
                 '"nombreConyuge": "",' +
                 '"codigoTipoDependienteConyuge": "",' +
                 '"codigoTipoIdentificacionConyuge": "",' +
                 '"identificacionConyuge": ""}}');
            response.setStatusCode(200);
        }
        else if(endpoint.endsWith('/cuentasParticipe')){
            System.debug('Usando mock consulta cuentas participe');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": [{' +
                 '"codigoProducto": "F001",' +
                 '"nombreProducto": "Fondo de inversión CP-1",' +
                 '"codigoAgencia": "1",' +
                 '"nombreAgencia": "ANEFI",' +
                 '"codigoTrader": "1021",' +
                 '"nombreTrader": "Andrea Palacios",' +
                 '"numeroCuenta": "10806",' +
                 '"codigoTipoCuenta": "A",' +
                 '"nombreTipoCuenta": "Ahorro",' +
                 '"fechaApertura": "2020-08-01",' +
                 '"estado": "A" }]}');
            response.setStatusCode(200);
        }else if(endpoint.endsWith('rescates')){
			System.debug('Usando mock registra rescates');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
                 '{"data": {"estado": "string","numeroTransaccion": "string"}}');
            response.setStatusCode(statusCode);            
        }
        else if(endpoint.contains('/movimientos')){
            System.debug('Usando mock consulta movimientos cuenta partícipe');
            response.setHeader('Content-Type', 'application/json');
            ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe  itemTransaccionCuentaParticipe= new ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe();
            itemTransaccionCuentaParticipe.numeroCuenta = '10806';
            itemTransaccionCuentaParticipe.numeroTransaccion = '15822';
            itemTransaccionCuentaParticipe.fechaTransaccion = '2020-08-01';
            itemTransaccionCuentaParticipe.codigoTipoTransaccion = 'IP';
            itemTransaccionCuentaParticipe.nombreTipoTransaccion = 'Aporte';
            itemTransaccionCuentaParticipe.tipoMovimiento = 'C';
            itemTransaccionCuentaParticipe.valorBruto = 10;
            itemTransaccionCuentaParticipe.valorRetenciones = 15;
            itemTransaccionCuentaParticipe.valorComisiones = 15;
            itemTransaccionCuentaParticipe.valorNeto = 15;
            itemTransaccionCuentaParticipe.numeroUnidades = 1.5;
            itemTransaccionCuentaParticipe.estado = 'Activo';
            
            ANEFI_ServicesDTO.Links links = new ANEFI_ServicesDTO.Links();
            links.first = 'primer link';
            links.last = 'ultimo link';
            links.next = '';
            links.prev = 'anterior link';
            links.self = 'primer link';
            
            ANEFI_ServicesDTO.Meta  meta = new ANEFI_ServicesDTO.Meta();
            meta.totalPages = 1;
            
            ANEFI_ServicesDTO.MovimientosCuentaParticipeOut movimientosCuentaParticipeOut = new ANEFI_ServicesDTO.MovimientosCuentaParticipeOut();
            List<ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe> itemsTransaccionCuenta = new List<ANEFI_ServicesDTO.ItemTransaccionCuentaParticipe>();
            itemsTransaccionCuenta.add(itemTransaccionCuentaParticipe);
            movimientosCuentaParticipeOut.data = itemsTransaccionCuenta;
            movimientosCuentaParticipeOut.links = links;
            movimientosCuentaParticipeOut.meta = meta;
            system.debug('antes de setear el body');
            String body = JSON.serialize(movimientosCuentaParticipeOut);
            system.debug('body:' + body);            
            response.setBody(body);
            response.setStatusCode(200);
        }
        else if(endpoint.contains('/saldos') && !endpoint.contains('saldosParticipes')){
            System.debug('Usando mock consulta saldos cuenta partícipe');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": {'+
            '"fechaConsultaSaldo": "2020-03-24",'+
            '"cuentasParticipe": ['+
              '{"numeroCuenta": "105215",'+
                '"capital": 4030.31,'+
                '"saldoInteres": -27.96,'+
                '"saldoTotal": 4002.35,'+
                '"saldoBloqueado": 0,'+
                '"saldoDisponible": 4002.35,'+
                '"saldoUnidades": 435.22,'+
                '"valorUnidad": 9.2,'+
                '"porcentajeParticipacion": 1.95,'+
                '"rendimiento": 0}]}}');
            response.setStatusCode(200);
        }
        else if(endpoint.contains('/valorRendimiento')){
            System.debug('Usando mock consulta rendimiento cuenta partícipe');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": {"valorRendimiento": 0}}');
            response.setStatusCode(200);
        }
        else if(endpoint.endsWith('/natural') && metodoHTTP.equals('PUT')){
            System.debug('Usando mock actualización persona natural');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('');
            response.setStatusCode(204);
        }
        else if(endpoint.endsWith('/referenciasBancarias') && metodoHTTP.equals('POST')){
            System.debug('Usando mock creación de referencia bancaria');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('');
            response.setStatusCode(201);
        }else if(endpoint.contains('F001/saldosParticipes')){            
            response.setHeader('Content-Type', 'application/json');
            ANEFI_ServicesDTO.ItemSaldosParticipe  itemSaldosParticipe= new ANEFI_ServicesDTO.ItemSaldosParticipe();
            itemSaldosParticipe.codigoCliente = 10806;
            itemSaldosParticipe.numeroCuenta = '15822';
            itemSaldosParticipe.capital = 260;
            itemSaldosParticipe.saldoInteres = 20;
            itemSaldosParticipe.saldoTotal = 50;
            itemSaldosParticipe.rendimiento = 60;
            itemSaldosParticipe.codigoTrader = 1234;
            itemSaldosParticipe.nombreTrader = 'Ricardo Lecaro';            
            
            ANEFI_ServicesDTO.Links links = new ANEFI_ServicesDTO.Links();
            links.first = 'primer link';
            links.last = 'ultimo link';
            links.next = '';
            links.prev = 'anterior link';
            links.self = 'primer link';
            
            ANEFI_ServicesDTO.Meta  meta = new ANEFI_ServicesDTO.Meta();
            meta.totalPages = 1;
            meta.fechaConsultaSaldos = '2019-02-08';
            
            ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut saldosCuentasParticipePorProductoOut = new ANEFI_ServicesDTO.SaldosCuentasParticipePorProductoOut();
            List<ANEFI_ServicesDTO.ItemSaldosParticipe> itemsSaldosParticipe = new List<ANEFI_ServicesDTO.ItemSaldosParticipe>();
            itemsSaldosParticipe.add(itemSaldosParticipe);
            saldosCuentasParticipePorProductoOut.data = itemsSaldosParticipe;
            saldosCuentasParticipePorProductoOut.links = links;
            saldosCuentasParticipePorProductoOut.meta = meta;
            system.debug('antes de setear el body');
            String body = JSON.serialize(saldosCuentasParticipePorProductoOut);
            system.debug('body:' + body);            
            response.setBody(body);
            response.setStatusCode(200);
        }else if(endpoint.endsWith('/cuentasBancarias?codigoMoneda=1&estado=ACT')){
			System.debug('Usando mock consulta cuentas bancarias rescates');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
             '{'+
              '"data": [ '+
               ' {' +
                '"codigoTipoEntidadFinanciera": "1",'+
                 '"codigoEntidadFinanciera": "1",'+
                  '"numeroCuenta": "2202816873",'+
                  '"codigoTipoCuenta": "1",'+
                  '"codigoMoneda": "1",'+
                  '"principal": "S",'+
                  '"estado": "A",'+
                  '"manejaCheques": "S",'+
                  '"esBeneficiario": false'+
                '}'+
              ']'+
            '}');
            response.setStatusCode(statusCode);            
        }else if(endpoint.endsWith('/referenciasBancarias?codigoMoneda=1&estado=ACT')){
			System.debug('Usando mock consulta referenciasBancarias');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
             '{'+
              '"data": [ '+
               ' {' +
                '"codigoTipoEntidadFinanciera": "1",'+
                 '"codigoEntidadFinanciera": "1",'+
                  '"numeroCuenta": "2202816873",'+
                  '"codigoTipoCuenta": "1",'+
                  '"codigoMoneda": "1",'+
                  '"principal": "S",'+
                  '"estado": "A",'+
                  '"manejaCheques": "S",'+
                  '"esBeneficiario": false'+
                '}'+
              ']'+
            '}');
            response.setStatusCode(statusCode);            
        }else if(endpoint.endsWith('/referenciasBancariasTerceros?codigoMoneda=1&estado=ACT')){
			System.debug('Usando mock consulta referenciasBancarias terceros');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
             '{'+
                '"data": [ { '+
               ' "cuentaBancaria": {' +
                '"codigoTipoEntidadFinanciera": "1",'+
                 '"codigoEntidadFinanciera": "1",'+
                  '"numeroCuenta": "2202816873",'+
                  '"codigoTipoCuenta": "1",'+
                  '"codigoMoneda": "1",'+
                  '"principal": "S",'+
                  '"estado": "A",'+
                  '"manejaCheques": "S",'+
                  '"esBeneficiario": false'+
                '} ,  "titular": { "nombre": "string", "codigoTipoIdentificacion": "string","nombreTipoIdentificacion": "string","identificacion": "string","denominacion": "string"}'+
                '}]'+
            '}');
            response.setStatusCode(statusCode);            
        }else if(endpoint.endsWith('/saldosDiariosPeriodo')){
             response.setHeader('Content-Type', 'application/json');
            response.setBody(
             '{'+
                '"data": [ { '+
				'"codigoProducto": "F001",'+
      			'"nombreProducto": "FONDO DE INVERSION ADMINISTRADO DE CORTO PLAZO CP - UNO",'+
      			'"numeroCuenta": "106701",'+
                '"saldosDiarios": ['+
                     '{'+
         			 '"fecha": "2022-06-30",'+
          			 '"numeroUnidades": 0.71138512,'+
                     '"valorUnidad": 116.48647585,'+
                     '"valorSaldo": 82.87'+
                      '}'+
                ']'+
                '}]'+
            '}');
            response.setStatusCode(statusCode);              
        }
        System.debug('response calloutMock' + response.getBody());
        return response; 
    }
}