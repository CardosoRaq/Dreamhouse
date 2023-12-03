// Module: Asynchronous Apex
// Trail: Use Batch Apex
// Data: 22/11/23

@isTest
public class LeadProcessorTest {
    
    @TestSetup
    static void makeData(){

        List<Lead> leads = new List<Lead>();
        //insert 200 Leads
        for (Integer i=0; i<200; i++){
            leads.add(new Lead(LastName='Lead '+i, Company='Company '+i, Status='Open'));
        }
        insert leads;
    }

    @isTest
    static void test(){
        
        Test.startTest();
        LeadProcessor leadProcess = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcess);
        Test.stopTest();

        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}