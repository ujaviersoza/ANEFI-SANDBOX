/**
*Class Name: ANEFI_SCH_ValidateOpportunitySLA.
*Description: Clase Schedulable que ejecuta el Batch ANEFI_BAT_ValidateOpportunitySLA.
*Created Date: 5/6/2023, 17:20 PM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 5/6/2023, 17:23 PM.
*/
global class ANEFI_SCH_ValidateOpportunitySLA implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Implement any logic to be scheduled

        // We now call the batch class to be scheduled
        ANEFI_BAT_ValidateOpportunitySLA b = new ANEFI_BAT_ValidateOpportunitySLA();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,50);
    }
}