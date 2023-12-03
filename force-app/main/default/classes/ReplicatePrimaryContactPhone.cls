//Practical Exercise 1: Apex Triggers

public class ReplicatePrimaryContactPhone implements Queueable{
    
    private Set<Id> accountIds;
    private List<Account> listAccounts;

    public ReplicatePrimaryContactPhone(List<Contact> newCttIds){

        Set<Id> accountIds= new Set<Id>();
        for(Contact c:newCttIds){
            if(c.accountId!=null){
                accountIds.add(c.accountId);
            }
        }
        listAccounts = [SELECT Id, (SELECT Id, Name, Primary_Contact__c, Primary_Contact_Phone__c FROM Contacts) FROM Account WHERE Id in :accountIds];
    }

    public void execute(QueueableContext context) {

        List<Contact> cttsToUpdate = new List<Contact>();

        if(!listAccounts.isEmpty()){
            for(Account acc:listAccounts){
                String primaryPhone;
                for(Contact c:acc.contacts){ 

                    if(c.Primary_Contact__c){
                        if(!String.isBlank(c.Primary_Contact_Phone__c)){
                            primaryPhone = c.Primary_Contact_Phone__c;
                            break;
                        }    
                    }
                }
                for(Contact contact:acc.contacts){
                    if(contact.Primary_Contact_Phone__c != primaryPhone) {
                        contact.Primary_Contact_Phone__c = primaryPhone;
                        cttsToUpdate.add(contact);
                    }        
                }    
            }
        }
        update cttsToUpdate;    
    }
}