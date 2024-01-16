@isTest
public class ANEFI_MultiRequestMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;
 
    public ANEFI_MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }
 
    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if (mock != null) {
            return mock.respond(req);
        } else {
            system.debug('HTTP callout not soportado para métodos de prueba:');
            return null;
        }
    }
 
    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}