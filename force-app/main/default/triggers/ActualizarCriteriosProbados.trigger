trigger ActualizarCriteriosProbados on IQA_Criterio__c (after Insert, after Update, after Delete, after unDelete) {

    /* Actualiza el campo de Criterios Probados y el de Estado del Caso de Prueba */
    /* en el Caso de Prueba con base en la cantidad de criterios por estado     */
    
    integer cantTotalCriterios, cantCriteriosEnProgreso, cantCriteriosPbaFinalizada;
    string criterioID, casoID, tmp;

    /* Determinar el ID del Criterio que disparó el trigger */
    if ( Trigger.isUpdate || Trigger.isUndelete || Trigger.isInsert ) 
        for ( IQA_Criterio__c regCriterio: Trigger.new ) {
            criterioID = regCriterio.Id;
            casoID = regCriterio.Id_Caso_de_Prueba__c;
        }
    else if ( Trigger.isDelete )
            for ( IQA_Criterio__c regCriterio: Trigger.old) {
                criterioID = regCriterio.Id;
                casoID = regCriterio.Id_Caso_de_Prueba__c;
            }

    /* Contar la cantidad total de Criterios, la cantidad de los que están en En Progreso y la cantidad que están en Prueba Finalizada */
    cantTotalCriterios = [ SELECT Count() FROM IQA_Criterio__c WHERE Id_Caso_de_Prueba__c = :casoID ];
    cantCriteriosPbaFinalizada = [ SELECT Count() FROM IQA_Criterio__c WHERE Id_Caso_de_Prueba__c = :casoID AND Estado_del_Criterio_de_Aceptacion__c = 'Prueba Finalizada' ];
    cantCriteriosEnProgreso = [ SELECT Count() FROM IQA_Criterio__c WHERE Id_Caso_de_Prueba__c = :casoID AND Estado_del_Criterio_de_Aceptacion__c = 'En Progreso' ];
   
    /* Actualizar los campos Criterios_Probados__c y Estado_del_Caso_de_Prueba__c del Caso de Prueba */
    List<IQA_Caso_de_Prueba__c > listCasos= new List<IQA_Caso_de_Prueba__c >([ SELECT Id, Criterios_Probados__c, Estado_del_Caso_de_Prueba__c FROM IQA_Caso_de_Prueba__c WHERE Id = :casoID]);

    for( IQA_Caso_de_Prueba__c regCasos: listCasos ) {
        regCasos.Criterios_Probados__c = ( (cantTotalCriterios - cantCriteriosPbaFinalizada) == 0 ) ;
        tmp = regCasos.Estado_del_Caso_de_Prueba__c;
        /* Determinar si se debe actualizar el Estado del Caso de Prueba */
        if (( (cantCriteriosEnProgreso >= 1) || (cantCriteriosPbaFinalizada >= 1) == true ) && 
            ( regCasos.Estado_del_Caso_de_Prueba__c == 'Aprobado para Ejecutar')  ) 
            {
            regCasos.Estado_del_Caso_de_Prueba__c = 'En Progreso';
            }
    } /* for */

    try{
        update listCasos;
    } /* try */

    catch(Exception E){
       System.Debug('Ocurrió un error: ' + e.getMessage());
    } /* Catch */    

} /* trigger */