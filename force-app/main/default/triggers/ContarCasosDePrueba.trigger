trigger ContarCasosDePrueba on IQA_Caso_de_Prueba__c (after insert, after delete, after update, after undelete) {

  integer cantCasos, cantCasosNoSuman, cantCasosPbasFinalizadas;
  string cicloID, estadoCaso;

  /* Determinar el ID del Ciclo de Pruebas */
  if( Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete ) {
    for( IQA_Caso_de_Prueba__c regCaso: Trigger.new ) {
      cicloID = regCaso.Id_Ciclo_de_Pruebas__c;
      estadoCaso = regCaso.Estado_del_Caso_de_Prueba__c;
    } /* for */
  } /* if */
  if( Trigger.isDelete ) {
    for( IQA_Caso_de_Prueba__c regCaso: Trigger.old ) {
      cicloID = regCaso.Id_Ciclo_de_Pruebas__c;
      estadoCaso = regCaso.Estado_del_Caso_de_Prueba__c;
    } /* for */
  } /* if */

  /* Contar la cantidad de casos totales, 
     casos que no suman (estados Bloqueado, Pospuesto y Cancelado) y 
     casos en estado "Pruebas Finalizadas" para el cicloID */
  cantCasos = [ SELECT count() FROM IQA_Caso_de_Prueba__c WHERE Id_Ciclo_de_Pruebas__c = :cicloID ];
  cantCasosNoSuman = [ SELECT count() 
                       FROM  IQA_Caso_de_Prueba__c 
                       WHERE Id_Ciclo_de_Pruebas__c = :cicloID 
                       AND ( Estado_del_Caso_de_Prueba__c = 'Bloqueado' OR
                              Estado_del_Caso_de_Prueba__c = 'Pospuesto' OR
                              Estado_del_Caso_de_Prueba__c = 'Cancelado' 
                            )
                      ];
  cantCasosPbasFinalizadas = [ SELECT count() 
                               FROM   IQA_Caso_de_Prueba__c 
                               WHERE  Id_Ciclo_de_Pruebas__c = :cicloID
                               AND    Estado_del_Caso_de_Prueba__c = 'Pruebas Finalizadas' ];
    
  /* Actualizar la nueva cantidad de casos en el Ciclo de Prueba */
  List<IQA_Ciclo_de_Pruebas__c> listCiclos = new List<IQA_Ciclo_de_Pruebas__c>([ SELECT Id, 
                                                                                        Total_de_Casos_de_Prueba__c,
                                                                                        Total_de_Casos_que_no_Suman__c,
                                                                                        Total_de_Casos_Pbas_Finalizadas__c,
                                                                                        Estado_del_Ciclo_de_Pruebas__c
                                                                                 FROM   IQA_Ciclo_de_Pruebas__c 
                                                                                 WHERE  Id = :cicloID ]);

  for( IQA_Ciclo_de_Pruebas__c regCiclo: listCiclos ) {

    regCiclo.Total_de_Casos_de_Prueba__c = cantCasos;
    regCiclo.Total_de_Casos_que_no_Suman__c = cantCasosNoSuman;
    regCiclo.Total_de_Casos_Pbas_Finalizadas__c = cantCasosPbasFinalizadas;
    
System.Debug('regCiclo.Estado_del_Ciclo_de_Pruebas__c: ' + regCiclo.Estado_del_Ciclo_de_Pruebas__c);
System.Debug('estadoCaso: ' + estadoCaso);

    /* Si el estado actual del Ciclo de Pruebas es 'Aprobado para la Ejecución' */ 
    /* y el nuevo estado del Caso de Prueba es 'Ejecución en Progreso'          */
    /* entonces se pone el nuevo estado del Ciclo de Pruebas en 'En Progreso'   */
    if ( regCiclo.Estado_del_Ciclo_de_Pruebas__c == 'Aprobado para Ejecución' && estadoCaso == 'En Progreso'  ) {
        regCiclo.Estado_del_Ciclo_de_Pruebas__c = 'En Progreso' ;
        System.Debug('Se puso el estado del ciclo de pruebas en progreso' );
    }

  } /* for */

  try{
    update listCiclos;
  } /* try */

  Catch(Exception E){
      System.Debug('Ocurrió un error: ' + e.getMessage());
  } /* Catch */
  
} // trigger