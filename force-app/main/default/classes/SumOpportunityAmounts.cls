//Practical Exercise: Batch and Scheduled Jobs

public class SumOpportunityAmounts implements Database.Batchable<sObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute

        return Database.getQueryLocator('SELECT Id, AccountId, Amount, StageName, CreatedDate, CloseDate FROM Opportunity WHERE CreatedDate = THIS_MONTH OR CloseDate = THIS_MONTH');
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> listOpp) {
        
        // List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        // EmailTemplate emailTemp = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = ''];
        System.debug('List Opp: '+listOpp);

        Set<Id> oppAccountIds = new Set<Id>();
        for(Opportunity opp:listOpp){
            oppAccountIds.add(opp.AccountId);
        }

        List<Account> listAccount = new List<Account>([SELECT Id, Name, AmountOppClosedLost__c, AmountOppClosedWon__c, AmountOppOpen__c FROM Account WHERE Id IN :oppAccountIds]);
        System.debug('List Acc: '+listAccount);
        List<Contact> listContact = new List<Contact>([SELECT Id, Primary_Contact__c, Email FROM Contact WHERE AccountId IN :listAccount AND Primary_Contact__c = true]);
        System.debug('List Ctt '+listContact);

        if(!listAccount.isEmpty()) {
            for(Account account:listAccount) {

                List<Account> amountsToUpdate = new List<Account>();
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
                //--------------------------------------------------------------------------------------------
                // for(Contact c:account.contacts){
                //     if(c.Primary_Contact__c && !String.isBlank(c.Email)){
                //         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //         mail.setTemplateId(emailTemp.Id);
                //         mail.setTargetObjectId(con.Id);
                //         emailList.add(mail);
                //     }else {
                //         System.debug('Erro. O contato não possui e-mail.');
                //     }
                // }
            }
            // if(!emailList.isEmpty()){
            //     Messaging.sendEmail(emailList);
            // } 
        }
    }

    public void finish(Database.BatchableContext bc){
        
    }

    public void execute(SchedulableContext ctx) {}
}