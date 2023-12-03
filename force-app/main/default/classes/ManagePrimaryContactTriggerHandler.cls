//Practical Exercise 1: Apex Triggers

public with sharing class ManagePrimaryContactTriggerHandler {

    public static void preventDuplicatePrimaryContacts(List<Contact> newList) {

        try {

            Set<Id> accountIds= new Set<Id>();
            for(Contact c:newList){
                if(c.accountId!=null && c.Primary_Contact__c){
                    accountIds.add(c.accountId);
                }
            }

            List<Account> accounts=[SELECT Id, Name, (SELECT Id, Primary_Contact__c FROM Contacts) FROM Account WHERE Id in :accountIds];
            if(!accounts.isEmpty()){
                for(Account acc:accounts){
                    Boolean havePrimaryContact = false;
                    Id primaryContactId;
                    for(Contact c:acc.contacts){ 
                        if(c.Primary_Contact__c){
                            havePrimaryContact = true;
                            primaryContactId = c.Id;
                            break;
                        }     
                    }
                    for(Contact contact:newList){
                        if(havePrimaryContact && contact.Id != primaryContactId) {
                            contact.Primary_Contact__c.AddError('There is primary contact that already exist.');
                        }
                    }
                }
            }
            

        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
        }
    }
}