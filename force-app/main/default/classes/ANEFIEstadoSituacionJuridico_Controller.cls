/**
 * @description       : 
 * @author            : Jeffry Mejia
 * @group             : 
 * @last modified on  : 11-04-2022
 * @last modified by  : Jeffry Mejia
**/
public with sharing class ANEFIEstadoSituacionJuridico_Controller {
  
    public List<String> dataDate { get; set; }
    public List<Opportunity> dataOpp { get; set; }
    public List<Account> dataAcc { get; set; }    

    public List<String> Opp { get; set; }
    public List<String> Acc { get; set; }

    public Opportunity Opportunity { get; set; }
    public Id RecordId { get; set; }
    private ApexPages.StandardController controller { get; set; }
    public Decimal amountActivo {get;set;}
    public Decimal amountPasivo {get;set;}
    public Decimal totalPatrimonio {get;set;}
    public Decimal AnnualRevenue {get;set;}
    public Decimal totalGastos {get;set;}
    public ANEFIEstadoSituacionJuridico_Controller(ApexPages.StandardController controller) {

        dataDate = new List<String>();
        dataOpp = new List<Opportunity>();
        dataAcc = new List<Account>();

        this.controller = controller;
        this.Opportunity = (Opportunity) controller.getRecord();
        Id oppId = String.valueof(controller.getRecord().get('id'));
        RecordId = ApexPages.currentPage().getParameters().get('id');
        

        Opp = new List<String>();
        Acc = new List<String>();

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
        
        dataOpp = [ SELECT id, Name, Producto_de_Interes__c, Numero_oportunidad__c, AccountId FROM Opportunity WHERE id = :oppId ];

        String nameOpportunity = (dataOpp[0].Name != null ? dataOpp[0].Name+'' : ' ');          
        String prodInteresOpp = (dataOpp[0].Producto_de_Interes__c != null ? dataOpp[0].Producto_de_Interes__c+'' : ' ');
          
        Opp.add(nameOpportunity);
        Opp.add(prodInteresOpp);
        // Concatenado de Account.Pais_direccion_trabajo__r.Name +  Account.Provincia_direccion_trabajo__c + Account.Calle_principal_direccion_trabajo__c + Account.Interseccion_direccion_trabajo__c
        // Account.Phone
        // Account.Correo_electronico__c
        // Account.Representante_Legal__r.FirstName+ Account.Representante_Legal__r.MiddleName + Account.Representante_Legal__r.LastName
        // Account.representante_Legal__r.email
        // Account.representante_Legal__r.Numero_de_identificacion__c
        // Account.representante_Legal__r.Rol_en_la_empresa__c
        // account.Total_activos__c
        // account.Total_pasivos__c
        // account.Total_patrimonio__c
        // Account.Entidad_financiera__r.name
        // account.Numero_de_cuenta_bancaria__c
        // Quito 170135, Ecuador y fecha en que se genera el archivo


        dataAcc = [ SELECT Id, Name, Numero_de_identificacion__c, Fecha_de_constitucion__c, Actividad_Economica__r.Name,Actividad_Economica__r.Descripcion__c, Pais_direccion_trabajo__r.Name, Provincia_direccion_trabajo__c, 
        Calle_principal_direccion_trabajo__c, Tipo_de_cuenta_bancaria__c,AnnualRevenue,Total_gastos__c,
        Interseccion_direccion_trabajo__c, 
        Phone, 
        Correo_electronico__c, 
        Representante_Legal__r.FirstName, 
        Representante_Legal__r.MiddleName, 
        Representante_Legal__r.LastName, 
        representante_Legal__r.email,
        representante_Legal__r.Numero_de_identificacion__c,
        representante_Legal__r.Rol_en_la_empresa__c,
        Total_activos__c,
        Total_pasivos__c,
        Total_patrimonio__c,
        Entidad_financiera__r.name,
        Numero_de_cuenta_bancaria__c 
        FROM Account WHERE id = :dataOpp[0].AccountId ];

        String nameAccount = (dataAcc[0].Name != null ? dataAcc[0].Name+'' : ' ');
        String numidAccount = (dataAcc[0].Numero_de_identificacion__c!=null ? dataAcc[0].Numero_de_identificacion__c+'' : ' ');

        String dateConstAccount = (dataAcc[0].Fecha_de_constitucion__c != null ? dataAcc[0].Fecha_de_constitucion__c+'' : ' ');
        String actEcoAccount = (dataAcc[0].Actividad_Economica__r.Name != null ? dataAcc[0].Actividad_Economica__r.Name+' ' + dataAcc[0].Actividad_Economica__r.Descripcion__c : ' ');
        String paisDirTrabAccount = (dataAcc[0].Pais_direccion_trabajo__r.Name != null ? dataAcc[0].Pais_direccion_trabajo__r.Name+'' : ' ');
        String provDirTrabAccount = (dataAcc[0].Provincia_direccion_trabajo__c != null ? dataAcc[0].Provincia_direccion_trabajo__c+'' : ' ');
        String callePrinDirTrabAccount = (dataAcc[0].Calle_principal_direccion_trabajo__c != null ? dataAcc[0].Calle_principal_direccion_trabajo__c+'' : ' ');
        String intDirTrabAccount = (dataAcc[0].Interseccion_direccion_trabajo__c != null ? dataAcc[0].Interseccion_direccion_trabajo__c+'' : ' ');

        String phoneAccount = (dataAcc[0].Phone != null ? dataAcc[0].Phone+'' : ' ');
        String correoAccount = (dataAcc[0].Correo_electronico__c != null ? dataAcc[0].Correo_electronico__c+'' : ' ');

        String repFNAccount = (dataAcc[0].Representante_Legal__r.FirstName != null ? dataAcc[0].Representante_Legal__r.FirstName+'' : ' ');
        String repMNAccount = (dataAcc[0].Representante_Legal__r.MiddleName != null ? dataAcc[0].Representante_Legal__r.MiddleName+'' : ' ');
        String repLNAccount = (dataAcc[0].Representante_Legal__r.LastName != null ? dataAcc[0].Representante_Legal__r.LastName+'' : ' ');
        String repEmailAccount = (dataAcc[0].representante_Legal__r.email != null ? dataAcc[0].representante_Legal__r.email+'' : ' ');
        String repNumIdAccount = (dataAcc[0].representante_Legal__r.Numero_de_identificacion__c != null ? dataAcc[0].representante_Legal__r.Numero_de_identificacion__c+'' : ' ');
        String repRCompanyAccount = (dataAcc[0].Representante_Legal__r.Rol_en_la_empresa__c != null ? dataAcc[0].Representante_Legal__r.Rol_en_la_empresa__c+'' : ' ');

         amountActivo = (dataAcc[0].Total_activos__c != null ? dataAcc[0].Total_activos__c : 0);
         amountPasivo = (dataAcc[0].Total_pasivos__c != null ? dataAcc[0].Total_pasivos__c : 0);
        totalPatrimonio = amountActivo - amountPasivo;
        String totalPatAccount = (dataAcc[0].Total_patrimonio__c != null ? dataAcc[0].Total_patrimonio__c+'' : ' ');

        String entFinAccount = (dataAcc[0].Entidad_financiera__r.name != null ? dataAcc[0].Entidad_financiera__r.name+'' : ' ');
        String numCuentaBanAccount = (dataAcc[0].Numero_de_cuenta_bancaria__c != null ? dataAcc[0].Numero_de_cuenta_bancaria__c+'' : ' ');

        Acc.add(nameAccount);
        Acc.add(numidAccount);
       
        


        Acc.add(dateConstAccount);
        Acc.add(actEcoAccount);        
        Acc.add(paisDirTrabAccount);
        Acc.add(provDirTrabAccount);        
        Acc.add(callePrinDirTrabAccount);
        Acc.add(intDirTrabAccount);

        Acc.add(phoneAccount);
        Acc.add(correoAccount);

        Acc.add(repFNAccount);
        Acc.add(repMNAccount);  
        String [] Apellidos = repLNAccount.split(' ') ;
        Acc.add(repLNAccount);      
        Acc.add(repEmailAccount);
        Acc.add(repNumIdAccount);
        Acc.add(repRCompanyAccount);

        Acc.add(' ');        
        Acc.add(' ');
       Acc.add(' ');

        Acc.add(entFinAccount);
        Acc.add(numCuentaBanAccount);
       
       
        String pApellido = (Apellidos.size()>0) ? String.valueOf(Apellidos[0]) : '';
        String sApellido  = String.valueOf( Apellidos.size()>1 ? Apellidos[1] : '');
        Acc.add(pApellido);
        Acc.add(sApellido);
         Acc.add(dataAcc[0].Tipo_de_cuenta_bancaria__c);
        // Acc.add(intDirTrabAccount);

		totalGastos =dataAcc[0].Total_gastos__c;
		AnnualRevenue =  dataAcc[0].AnnualRevenue;


        System.debug('\n\n\n\n\n\n\n\n==========================================');
        System.debug('dataDate: '+dataDate);
        System.debug('dataOpp: '+Opp);
        System.debug('dataAcc: '+Acc);


    }
}