public with sharing class ANEFIDeclaracionFatcaPN {
    public List<String> DataDate { get; set; }
    public List<Opportunity> DataOpp { get; set; }
    public List<Account> DataAcc { get; set; }
    public List<	ANEFI_Actividad_Economica__c> DataActEco { get; set; }
    
    public List<ANEFI_Pais__c> DataNac { get; set; }
    public List<RecordType> DataRecTyp { get; set; }
    public List<ANEFI_Pais__c> DataPaisdir { get; set; }
    public List<ANEFI_Canton__c> DataDirCanton { get; set; }
    public List<Contact> DataRepresentLegal { get; set; }
    public String Dir { get; set; }
    public String nameAcc {get;set;}
    public String rolRepresentLegal {get;set;}
    public List<String> Opp { get; set; }
    public List<String> Acc { get; set; }
    public List<String> ActEco { get; set; }
    public List<String> Nac { get; set; }
    public List<String> RecTyp { get; set; }
    public List<String> Paisdir { get; set; }
    public List<String> DirCanton { get; set; }
    public List<String> RepresentLegal { get; set; }
    
    public Opportunity Opportunity { get; set; }
    public Id RecordId { get; set; }
    private ApexPages.StandardController controller { get; set; }
    public Decimal amountOpportunityS {get;set;}
    
    public ANEFIDeclaracionFatcaPN(ApexPages.StandardController controller) {
        
        DataDate = new List<String>();
        DataOpp = new List<Opportunity>();
        DataAcc = new List<Account>();
        DataActEco = new List<ANEFI_Actividad_Economica__c>();
        DataNac = new List<ANEFI_Pais__c>();
        DataRecTyp = new List<RecordType>();
        DataPaisdir = new List<ANEFI_Pais__c>();
        DataDirCanton = new List<ANEFI_Canton__c>();
        DataRepresentLegal = new List<Contact>();
        this.controller = controller;
        this.Opportunity = (Opportunity) controller.getRecord();
        Id OppId = String.valueof(controller.getRecord().get('id'));
        RecordId = ApexPages.currentPage().getParameters().get('id');
        
        
        Opp = new List<String>();
        Acc = new List<String>();
        ActEco = new List<String>();
        Nac = new List<String>();
        RecTyp = new List<String>();
        Paisdir = new List<String>();
        DirCanton = new List<String>();
        RepresentLegal = new List<String>();
        
      
        
        DataOpp = [
            SELECT id, Name, Numero_oportunidad__c, Amount,Forma_de_Pago__c,Numero_de_cuenta_fondo__c, CloseDate, AccountId
            FROM Opportunity
            WHERE id = :OppId
        ];
        
        String nameOpportunity = (DataOpp[0].Name != null ? DataOpp[0].Name+'' : ' ');  
        String numOpportunity = (DataOpp[0].Numero_oportunidad__c != null ? DataOpp[0].Numero_oportunidad__c+'' : ' ');  
        String amountOpportunity = (DataOpp[0].Amount !=null ? DataOpp[0].Amount+''+'' : ' ');  
        String fpOpportunity = (DataOpp[0].Forma_de_Pago__c != null ? DataOpp[0].Forma_de_Pago__c+'' : ' '); 
        String numaccountOpportunity = (DataOpp[0].Numero_de_cuenta_fondo__c != null ? DataOpp[0].Numero_de_cuenta_fondo__c+'' : ' ');  
        // String closedateOpportunity = (DataOpp.isEmpty() ? DataOpp[0].CloseDate+'' : ' ');  
        amountOpportunityS = DataOpp[0].Amount; 
        Opp.add(nameOpportunity);
        Opp.add(numOpportunity);
        Opp.add(amountOpportunity);
        Opp.add(fpOpportunity);
        Opp.add(numaccountOpportunity);
        // Opp.add(closedateOpportunity);  
        
        DataAcc = [
            SELECT
            Id,
            Name,
            Ciudad__c,
            Phone,
            Nacionalidad__c,
            RecordTypeId,
            Calle_principal_direccion_domicilio__c,
            Calle_principal_direccion_trabajo__c,
            Provincia_direccion_trabajo__c,
            Provincia_direccion_domicilio__c,
            Numero_direccion_trabajo__c,
            Canton_direccion_de_trabajo__c,
            Canton_direccion_domicilio__c,
            Nombre_canton_direccion_domicilio__c,
            Pais_direccion_domicilio__c,
            Pais_direccion_trabajo__c,
            Actividad_Economica__c,
            Numero_de_identificacion__c,
            Representante_Legal__c,
            Estado_civil__c
            FROM Account
            WHERE id = :DataOpp[0].AccountId
        ];
        
        String nameAccount = (DataAcc[0].Name != null ? DataAcc[0].Name+'' : ' ');  
        nameAcc = (DataAcc[0].Name != null ? DataAcc[0].Name+'' : ' ');  
        String cityAccount = (DataAcc[0].Ciudad__c != null ? DataAcc[0].Ciudad__c+'' : ' ');
        String phoneAccount = (DataAcc[0].Phone != null ? DataAcc[0].Phone+'' : ' ');
        String nacAccount = (DataAcc[0].Nacionalidad__c != null ? DataAcc[0].Nacionalidad__c+'' : ' ');
        String recordtypeAccount = (DataAcc[0].RecordTypeId != null ? DataAcc[0].RecordTypeId+'' : ' ');
        String streetAccount = (DataAcc[0].Calle_principal_direccion_domicilio__c != null ? DataAcc[0].Calle_principal_direccion_domicilio__c+'' : ' ');
        String streetWorkAccount = (DataAcc[0].Calle_principal_direccion_trabajo__c != null ? DataAcc[0].Calle_principal_direccion_trabajo__c+'' : ' ');
        String provAccount = (DataAcc[0].Provincia_direccion_domicilio__c != null ? DataAcc[0].Provincia_direccion_domicilio__c+'' : ' ');
        String provWorkAccount = (DataAcc[0].Provincia_direccion_trabajo__c != null ? DataAcc[0].Provincia_direccion_trabajo__c+'' : ' ');
        String numCantonAccount = ( DataAcc[0].Numero_direccion_trabajo__c != null? DataAcc[0].Numero_direccion_trabajo__c+'' : ' ');
        String cantonDirAccount = (DataAcc[0].Canton_direccion_domicilio__c !=null ? DataAcc[0].Canton_direccion_domicilio__c+'' : ' ');
        String cantonWorkAccount = (DataAcc[0].Canton_direccion_de_trabajo__c!=null ? DataAcc[0].Canton_direccion_de_trabajo__c+'' : ' ');
        String nameCantonAccount = (DataAcc[0].Nombre_canton_direccion_domicilio__c!=null ? DataAcc[0].Nombre_canton_direccion_domicilio__c+'' : ' ');
        String countryAccount = (DataAcc[0].Pais_direccion_domicilio__c != null ? DataAcc[0].Pais_direccion_domicilio__c+'' : ' ');
        String countryWorkAccount = (DataAcc[0].Pais_direccion_trabajo__c!= null ? DataAcc[0].Pais_direccion_trabajo__c+'' : ' ');
        String actEcoAccount = (DataAcc[0].Actividad_Economica__c != null ? DataAcc[0].Actividad_Economica__c+'' : ' ');
        String numidAccount = (DataAcc[0].Numero_de_identificacion__c!=null ? DataAcc[0].Numero_de_identificacion__c+'' : ' ');
        String replegalAccount = (DataAcc[0].Representante_Legal__c!=null ? DataAcc[0].Representante_Legal__c+'' : ' ');
        String estadoCivilAccount = (DataAcc[0].Estado_civil__c!=null ? DataAcc[0].Estado_civil__c+'' : ' ');
        
        Acc.add(nameAccount);
        Acc.add(cityAccount);
        Acc.add(phoneAccount);
        Acc.add(nacAccount);
        Acc.add(recordtypeAccount);
        Acc.add(streetAccount);
        Acc.add(streetWorkAccount);
        Acc.add(provAccount);
        Acc.add(provWorkAccount);
        Acc.add(numCantonAccount);
        Acc.add(cantonDirAccount);
        Acc.add(cantonWorkAccount);
        Acc.add(nameCantonAccount);
        Acc.add(countryAccount);
        Acc.add(countryWorkAccount);
        Acc.add(actEcoAccount);
        Acc.add(numidAccount);
        Acc.add(replegalAccount);
        Acc.add(estadoCivilAccount);
        
        DataActEco = [Select id,Name from 	ANEFI_Actividad_Economica__c where id = :DataAcc[0].Actividad_Economica__c];
        
        String nameActEco = (DataActEco.size()>0 && DataActEco[0].Name!=null ? DataActEco[0].Name+'' : ' ');
        
        ActEco.add(nameActEco);
        
        DataRecTyp = [
            SELECT id, Name
            FROM RecordType
            WHERE Id = :DataAcc[0].RecordTypeId
        ];
        String nameRecTyp = (DataRecTyp[0].Name!= null ? DataRecTyp[0].Name+'' : ' ');
        RecTyp.add(nameRecTyp);
        // System.debug('DataRecTyp: ' + DataRecTyp);
        
        DataNac = [
            SELECT Id, Name
            FROM ANEFI_Pais__c
            WHERE id = :DataAcc[0].Nacionalidad__c
        ];
        String nameNac = (DataNac.size()>0 &&  DataNac[0].Name!=null ? DataNac[0].Name+'' : ' ');
        Nac.add(nameNac);
        // System.debug('DataRecTyp: ' + DataRecTyp);
        
        
   
    }
}