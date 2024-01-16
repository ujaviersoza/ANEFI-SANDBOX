//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WebManagerAuthenticationRequestTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": {'+
		'        \"tokenType\": \"bearer\",'+
		'        \"accessToken\": \"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhbmVmaSIsImF1ZCI6IlJPTEVfR1dPUEUiLCJzdXUiOiJHRVNUT1IiLCJ1c3IiOiJHVyIsImlzcyI6ImNISjFaV0poIiwiZXhwIjoxNzA0MjE5NDU2fQ.G_k78v2KfImMbXbFgxJIxEsT90pv_buXCVRnD_qhMbo\",'+
		'        \"expiresIn\": 1800,'+
		'        \"refreshToken\": \"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhbmVmaSIsImF1ZCI6IlJPTEVfR1dPUEUiLCJzdXUiOiJHRVNUT1IiLCJ1c3IiOiJHVyIsImlzcyI6ImNISjFaV0poIiwiZXhwIjoxNzA0MjIxMjU2fQ.zQDI3JwUHCGVxFEWUQOq5qE5wp2ukYU-NyROxjm90fs\",'+
		'        \"estadoClave\": \"VALIDA\"'+
		'    }'+
		'}';
		WebManagerAuthenticationRequest obj = WebManagerAuthenticationRequest.parse(json);
		System.assert(obj != null);
	}
}