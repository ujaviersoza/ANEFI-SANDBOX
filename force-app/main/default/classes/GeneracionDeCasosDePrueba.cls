global class GeneracionDeCasosDePrueba{
   
   @InvocableMethod
   public static void GenerarCasosDePrueba(List<List<string>> lstParams) {

        /* DECLARACIÓN DE VARIABLES */
        string idCasoDePrueba, idCiclo;
        List<string> listSprintsIN = new List<string>{};
        List<string> listEstsOKCasos = new List<string>{};
        List<string> listEstsOKCriterios = new List<string>{};
        List<IQA_Caso_de_Prueba__c> listCasos = new List<IQA_Caso_de_Prueba__c>();
        List<agf__ADM_Acceptance_Criterion__c> listAGFCriterios = new List<agf__ADM_Acceptance_Criterion__c>();
        List<IQA_Criterio__c> listIQACriterios = new List<IQA_Criterio__c>();
        List<IQA_Escenario__c> listEscenarios = new List<IQA_Escenario__c>();
        List<IQA_Ejecucion__c> listEjecuciones = new List<IQA_Ejecucion__c>();
        /* FIN DECLARACIÓN DE VARIABLES */

        /* El idCiclo viene como primer elemento de lstParams, extraerlo */
        idCiclo = lstParams[0].remove(0);

        /* Leer los estados válidos configurados para las HU (Work) y para los Criterios de Aceptación y convertirlos a listas */
        List<IQA_Ciclo_de_Pruebas__c> listInfoCiclo = new List<IQA_Ciclo_de_Pruebas__c>( [  SELECT Estados_Casos_de_Prueba__c, Estados_Criterios__c  
                                                                                            FROM   IQA_Ciclo_de_Pruebas__c  
                                                                                            WHERE  Id = :idCiclo  ] );
        listEstsOKCasos = listInfoCiclo[0].Estados_Casos_de_Prueba__c.split(';');
        listEstsOKCriterios = listInfoCiclo[0].Estados_Criterios__c.split(';');

        /* Preparar la lista de sprints para el IN del SELECT*/
        for(integer i = 0; i < lstParams[0].size(); i++) {
            listSprintsIN.add( lstParams[0][i] );
        } /* for */

        /* Leer la lista de Historias de Usuario de todos los Sprints que tengan un estado válido */
        List<agf__ADM_Work__c> listWork = new List<agf__ADM_Work__c>( [ SELECT Id, Name  
                                                                        FROM   agf__ADM_Work__c  
                                                                        WHERE  agf__Record_Type__c = 'User Story' 
                                                                        AND    agf__Status__c IN :listEstsOKCasos  
                                                                        AND    agf__Sprint__c IN :listSprintsIN  ] ); 

        /* Para cada HU... */
        for( agf__ADM_Work__c regWork: listWork ) {
            /* Definir los datos del nuevo Caso de Prueba y agregar el nuevo Caso de Prueba a la lista de Casos de Prueba*/
            IQA_Caso_de_Prueba__c regCaso = new IQA_Caso_de_Prueba__c(  Descripcion_del_Caso_de_Prueba__c = 'Caso de prueba para: ' + regWork.Name,
                                                                        Id_Ciclo_de_Pruebas__c = idCiclo,
                                                                        Estado_del_Caso_de_Prueba__c = 'Nuevo',
                                                                        Tipo_de_Prueba__c = 'Por Definir',
                                                                        WORK_ID__c = regWork.Id );
            listCasos.add(regCaso);
        } /* for */

        /* Insertar los Casos de Prueba */
        try{
          insert listCasos;
        } /* try */

        Catch(Exception E){
            System.Debug('Ocurrió un error: ' + e.getMessage());
        } /* Catch */        


        /* Leer los criterios en estado Nuevo/New o Approved/Aprobado de todas las HUs de los sprints */
        listAGFCriterios = [  SELECT Id, agf__Work__c
                              FROM   agf__ADM_Acceptance_Criterion__c
                              WHERE  agf__Work__c IN :listWork
                              AND    agf__Status__c IN :listEstsOKCriterios ] ;

        /* Leer de nuevo la lista de Casos de Prueba recién insertados para obtener su Id  */
        listCasos = [   SELECT Id, WORK_ID__c
                        FROM   IQA_Caso_de_Prueba__c
                        WHERE  Id_Ciclo_de_Pruebas__c = :idCiclo
                        ORDER  BY WORK_ID__c ];

        /* Para cada AGF-Criterio de Aceptación... */
        boolean found;
        for ( agf__ADM_Acceptance_Criterion__c regAGFCriterio: listAGFCriterios ) {
            found = false;
            /* Buscar el Id del Caso de Prueba en listCasos (recién leída) */
            for (integer j = 0; j < listCasos.size() && !found; j++ ) {
                if (regAGFCriterio.agf__Work__c == listCasos[j].WORK_ID__c) {
                    found = true;
                    /* Definir los datos del nuevo IQA-Criterio de Aceptación y agregar el nuevo IQA-Criterio de Aceptación a la lista de IQA-Criterios de Aceptación */
                    IQA_Criterio__c regIQACriterio = new IQA_Criterio__c(   Criterio__c = regAGFCriterio.Id,
                                                                            Id_Caso_de_Prueba__c = listCasos[j].Id);
                    listIQACriterios.add( regIQACriterio );
                } /* if */
            } /* while */
        } /* for */

        /* Insertar los Criterios de Aceptación */
        try{
          insert listIQACriterios;
        } /* try */
        Catch(Exception E){
            System.Debug('Ocurrió un error: ' + e.getMessage());
        } /* Catch */        

        /* Leer de nuevo la lista de Criterios de Aceptación recién insertados para obtener su Id  */
        listIQACriterios = [    SELECT Id 
                                FROM   IQA_Criterio__c
                                WHERE  Id_Caso_de_Prueba__c IN :listCasos 
                                ORDER  BY Id ];

        /* Para Cada IQA Criterio... */
        for( IQA_Criterio__c regCriterio: listIQACriterios ) {
            /* Definir los datos del (único) Escenario inicial y agregar el nuevo Escenario a la lista de Escenarios  */
            IQA_Escenario__c regEscenario = new IQA_Escenario__c( Id_Criterio__c = regCriterio.Id );
            listEscenarios.add( regEscenario );
        } /* for */

        /* Insertar los Escenarios */
        try{
          insert listEscenarios;
        } /* try */
        Catch(Exception E){
            System.Debug('Ocurrió un error: ' + e.getMessage());
        } /* Catch */        


        /* Leer de nuevo la lista de Escenarios recién insertados para obtener su Id  */
        listEscenarios = [  SELECT  Id 
                            FROM    IQA_Escenario__c
                            WHERE   Id_Criterio__c IN :listIQACriterios 
                            ORDER   BY Id ];

        /* Para Cada Escenario ... */
        for( IQA_Escenario__c regEsc: listEscenarios ) {
            /* Definir los datos de la (única) Ejecución inicial y agregar el nuevo Escenario a la lista de Escenarios */
            IQA_Ejecucion__c regEjecucion = new IQA_Ejecucion__c( Id_Escenario__c = regEsc.Id );
            listEjecuciones.add( regEjecucion );
        } /* for */

        /* Insertar las Ejecuciones */
        try{
          insert listEjecuciones;
        } /* try */
        Catch(Exception E){
            System.Debug('Ocurrió un error: ' + e.getMessage());
        } /* Catch */        

    } /* GenerarCasosDePrueba */

} /* class */