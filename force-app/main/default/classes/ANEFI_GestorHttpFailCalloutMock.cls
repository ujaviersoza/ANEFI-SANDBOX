@isTest
global class ANEFI_GestorHttpFailCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        System.debug('Usando Mock');
        // Crea una repsuesta falsa dependiendo el requerimiento
        String endpoint  = request.getEndpoint();
        HttpResponse response = new HttpResponse();
        if(endpoint.endsWith('/gw/personas/validarRegistrosCliente')){
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
            response.setStatusCode(200);
        }
        else if(endpoint.endsWith('/natural')){
            System.debug('Usando mock consulta persona natural');
            response.setHeader('Content-Type', 'application/json');
            response.setBody(
            '{"data": {' +
                 '"tipoPersona": "F",' +
                 '"primerNombre": "MARÍA",' +
                 '"segundoNombre": "MILENA",' +
                 '"primerApellido": "SOTO",' +
                 '"segundoApellido": "IDARRAGA",' +
                 '"codigoTipoIdentificacion": "1",' +
                 '"identificacion": "1053257965",' +
                 '"correoElectronico": "jbarco@heinsohn.com.co",' +
                 '"codigoPaisNacionalidad": "001",' +
                 '"pagaImpuestos": "S",' +
                 '"codigoTipoTelefonoCelular": "3",' +
                 '"telefonoCelular": "85622",' +
                 '"codigoPaisNacimiento": "001",' +
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
                 '"codigoPaisDireccionDomicilio": "001",' +
                 '"secuenciaProvinciaDireccionDomicilio": 1,' +
                 '"codigoProvinciaDireccionDomicilio": "217",' +
                 '"secuenciaCantonDireccionDomicilio": 2,' +
                 '"codigoCantonDireccionDomicilio": "21701",' +
                 '"secuenciaParroquiaDireccionDomicilio": null,' +
                 '"codigoParroquiaDireccionDomicilio": "",' +
                 '"callePrincipalDireccionDomicilio": "Primera",' +
                 '"referenciaDireccionDomicilio": "45222",' +
                 '"esDireccionFiscalDireccionDomicilio": "S",' +
                 '"codigoTipoTelefonoDomicilio": "1",' +
                 '"telefonoDomicilio": "85632",' +
                 '"codigoTipoEmpleo": "",' +
                 '"codigoTipoActividadEconomica": "Q871003",' +
                 '"politicamenteExpuesto": "DIR",' +
                 '"lugarTrabajo": "Droguería la alemana",' +
                 '"cargo": "Jefe / Supervisor / Responsable",' +
                 '"codigoTipoTelefonoOficina": "2",' +
                 '"telefonoOficina": "85222",' +
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
                 '"codigoEntidadFinancieraCuentaBancaria": "PICH",' +
                 '"numeroCuentaBancaria": "75633",' +
                 '"codigoTipoCuentaBancaria": "A",' +
                 '"nombreConyuge": "",' +
                 '"codigoTipoDependienteConyuge": "",' +
                 '"codigoTipoIdentificacionConyuge": "",' +
                 '"identificacionConyuge": ""}}');
            response.setStatusCode(200);
        }
        
        return response; 
    }
}