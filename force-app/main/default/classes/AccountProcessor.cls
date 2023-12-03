// Module: Asynchronous Apex
// Trail: Use Future Methods
// Data: 22/11/23

public class AccountProcessor {

    @future
    public static void countContacts(List<Id> accountIds) {

        List<Account> accounts = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds];
        List<Account> accUpdate = new List<Account>();

        for (Account acc:accounts) {
            List<Contact> contacts = acc.Contacts;
            acc.Number_Of_Contacts__c = contacts.size();
            accUpdate.add(acc);
        }
        update accUpdate;
    }
}