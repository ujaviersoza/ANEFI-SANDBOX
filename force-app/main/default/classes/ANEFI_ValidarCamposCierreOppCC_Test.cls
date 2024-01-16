@isTest
public class ANEFI_ValidarCamposCierreOppCC_Test {
	@TestSetup
    static void dataFactory(){
    	ANEFI_TestDataFactory.crearDatos();        
    }
    
    @isTest
    static void obtenerCamposFaltantesOportunidadJuridicaTest(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name from Opportunity 
                                           where recordType.Name = 'Persona Jurídica' AND StageName = 'Propuesta' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
            ANEFI_ValidarCamposCierreOportunidadCC.obtenerCamposFaltantesCierreOportunidad(oportunidad.Id);
        }
    }
    
    @isTest
    static void obtenerCamposFaltantesOportunidadJuridicaCP1Test(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name from Opportunity 
                                           where recordType.Name = 'Persona Jurídica' AND StageName = 'Propuesta' 
                                           AND Name = 'Oportunidad CP-1' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
            ANEFI_ValidarCamposCierreOportunidadCC.obtenerCamposFaltantesCierreOportunidad(oportunidad.Id);
        }
    }

    @isTest
    static void obtenerCamposFaltantesOportunidadNaturalTest(){        
        Opportunity oportunidad = null;        
        List<Opportunity> oportunidades = [Select Id, Name from Opportunity 
                                           where recordType.Name = 'Persona Natural' AND StageName = 'Propuesta' ];
        if(oportunidades.size() > 0){
            oportunidad = oportunidades.get(0);
            ANEFI_ValidarCamposCierreOportunidadCC.obtenerCamposFaltantesCierreOportunidad(oportunidad.Id);
        }
    }
    
    /*Método para verificar que no se puede eliminar un Oportunidad ya existente en Gestor*/
   	/*@isTest
	static void eliminarOportunidadesincronizadaEnGestorTest(){   
        User us = ANEFI_UT_DataFactory.createUserPardot();
        System.runAs(us) {
        	Opportunity opp = ANEFI_UT_DataFactory.createOpportunity();   
            delete opp;
        }    
    }*/
}