// Module: Asynchronous Apex
// Trail: Shedule Jobs Using the Apex Scheduler
// Data: 23/11/23

@isTest
public class DailyLeadProcessorTest {

    public static String CRON_EXP = '0 0 0 24 11 ? 2024';

    @isTest
    static void testScheduledJob() {

        List<Lead> listLeads = new List<Lead>();
        for (Integer i=0; i<200; i++){
            listLeads.add(new Lead(LastName='Lead '+i, Company='Company '+i, Status='Open'));
        }
        insert listLeads;

        Test.startTest();
        String jobId = System.schedule('ScheduleApexTest', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();

        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}