//Practical Exercise: Batch and Scheduled Jobs

public class SumOpportunityAmounts implements Database.Batchable<sObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator('SELECT Id, AccountId, Amount, StageName, CreatedDate, CloseDate FROM Opportunity WHERE CreatedDate = THIS_MONTH OR CloseDate = THIS_MONTH');
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> listOpp) {
        
        System.debug('List Opp: '+listOpp);

        Set<Id> oppAccountIds = new Set<Id>();
        for(Opportunity opp:listOpp){
            oppAccountIds.add(opp.AccountId);
        }

        List<Account> listAccount = new List<Account>([SELECT Id, Name, AmountOppClosedLost__c, AmountOppClosedWon__c, AmountOppOpen__c FROM Account WHERE Id IN :oppAccountIds]);
        System.debug('List Acc: '+listAccount);
        List<Contact> listContact = new List<Contact>([SELECT Id, Primary_Contact__c, Email FROM Contact WHERE AccountId IN :listAccount AND Primary_Contact__c = true]);
        System.debug('List Ctt '+listContact);

        List<Account> amountsToUpdate = new List<Account>();
        if(!listAccount.isEmpty()) {
            for(Account account:listAccount) {

                Double aWon=0;
                Double aLost=0;
                Double aOpen=0;

                for(Opportunity opp:listOpp) {
                    if (opp.accountId == account.Id) {
                        if(opp.StageName == 'Closed Won') {
                            aWon += opp.Amount;
                        }else if (opp.StageName == 'Closed Lost') {
                            aLost += opp.Amount;
                        }else {
                            aOpen += opp.Amount;
                        }
                    }
                }

                account.AmountOppClosedWon__c = aWon;
                account.AmountOppClosedLost__c = aLost;
                account.AmountOppOpen__c = aOpen;
                System.debug('AmountOppClosedWon: '+account.AmountOppClosedWon__c);
                System.debug('AmountOppClosedLost: '+account.AmountOppClosedLost__c);
                System.debug('AmountOppOpen: '+account.AmountOppOpen__c);
                
                amountsToUpdate.add(account);
                System.debug('Contas para atualizar: '+account);    
            }

            if(!amountsToUpdate.isEmpty()) {
                update amountsToUpdate;
            }
        }
        sendEmails(listAccount);
    }

    public void finish(Database.BatchableContext bc){}

    public void execute(SchedulableContext ctx) {
        
        // Daily at 10:00 AM
        String cronDaily = '0 0 10 * * ?';

        // Every Friday at 1:00 PM
        //String cronWeekly = '0 0 13 ? * FRI';

        // Last Friday of the month at 6:00 PM
        //String cronMonthly = '0 0 18 ? * 6L';

        String jobName = 'SumOpportunityAmountsJob';
        System.schedule(jobName, cronDaily, this);
    }

    private void sendEmails(List<Account> listAccount) {

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    
        if(!listAccount.isEmpty()){
            for(Account account:listAccount){
                for(Contact c:account.contacts){ 
                    if(c.Primary_Contact__c){

                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[]{c.Email});
                        email.setTemplateId('00XHn000001nuHJ');
                        emailMessages.add(email);
                        break;
                    }     
                }
            }
        }

        if (!emailMessages.isEmpty()) {
            try {
                Messaging.sendEmail(emailMessages);
            } catch (Exception e) {
                System.debug('Erro ao enviar e-mail: ' + e.getMessage());
            }
        }
    }
}