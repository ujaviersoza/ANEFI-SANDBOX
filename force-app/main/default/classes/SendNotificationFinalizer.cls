/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystem.net>
* @project          ANEFI - Nuevo desarrollos CRM
* @name             SendNotificationFinalizer
* @description      ClassDescription
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-12-28   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public with sharing class SendNotificationFinalizer {

    public List<WebManagerAPI.WrapperProcess> wrapperProcess;

    /**
     * @method      execute
     * @description methodDescription
     * @author      Intellect Systems - 2023-12-28
     * @param       context
     * @return      String
     */
    public void reportProgress(List<WebManagerAPI.WrapperProcess> wrapperProcessVal) {
        wrapperProcess = wrapperProcessVal;
        System.debug('wrapperProcess values updates: '+wrapperProcess);
    }
}