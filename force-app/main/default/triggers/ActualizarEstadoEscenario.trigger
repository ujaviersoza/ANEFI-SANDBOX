trigger ActualizarEstadoEscenario on IQA_Ejecucion__c (after Insert, after Update, after Delete, after unDelete) {

    string ejecucionID, ultEjecucionID, escenarioID, estadoUltEjecucion, estadoEscenario ;
    integer ultElemento;

    /* Determinar el ID de la Ejecución y el ID del Escenario que disparó el trigger */
    if ( Trigger.isUpdate || Trigger.isUndelete || Trigger.isInsert ) 
        for ( IQA_Ejecucion__c regEjecucion: Trigger.new ) {
            ejecucionID = regEjecucion.Id;
            escenarioID = regEjecucion.Id_Escenario__c;
        }
    else if ( Trigger.isDelete )
            for ( IQA_Ejecucion__c regEjecucion: Trigger.old) {
                ejecucionID = regEjecucion.Id;
                escenarioID = regEjecucion.Id_Escenario__c;
            }

    /* Determinar cuál es la última Ejecución y el estado de esa Ejecución */
    List<IQA_Ejecucion__c > listEjecuciones = new List<IQA_Ejecucion__c >([ SELECT Id, Name, Estado_de_la_Ejecucion_Texto__c FROM IQA_Ejecucion__c WHERE Id_Escenario__c = :escenarioID ORDER BY Name ]);
    ultElemento = listEjecuciones.size()-1;
    if ( ultElemento >= 0 ) { // si hay al menos 1 Ejecucion
       ultEjecucionID = listEjecuciones[ultElemento].Id;
       estadoUltEjecucion = listEjecuciones[ultElemento].Estado_de_la_Ejecucion_Texto__c;
    } 

    /* Determinar el nuevo estado del Escenario */
    switch on ultElemento {
        when -1 {       // no hay Ejecuciones
            estadoEscenario = 'No Iniciado' ;
        }   
        when 0 {        // solo hay 1 Ejecución
                switch on estadoUltEjecucion {
                    when 'No Iniciada' {
                        estadoEscenario = 'No Iniciado' ;
                    }
                    when 'Pasó' {
                        estadoEscenario = 'Prueba Finalizada' ;
                    }
                    when else { // si el estado es 'En Progreso' o 'Falló'
                        estadoEscenario = 'En Progreso' ;
                    }
                }            
        }
        when else {       // hay más de 1 Ejecución
                    if ( estadoUltEjecucion == 'Pasó' )
                        estadoEscenario = 'Prueba Finalizada' ;
                        else estadoEscenario = 'En Progreso' ;
        }
    }
    
    /* Actualizar el nuevo estado del Escenario */
    List<IQA_Escenario__c> listEscenarios = new List<IQA_Escenario__c>([ SELECT Id, Estado_del_Escenario__c FROM IQA_Escenario__c WHERE Id = :escenarioID ]);

    for( IQA_Escenario__c regEscenario: listEscenarios ) {
        regEscenario.Estado_del_Escenario__c = estadoEscenario;
    } /* for */

    try{
        update listEscenarios;
    } /* try */

    Catch(Exception E){
        System.Debug('Ocurrió un error: ' + e.getMessage());
    } /* Catch */

} /* trigger */