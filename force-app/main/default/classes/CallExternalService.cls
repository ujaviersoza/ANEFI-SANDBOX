public with sharing class CallExternalService {
        
    public static void accountType(){
        HTTPRequest hr = new HTTPRequest();
        hr.setEndpoint('callout:Bank/accounts/DynamicsCorporation?accountType=Customer');
        hr.setMethod('POST');
        hr.setHeader('Accept', 'application/json');
        hr.setHeader('Content-Type', 'text/plain');
        hr.setTimeout(120000);
        
        HTTP h = new http();
        
        String responseBody = h.send(hr).getBody();
        system.debug('response : '+ responseBody);
        
        Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
        for(String key: m.keySet()){
            system.debug(key + '=>'+m.get(key));
        }
    }
    
    public static void getAccount(){
        //Call external services registered actions from apex
        //Instantiate the external service Apex class
        
        ExternalService.BankService service = new ExternalService.BankService();
        
        //set request
        ExternalService.BankService.getAccount_Request req = new ExternalService.BankService.getAccount_Request();
        
        req.accountName = 'GreenMotorCorporation';
        
        try{
            //make callout
            ExternalService.BankService.getAccount_Response res = service.getAccount(req);
            system.debug('200 response id => '+ res.Code200.Id);
            system.debug('200 repsonse: available balance => '+res.code200.availableBal);
        
        }catch(ExternalService.BankService.getAccount_ResponseException exc){
            system.debug('404 response: error message => '+ exc.code404.errorMessage);
        }
    }
    
    public static void addAccount() {
    	ExternalService.BankService service = new ExternalService.BankService();

        //set request
        ExternalService.BankService.addAccount_Request req = new ExternalService.BankService.addAccount_Request();
        
        req.accountName = 'GreenMotorCorporation';
        req.accountType = 'Customer';
        try{
            //make callout
            ExternalService.BankService.addAccount_Response res = service.addAccount(req);
            system.debug('200 response id => '+ res.Code201.id);
            system.debug('200 repsonse: name => '+res.Code201.name);
            system.debug('200 repsonse: available balance => '+res.Code201.availableBal);
            system.debug('200 repsonse: type => '+res.Code201.z0type);
        
        }catch(ExternalService.BankService.getAccount_ResponseException exc){
            system.debug('404 response: error message => '+ exc.code404.errorMessage);
        }    
    }
    
    public static void updateAccount() {
    	//update account
        ExternalService.BankService service = new ExternalService.BankService();
        
        //set request
        ExternalService.BankService.updateAccount_Request req = new ExternalService.BankService.updateAccount_Request();
        
        req.accountName ='GreenMotorCorporation';
        req.accountType = 'Customer';
        try{
            //make callout
            ExternalService.BankService.updateAccount_Response res = service.updateAccount(req);
            system.debug('200 response id => '+ res.Code200.id);
            system.debug('200 repsonse: name => '+res.Code200.name);
            system.debug('200 repsonse: available balance => '+res.Code200.availableBal);
            system.debug('200 repsonse: type => '+res.Code200.z0type);
        
        }catch(ExternalService.BankService.getAccount_ResponseException exc){
            system.debug('404 response: error message => '+ exc.code404.errorMessage);
        }    
    }
}