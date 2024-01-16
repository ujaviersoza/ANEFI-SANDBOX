/*jbarco
Abril 2020
Clase para programar el descarte automático de candidatos que llevan abiertos 90 días o mas y no han sido cualificados*/
global class ANEFI_DescartarCandidatos implements Schedulable {
	global void execute(SchedulableContext ctx) {
        Integer cantidadDiasAEvaluar = 90;
        List<Lead> candidatos = [SELECT Id, Name, OwnerId, CreatedDate 
            					FROM Lead
            					WHERE Status != 'Cualificado' AND Status != 'Descartado' AND Cantidad_dias_abierto__c >=: cantidadDiasAEvaluar];
        
        for(Lead candidato : candidatos){
            candidato.Razon_de_descarte__c = 'Tiempo';
            candidato.Status = 'Descartado';
        }
        
        update candidatos;     
        
    }
}