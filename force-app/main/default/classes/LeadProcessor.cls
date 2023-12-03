// Module: Asynchronous Apex
// Trail: Use Batch Apex
// Data: 22/11/23

public class LeadProcessor implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> listLeads){
        // process each batch of records
        List<Lead> leadsUpd = new List<Lead>();

        for (Lead ld : listLeads){
            ld.LeadSource = 'Dreamforce';
            leadsUpd.add(ld);
        }
        update leadsUpd;
    }

    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}