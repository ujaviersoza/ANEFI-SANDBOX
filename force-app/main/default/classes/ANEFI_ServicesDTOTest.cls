@isTest
public class ANEFI_ServicesDTOTest {
    @isTest 
    static void test1(){
         Test.startTest();
		ANEFI_ServicesDTO.SaldosCuentasParticipeInput saldosC = new ANEFI_ServicesDTO.SaldosCuentasParticipeInput ();
        ANEFI_ServicesDTO.Oportunidad opp = new ANEFI_ServicesDTO.Oportunidad();
        //opp.clienteId = '';
        opp.codigoCuentaContable = '';
        //public Id oportunidadId;
        opp.tipoPersona = '';
        //public Id clienteId;
        //public Id propietarioId;
        opp.oportunidadNombre = '';
        opp.codigoPersonaEnGestor = 0;
        
        opp.numeroCuentaParticipe = '';
        opp.codigoProducto = '';
        opp.codigoTrader = '';
        opp.codigoCuentaContable = '';
        opp.complementarios = '';
        opp.transaccionCooparticipe = '';
        opp.numeroTransaccionAporte = '';
        opp.fechaEfectiva = '';
        opp.numeroDocumento = '';
        opp.codigoTipoFormaPago = '';
        opp.codigoMoneda = '';
        opp.codigoTipoEntidadFondo = '';
        opp.codigoEntidadFondo = '';
        opp.numeroCuentaFondo = '';
        opp.monto =0;
        System.assert(opp !=null);
        saldosC.codigoProducto = '';
        saldosC.fechaDesde = '';
        saldosC.fechaHasta = '';
        saldosC.pageNumber = 9;
        saldosC.pageSize = 0;
        System.assertEquals('',  saldosC.codigoProducto);
        System.assertEquals('',  saldosC.fechaDesde);
        System.assertEquals('',  saldosC.fechaHasta);
        System.assertEquals(9,  saldosC.pageNumber);    
        System.assertEquals(0,  saldosC.pageSize);  
		ANEFI_ServicesDTO.CustomNotificationAction cn = new ANEFI_ServicesDTO.CustomNotificationAction ();
		ANEFI_ServicesDTO.CustomNotificationActionInput incn = new ANEFI_ServicesDTO.CustomNotificationActionInput ();
        ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad rso = new ANEFI_ServicesDTO.RespuestaSincronizacionOportunidad();
        incn.body = '';
        incn.customNotifTypeId = '';
        incn.targetId = '';
        incn.title = '';
        incn.recipientIds = new List<String>();
        incn.recipientIds.add('s');
		cn.inputs = new List<ANEFI_ServicesDTO.CustomNotificationActionInput>();	
        cn.inputs.add(incn);
        System.assertEquals('', incn.body);
        System.assertEquals('', incn.customNotifTypeId);
        System.assertEquals('', incn.targetId);
        System.assertEquals('', incn.title);
        System.assertEquals(1,incn.recipientIds.size());
        System.assertEquals(1,cn.inputs.size());
        rso.codigoPersonaEnGestor = 1;
        rso.errorEnSincronizacion = false;
        rso.numeroCuentaParticipe = '';
        rso.numeroTransaccionAporte = '';
        rso.personaBloqueadaEnListasNegras = false;
        System.assertEquals(1,rso.codigoPersonaEnGestor);
        System.assertEquals(false,rso.errorEnSincronizacion);
        System.assertEquals(false,rso.personaBloqueadaEnListasNegras);
		System.assertEquals('', rso.numeroCuentaParticipe);     
        System.assertEquals('', rso.numeroTransaccionAporte);     
        Test.stopTest();  
    }
}