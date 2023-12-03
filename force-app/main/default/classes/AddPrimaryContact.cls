// Module: Asynchronous Apex
// Trail: Control Processes with Queueable Apex
// Data: 22/11/23

public class AddPrimaryContact implements Queueable {
    
    private Contact contact;
    private String state;
    public AddPrimaryContact(Contact ctt, String stt){
        this.contact = ctt;
        this.state = stt;
    }

    public void execute(QueueableContext context) {
        List<Account> listAcc = [SELECT Id, Name, (SELECT Id, LastName FROM Contacts) FROM Account WHERE BillingState = :state LIMIT 200];
        List<Contact> listCtt = new List<Contact>();

        for (Account acc : listAcc){
            Contact c = contact.clone();
            c.AccountId = acc.Id;
            listCtt.add(c);
        }

        if(listCtt.size() > 0){
            insert listCtt;
        }
    }
}