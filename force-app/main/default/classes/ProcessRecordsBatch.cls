/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystem.net>
* @project          ANEFI - Nuevo desarrollos CRM
* @name             ProcessRecordsBatch
* @description      Batch Class to process the scheduled contribution transaction.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-12-27   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public with sharing class ProcessRecordsBatch implements Queueable, Database.AllowsCallouts {
    
    public String token;
    public WebManagerAPI.WrapperProcess wrapperProcess;

    public ProcessRecordsBatch(String tokenValue, WebManagerAPI.WrapperProcess wrapperProcessVal) {
        token = tokenValue;
        wrapperProcess = wrapperProcessVal;
    }

    public void execute(QueueableContext qc) {
        // Create a transaction finalizer
        SendNotificationFinalizer notify = new SendNotificationFinalizer();

        WebManagerAPI__mdt valuesConsult = [    SELECT 
                                                Id, DeveloperName, Endpoint__c, Method__c, Body__c, GestorTokenApp__c, GestorTokenEnv__c	
                                                FROM WebManagerAPI__mdt 
                                                WHERE DeveloperName = 'ProcessContributions' WITH SECURITY_ENFORCED 
                                                LIMIT 1     ];

        try {
            String endPoint = valuesConsult.Endpoint__c;  
            endPoint = endPoint.replace('ProductosVal', wrapperProcess.codigoProducto);
            endPoint = endPoint.replace('ParticipesVal', wrapperProcess.codigoCliente);
            endPoint = endPoint.replace('NumeroCuentaVal', wrapperProcess.numeroCuenta);
            endPoint = endPoint.replace('NumeroAporteProgramadoVal', String.valueof(wrapperProcess.numeroAporteProgramado));
            endPoint = endPoint.replace('SecuenciaAporteVal', String.valueof(wrapperProcess.secuenciaAporte)); 
            System.debug('Endpoints: '+endPoint);  
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod(valuesConsult.Method__c);
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Gestor-Token-App', valuesConsult.GestorTokenApp__c);
            request.setHeader('Gestor-Token-Env', valuesConsult.GestorTokenEnv__c);
            request.setHeader('Authorization', 'Bearer ' + token);
            request.setBody(valuesConsult.Body__c); 

            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('response: '+response);
            //ProcessContributionsRequest myJSONInstance = (ProcessContributionsRequest)JSON.deserializeUntyped(response.getBody());

            //Map<String, ProcessContributionsRequest> myJSONInstance = (Map<String, ProcessContributionsRequest>)JSON.deserializeUntyped(response.getBody());

            System.debug('Status: '+response.getStatusCode());          
            if(response.getStatusCode() != 200) {
                System.debug('Error en el registros: '+endPoint);
                //wrapperProcess[i].resultado = String.valueOf(myJSONInstance);
            } else {                   
                System.debug('response.getBody(): '+response.getBody());
                //wrapperProcess[i].resultado = String.valueOf(JSON.serialize(myJSONInstance));
            }         
        //}

        //notify.reportProgress(wrapperProcess);

        } catch (System.CalloutException ex) {
            System.debug('Error en la API: '+ex.getLineNumber() + '---' + ex.getMessage());        
        }
    }
}