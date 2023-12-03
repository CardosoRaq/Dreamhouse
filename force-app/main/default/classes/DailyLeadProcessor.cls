// Module: Asynchronous Apex
// Trail: Shedule Jobs Using the Apex Scheduler
// Data: 23/11/23

public class DailyLeadProcessor implements Schedulable{
    
    public void execute(SchedulableContext ctx) {
        
        List<Lead> listLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource='' LIMIT 200];
        List<Lead> leadsUpd = new List<Lead>();

        for (Lead ld : listLeads){
            ld.LeadSource = 'Dreamforce';
            leadsUpd.add(ld);
        }
        update leadsUpd;
    }

}