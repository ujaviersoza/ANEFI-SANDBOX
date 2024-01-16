public with sharing class ANEFISolicitudRescateController {
    
    public List<String> dataDate { get; set; }
    public List<String> rescate { get; set; }
    public List<String> acc { get; set; }

    public List<ANEFI_Rescates_Programados__c> dataRescate {get; set;}
    public List<Account> dataAcc {get; set;}

    public ANEFI_Rescates_Programados__c rescateProgramados { get; set; }
    public Id recordId { get; set; }
    private ApexPages.StandardController controller { get; set; }
    
    public ANEFISolicitudRescateController(ApexPages.StandardController controller) {

        dataDate = new List<String>();
        dataRescate = new List<ANEFI_Rescates_Programados__c>();
        dataAcc = new List<Account>();

        // DataRepresentLegal = new List<Contact>();
        this.controller = controller;
        this.rescateProgramados = (ANEFI_Rescates_Programados__c) controller.getRecord();
        Id rescateId = String.valueof(controller.getRecord().get('id'));
        recordId = ApexPages.currentPage().getParameters().get('id');
        

        rescate = new List<String>();
        acc = new List<String>();
        

        System.debug('id testss: ' + RecordId);
        System.debug('id testss: ' + ApexPages.currentPage());
        


        String[] getMes = new List<String>{
            'Enero',
                'Febrero',
                'Marzo',
                'Abril',
                'Mayo',
                'Junio',
                'Julio',
                'Agosto',
                'Septiembre',
                'Octubre',
                'Noviembre',
                'Diciembre'
                };
                    
        dataDate.add(String.valueOf(date.today().day()));
        dataDate.add(getMes[date.today().month() - 1]);
        dataDate.add(String.valueOf(date.today().year()));
        
        dataRescate = [
            Select Id, Name, AccountId__c, Anefi_FechaEfectiva__c, Tipo_Fondo__c, Anefi_NumeroCuentaProducto__c, ANEFI_Tipo_de_Rescate__c, Anefi_MontoRescate__c, Identificacion_Cuenta_Destino__c, Titular_de_la_cuenta__c, Banco_Destino__c, Tipo_de_cuenta__c, Anefi_NumeroCuentaDestino__c from ANEFI_Rescates_Programados__c
            WHERE id = :rescateId
        ];

        System.debug('\n\n\n\n\n\n\n\n==========================================');
        System.debug('DataDate: '+dataDate);
        System.debug('DataRescate: '+dataRescate);
        System.debug('\n\n\n\n\n\n\n\n==========================================');

        String name = (dataRescate[0].Name != null ? dataRescate[0].Name+'' : ' ');  
        String fechaEfectiva = (dataRescate[0].Anefi_FechaEfectiva__c != null ? dataRescate[0].Anefi_FechaEfectiva__c+'' : ' ');  
        String tipoFondo = (dataRescate[0].Tipo_Fondo__c !=null ? dataRescate[0].Tipo_Fondo__c+''+'' : ' ');  
        String numeroCuentaProducto = (dataRescate[0].Anefi_NumeroCuentaProducto__c != null ? dataRescate[0].Anefi_NumeroCuentaProducto__c+'' : ' '); 
        String tipoRescate = (dataRescate[0].ANEFI_Tipo_de_Rescate__c != null ? dataRescate[0].ANEFI_Tipo_de_Rescate__c+'' : ' ');  
        String montoRescate = (dataRescate[0].Anefi_MontoRescate__c != null ? dataRescate[0].Anefi_MontoRescate__c+'' : ' ');
        String identCuentaDestino = (dataRescate[0].Identificacion_Cuenta_Destino__c != null ? dataRescate[0].Identificacion_Cuenta_Destino__c+'' : ' ');
        String titularCuenta = (dataRescate[0].Titular_de_la_cuenta__c != null ? dataRescate[0].Titular_de_la_cuenta__c+'' : ' ');
        String bancoDestino = (dataRescate[0].Banco_Destino__c != null ? dataRescate[0].Banco_Destino__c+'' : ' ');
        String tipoCuenta = (dataRescate[0].Tipo_de_cuenta__c != null ? dataRescate[0].Tipo_de_cuenta__c+'' : ' ');
        String numeroCuentaDestino = (dataRescate[0].Anefi_NumeroCuentaDestino__c != null ? dataRescate[0].Anefi_NumeroCuentaDestino__c+'' : ' ');
        rescate.add(name);
        rescate.add(fechaEfectiva);
        rescate.add(tipoFondo);
        rescate.add(numeroCuentaProducto);
        rescate.add(tipoRescate);
        rescate.add(montoRescate);
        rescate.add(identCuentaDestino);
        rescate.add(titularCuenta);
        rescate.add(bancoDestino);
        rescate.add(tipoCuenta);
        rescate.add(numeroCuentaDestino);

        dataAcc = [
            SELECT
            Id,
            Name,
            Numero_de_identificacion__c
            FROM Account
            WHERE Id = :dataRescate[0].AccountId__c
        ];
        

        System.debug('\n\n\n\n\n\n\n\n==========================================');
        System.debug('DataDate: '+dataDate);
        System.debug('DataRescate: '+dataRescate);
        System.debug('DataAcc: '+dataAcc);
        System.debug('\n\n\n\n\n\n\n\n==========================================');

        String nameAccount = (dataAcc[0].Name != null ? dataAcc[0].Name+'' : ' ');  
        String numidAccount = (dataAcc[0].Numero_de_identificacion__c!=null ? dataAcc[0].Numero_de_identificacion__c+'' : ' ');
        
        acc.add(nameAccount);
        acc.add(numidAccount);
        

        System.debug('\n\n\n\n\n\n\n\n==========================================');
        System.debug('DataDate: '+dataDate);
        System.debug('DataRescate: '+dataRescate);
        System.debug('DataAcc: '+dataAcc);
        System.debug('\n\n\n\n\n\n\n\n==========================================');
    }
}