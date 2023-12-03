// Module: Asynchronous Apex
// Trail: Use Fuuture Methods
// Data: 22/11/23

@IsTest
public class AccountProcessorTest {

    /*@TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.FirstName = 'Test Acc';
        acc.LastName = 'Test1';
        insert acc;
        
        Contact ctt1 = new Contact();
        ctt1.AccountId = acc.Id;
        //ctt1.Name = 'Ctt Test1';
        insert ctt1;

        Contact ctt2 = new Contact();
        ctt2.AccountId = acc.Id;
        //ctt2.Name = 'Ctt Test2';
        insert ctt2;
    }*/

    @IsTest
    static void countContactsTest() {

        Account acc = new Account();
        acc.Name = 'Acc Test1';
        insert acc;
        
        Contact ctt1 = new Contact();
        ctt1.AccountId = acc.Id;
        ctt1.LastName = 'Ctt Test1';
        insert ctt1;

        Contact ctt2 = new Contact();
        ctt2.AccountId = acc.Id;
        ctt2.LastName = 'Ctt Test2';
        insert ctt2;

        List<Account> accounts = [SELECT Id, Name, Number_Of_Contacts__c, (SELECT Id FROM Contacts) FROM Account];
        List<Id> accId = new List<Id>();
        accId.add(accounts[0].Id);
        //System.debug(accounts);

        Test.startTest();
        AccountProcessor.countContacts(accId);
        Test.stopTest();

        List<Account> account = [SELECT Id, Name, Number_Of_Contacts__c, (SELECT Id FROM Contacts) FROM Account];
        //System.debug(account);
        System.assertEquals(2, account[0].Number_Of_Contacts__c);
    }
}