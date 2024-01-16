trigger ActualizarEstadoCriterioAceptacion on IQA_Escenario__c (after Insert, after Update, after Delete, after unDelete) {

    integer cantNoIniciado, cantEnProgreso, cantPbaFinalizada;
    string escenarioID, criterioID, estadoDelCriterio;

    /* Determinar el ID del Escenario que disparó el trigger */
    if ( Trigger.isUpdate || Trigger.isUndelete || Trigger.isInsert ) 
        for ( IQA_Escenario__c regEscenario: Trigger.new ) {
            criterioID = regEscenario.Id_Criterio__c;
            escenarioID = regEscenario.Id;
        }
    else if ( Trigger.isDelete )
            for ( IQA_Escenario__c regEscenario: Trigger.old) {
                criterioID = regEscenario.Id_Criterio__c;
                escenarioID = regEscenario.Id;
            }

    /* Contar el total de escenarios "No Iniciado" */
    cantNoIniciado = [ SELECT count() FROM IQA_Escenario__c WHERE Id_Criterio__c= :criterioID AND Estado_del_Escenario__c = 'No Iniciado' ];

    /* Contar el total de escenarios "En Progreso" */
    cantEnProgreso = [ SELECT count() FROM IQA_Escenario__c WHERE Id_Criterio__c= :criterioID AND Estado_del_Escenario__c = 'En Progreso' ];

    /* Contar el total de escenarios "Prueba Finalizada" */
    cantPbaFinalizada = [ SELECT count() FROM IQA_Escenario__c WHERE Id_Criterio__c= :criterioID  AND Estado_del_Escenario__c = 'Prueba Finalizada' ];

    /* Determinar el Estado del Criterio de Aceptación */
    if ( cantNoIniciado == 0 && cantEnProgreso == 0 && cantPbaFinalizada >= 1 )
        estadoDelCriterio = 'Prueba Finalizada';
        else if ( cantEnProgreso >= 1  || ( cantNoIniciado >=1 && cantEnProgreso == 0 && cantPbaFinalizada >= 1 ) )
                 estadoDelCriterio = 'En Progreso';
                 else if ( cantEnProgreso == 0 && cantPbaFinalizada == 0)
                          estadoDelCriterio = 'No Iniciado';

    /* Actualizar el nuevo estado del Criterio de Aceptación  */
    List<IQA_Criterio__c > listCriterios= new List<IQA_Criterio__c >([ SELECT Id, Estado_del_Criterio_de_Aceptacion__c FROM IQA_Criterio__c WHERE Id = :criterioID]);

    for( IQA_Criterio__c regCriterio: listCriterios ) {
        regCriterio.Estado_del_Criterio_de_Aceptacion__c = estadoDelCriterio;
    } /* for */

    try{
        update listCriterios;
    } /* try */

    Catch(Exception E){
        System.Debug('Ocurrió un error: ' + e.getMessage());
    } /* Catch */
   
} /* trigger */