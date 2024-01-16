public with sharing class WebManagerAuthentication {
	public static String getToken() {       
        
        Autentication__mdt autenticationValues = [  SELECT 
                                                    Id, DeveloperName, Endpoint__c, Method__c, Body__c
                                                    FROM Autentication__mdt 
                                                    WHERE DeveloperName = 'WebManagerAuthentication' 
                                                    WITH SECURITY_ENFORCED
                                                    LIMIT 1];
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(autenticationValues.Endpoint__c);
        request.setMethod(autenticationValues.Method__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(autenticationValues.Body__c);
        
        String token = '';
        
        try {
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 201) {      
                WebManagerAuthenticationRequest myJSONInstance = (WebManagerAuthenticationRequest)JSON.deserialize(response.getBody(), WebManagerAuthenticationRequest.class);
                token = myJSONInstance.data.accessToken;
            } else {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ', ' + response.getStatus());
                token = response.getStatusCode() + ', ' + response.getStatus();
            }
        } catch(System.CalloutException ex) {
            System.debug('Error en la API en autenticación: '+ex.getLineNumber() + '---' + ex.getMessage());
        }    

        return token;
    }
}