/**
*Class Name: ANEFI_SCH_ValidateLeadSLA.
*Description: Clase Schedulable que ejecuta el Batch ANEFI_BAT_ValidateLeadSLA.
*Created Date: 10/5/2023, 11:20 AM.
*Created By: Intellect Systems.   
*Last Modified by: Intellect Systems 10/5/2023, 14:16 PM.
*/
global class ANEFI_SCH_ValidateLeadSLA implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Implement any logic to be scheduled

        // We now call the batch class to be scheduled
        ANEFI_BAT_ValidateLeadSLA b = new ANEFI_BAT_ValidateLeadSLA();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,50);
    }
}