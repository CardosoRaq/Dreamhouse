// Module: Asynchronous Apex
// Trail: Control Processes with Queueable Apex
// Data: 23/11/23

@isTest
public class AddPrimaryContactTest {
    
    @TestSetup
    static void makeData(){

        
    }

    static testmethod void testQueueable() {

        List<Account> accs = new List<Account>();

        for (Integer i=0; i<50; i++){
            accs.add(new Account(Name='Test Account'+i, BillingState='NY'));
        }
        for (Integer j=0; j<50; j++){
            accs.add(new Account(Name='Test Account'+j, BillingState='CA'));
        }
        insert accs;

        Contact ctt = new Contact(FirstName='Test', LastName='Contact');
        insert ctt;

        AddPrimaryContact contact = new AddPrimaryContact(ctt,'CA');

        Test.startTest();
        System.enqueueJob(contact);
        Test.stopTest(); 

        System.assertEquals(50, [SELECT count() FROM Contact WHERE accountId IN (SELECT Id FROM Account WHERE BillingState='CA')]);
    }
}