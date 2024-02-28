public class LeadDeletionQueueable implements Queueable {
    List<Id> leadIdsToDelete;

    public LeadDeletionQueueable(List<Id> leadIds) {
        this.leadIdsToDelete = leadIds;
    }

    public void execute(QueueableContext context) {
        Database.delete(leadIdsToDelete);
    }
}