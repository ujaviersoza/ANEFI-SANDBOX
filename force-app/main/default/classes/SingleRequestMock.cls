/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystem.net>
* @project          ANEFI - Nuevo desarrollos CRM
* @name             SingleRequestMock
* @description      Test class to web services
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-01-02   Intellect Systems             Initial version.
**************************************************************************************************************
*/

@isTest
public class SingleRequestMock implements HttpCalloutMock {
	public Integer code;
	public String status;
	public String bodyAsString;
	public Blob bodyAsBlob;
	public Map<String, String> responseHeaders;

	/**
	 * @method      SingleRequestMock
	 * @description Constructor method
	 * @author      Josué Blandón - 2024-01-02
	 * @param       wrapper
	 */
	public SingleRequestMock(Wrapper wrapper) {
		this.code = wrapper.code;
		this.status = wrapper.status;
		this.bodyAsString = wrapper.body;
		this.bodyAsBlob = null;
		this.responseHeaders = wrapper.responseHeaders;
	}

	/**
	 * @method      respond
	 * @description Constructor method
	 * @author      Intellect Systems - 2024-01-02
	 * @param       wrapper
	 * @return      HTTPResponse
	 */
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse resp = new HttpResponse();
		resp.setStatusCode(code);
		resp.setStatus(status);

		if(bodyAsBlob != null) {
			resp.setBodyAsBlob(bodyAsBlob);
		} else {
			resp.setBody(bodyAsString);
		}

		if(responseHeaders != null) {
			for (String key : responseHeaders.keySet()) {
				resp.setHeader(key, responseHeaders.get(key));
			}
		}

		return resp;
	}

	/**
	 * @method      Wrapper
	 * @description Parameters definition
	 * @author      Intellect Systems - 2024-01-02
	 */
	public class Wrapper {
        public Integer code;
		public String status;
		public String body;
        public Map<String, String> responseHeaders;
    }
}