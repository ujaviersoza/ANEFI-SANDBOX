/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystem.net>
* @project          ANEFI - Nuevo desarrollos CRM
* @name             WebManagerAuthenticationTest
* @description      Test class to apex called WebManagerAuthentication
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-01-02   Intellect Systems             Initial version.
**************************************************************************************************************
*/

@isTest
public with sharing class WebManagerAuthenticationTest {

    /**
     * @method      testAccountCallout200
     * @description Method to cover response with code 200 of the web service
     * @author      Intellect Systems - 2024-01-02
     */
    @isTest
    static void testAccountCallout200() {   
        SingleRequestMock.Wrapper wrapper = new SingleRequestMock.Wrapper(); 
        wrapper.code = 200;
        wrapper.status = 'Complete';
        wrapper.body = '[{"data":{"usuario":"GESTOR","clave":"GESTORGE"}}]';
        wrapper.responseHeaders = null;

        SingleRequestMock fakeResponse = new SingleRequestMock(wrapper);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        Test.startTest();
        String token = WebManagerAuthentication.getToken(); system.debug('El token fué: '+token);
        Test.stopTest();

        System.assertEquals('200, Complete', token, 'Error in the web service, the token should be return 200, Complete');
    }
}