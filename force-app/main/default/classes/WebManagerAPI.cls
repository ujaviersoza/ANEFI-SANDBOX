public with sharing class WebManagerAPI {
    @AuraEnabled(cacheable=true)
    public static Response consultContributions(InnerWrapper innerWrapper) {
        String token = WebManagerAuthentication.getToken();  
        Response res = new Response();

        //String token = '503, Service Unavailable';
        
        try{
            if(token == '503, Service Unavailable') {
                res.isOK = false;
                res.msgError = token;
                res.status = 503;
                res.data = null;
                res.totalPages = 0;
                res.totalElements = 0;
                res.montoTotal = 0; 
            } else {    
                WebManagerAPI__mdt valuesConsult = [    SELECT 
                                                        Id, DeveloperName, Endpoint__c, Method__c, PageSize__c, GestorTokenApp__c, GestorTokenEnv__c	
                                                        FROM WebManagerAPI__mdt 
                                                        WHERE DeveloperName = 'ConsultContributions' WITH SECURITY_ENFORCED 
                                                        LIMIT 1     ];
                
                String endPoint = valuesConsult.Endpoint__c;
                endPoint = endPoint.replace('PageNumberVal',innerWrapper.pageNumber);
                if(!String.IsEmpty(innerWrapper.pageSize)) {
                    endPoint = endPoint.replace('PageSizeVal',innerWrapper.pageSize);        
                } else {
                    endPoint = endPoint.replace('PageSizeVal',valuesConsult.PageSize__c);
                }    
                endPoint = endPoint.replace('FechaDesdeVal',innerWrapper.fechaDesde);
                endPoint = endPoint.replace('FechaHastaVal',innerWrapper.fechaHasta);
                endPoint = endPoint.replace('ProductoVal',innerWrapper.producto);
                endPoint = endPoint.replace('ParticipesVal',innerWrapper.codigoCliente);
                endPoint = endPoint.replace('EstadoVal',innerWrapper.estado);
                
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endPoint);
                request.setMethod(valuesConsult.Method__c);
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setHeader('Gestor-Token-App', valuesConsult.GestorTokenApp__c);
                request.setHeader('Gestor-Token-Env', valuesConsult.GestorTokenEnv__c);
                request.setHeader('Authorization', 'Bearer ' + token);
                
                Http http = new Http();
                HttpResponse response = http.send(request);
                
                List<Data> data = new List<Data>();
                
                if(response.getStatusCode() == 200) {   
                    ConsultContributionsRequest myJSONInstance = (ConsultContributionsRequest)JSON.deserialize(response.getBody(), ConsultContributionsRequest.class);
                    Data dtNew;
                    Double loopTotal = 0;
                        
                    for(ConsultContributionsRequest.Data dt : myJSONInstance.data) {
                        dtNew = new Data();
        
                        dtNew.codigoProducto = dt.codigoProducto;
                        dtNew.codigoCliente = dt.codigoCliente;
                        dtNew.numeroCuenta = dt.numeroCuenta;
                        dtNew.banco = dt.cuentaBancariaCliente.codigoEntidad;
                        dtNew.cuentaBancaria = dt.cuentaBancariaCliente.numeroCuenta;
                        dtNew.tipoCuenta = dt.cuentaBancariaCliente.tipoCuenta;
                        dtNew.numeroAporteProgramado = dt.numeroAporteProgramado;
                        dtNew.secuenciaAporte = dt.secuenciaAporte;
                        dtNew.fecha = dt.fecha;
                        dtNew.monto = dt.monto;
                        dtNew.estado = dt.estado;               
                        dtNew.canal = dt.canal;
        
                        if(String.IsEmpty(innerWrapper.pageSize)) {
                            if(!String.IsEmpty(String.valueof(dtNew.codigoCliente)) && String.valueof(dtNew.codigoCliente) != '-') { 
                                Account account = searchAccount(String.valueof(dtNew.codigoCliente));
                                dtNew.identificacion = account.Numero_de_identificacion__c;
                                dtNew.nombre = account.Name;
                            } else {
                                dtNew.identificacion = '';
                                dtNew.nombre = '';    
                            }
                        }    
                        
                        loopTotal = loopTotal + dtNew.monto;
                        
                        data.add(dtNew);
                    }
        
                    res.isOK = true;
                    res.msgError = '';
                    res.status = response.getStatusCode();
                    res.data = data;
                    res.totalPages = myJSONInstance.meta.totalPages;
                    res.totalElements = myJSONInstance.meta.totalElements;
                    res.montoTotal = loopTotal;
                }
            }    
        } catch(Exception ex) {
            System.debug('Error: '+ex.getLineNumber()+'--'+ex.getMessage());
        }   
        System.debug('Respuesta: '+res);
        return res;
    }
    
    @AuraEnabled(cacheable=true)
    public static Account searchAccount(String codigoCliente) {
        Account accounts = new Account();
        try {                                                       
        accounts = [    SELECT Id,Name,Numero_de_identificacion__c 
                        FROM Account 
                        WHERE Codigo_persona_en_Gestor__c =: codigoCliente WITH SECURITY_ENFORCED      ];
        } catch(Exception ex) {
            System.debug('Error: '+ex.getLineNumber()+'--'+ex.getMessage());
        }   
        return accounts;
    }

    /**
     * @method      processRecords
     * @description methodDescription
     * @author      Josué Blandón - 2023-12-25
     * @param       paramName
     * @return      String
     */
    @AuraEnabled(cacheable=true)
    public static ResponseProcess processRecords(List<WrapperProcess> wrapperProcess) {
        String token = WebManagerAuthentication.getToken(); 

        ResponseProcess res = new ResponseProcess();
        //String token = '503, Service Unavailable';

        if(token == '503, Service Unavailable') {
            res.isOK = false;
            res.msgError = token;
            res.status = 503;
        } else { 
            Integer i = 0;
            Integer delayInMinutes = 1;
            for (i = 0; i < wrapperProcess.size(); i++) {
                Id jobID = System.enqueueJob(new ProcessRecordsBatch(token, wrapperProcess[i]), delayInMinutes);
            }
        }
    
        return res;
    }

    public class Data {
        @AuraEnabled public String codigoProducto {get;set;} 
		@AuraEnabled public Integer codigoCliente {get;set;} 
        @AuraEnabled public String numeroCuenta {get;set;}
        @AuraEnabled public String banco {get;set;}
        @AuraEnabled public String cuentaBancaria {get;set;}
        @AuraEnabled public String tipoCuenta {get;set;}
        @AuraEnabled public Integer numeroAporteProgramado {get;set;}
        @AuraEnabled public Integer secuenciaAporte {get;set;}
        @AuraEnabled public String fecha {get;set;}
        @AuraEnabled public Double monto {get;set;}
		@AuraEnabled public String estado {get;set;} 
        @AuraEnabled public String canal {get;set;}
        @AuraEnabled public Integer totalPages {get;set;}
        @AuraEnabled public String identificacion {get;set;}
        @AuraEnabled public String nombre {get;set;}
    } 

    public class InnerWrapper {
        @AuraEnabled public String pageNumber {get;set;}
        @AuraEnabled public String fechaDesde {get;set;}
        @AuraEnabled public String fechaHasta {get;set;}
        @AuraEnabled public String producto {get;set;}
        @AuraEnabled public String codigoCliente {get;set;}
        @AuraEnabled public String estado {get;set;}
        @AuraEnabled public String pageSize {get;set;}
    }
    
    public class Response {
        @AuraEnabled public Boolean isOK {get;set;} 
        @AuraEnabled public String msgError {get;set;} 
        @AuraEnabled public Integer status {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public List<Data> data {get;set;} 
        @AuraEnabled public Integer totalPages {get;set;} 
        @AuraEnabled public Integer totalElements {get;set;}
        @AuraEnabled public Double montoTotal {get;set;}
    }

    @AuraEnabled public List<WrapperProcess> wrapperProcess {get;set;} 

    public class WrapperProcess {
        @AuraEnabled public String codigoProducto {get;set;}
        @AuraEnabled public String codigoCliente {get;set;}
        @AuraEnabled public String numeroCuenta {get;set;}

        @AuraEnabled public String banco {get;set;}
        @AuraEnabled public String cuentaBancaria {get;set;}
        @AuraEnabled public String tipoCuenta {get;set;}

        @AuraEnabled public Integer numeroAporteProgramado {get;set;}
        @AuraEnabled public Integer secuenciaAporte {get;set;}

        @AuraEnabled public String fecha {get;set;}
        @AuraEnabled public Double monto {get;set;}
		@AuraEnabled public String estado {get;set;} 
        @AuraEnabled public String canal {get;set;}
        @AuraEnabled public Integer totalPages {get;set;}
        @AuraEnabled public String identificacion {get;set;}
        @AuraEnabled public String nombre {get;set;}

        @AuraEnabled public String resultado {get;set;} //Have value only when the record in processed
    }

    public class ResponseProcess {
        @AuraEnabled public Boolean isOK {get;set;} 
        @AuraEnabled public String msgError {get;set;} 
        @AuraEnabled public Integer status {get;set;}
    }
}