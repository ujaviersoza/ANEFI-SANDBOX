public with sharing class ANEFICondicionesFirmasPNaturalController {

    public List<String> dataDate { get; set; }
    public List<Opportunity> dataOpp { get; set; }
    public List<Account> dataAcc { get; set; }    

    public List<String> Opp { get; set; }
    public List<String> Acc { get; set; }

    public Opportunity Opportunity { get; set; }
    public Id RecordId { get; set; }
    private ApexPages.StandardController controller { get; set; }
    
    public ANEFICondicionesFirmasPNaturalController(ApexPages.StandardController controller) {

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

        dataAcc = [ SELECT Id, Name, Numero_de_identificacion__c FROM Account WHERE id = :dataOpp[0].AccountId ];

        String nameAccount = (dataAcc[0].Name != null ? dataAcc[0].Name+'' : ' ');
        String numidAccount = (dataAcc[0].Numero_de_identificacion__c!=null ? dataAcc[0].Numero_de_identificacion__c+'' : ' ');
        
        Acc.add(nameAccount);
        Acc.add(numidAccount);


        System.debug('\n\n\n\n\n\n\n\n==========================================');
        System.debug('dataDate: '+dataDate);
        System.debug('dataOpp: '+Opp);
        System.debug('dataAcc: '+Acc);


    }
}