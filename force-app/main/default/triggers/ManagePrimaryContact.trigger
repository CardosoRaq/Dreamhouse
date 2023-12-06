//Practical Exercise 1: Apex Triggers

trigger ManagePrimaryContact on Contact (before insert, before update, after insert, after update) {

    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            ManagePrimaryContactTriggerHandler.preventDuplicatePrimaryContacts(Trigger.new);
        }
    }
    if(trigger.isAfter){
        // if(trigger.isInsert || trigger.isUpdate){
        //     System.enqueueJob(new ReplicatePrimaryContactPhone(Trigger.new));
        // }
        if (!ReplicatePrimaryContactPhone.isJobEnqueued()) {
            System.enqueueJob(new ReplicatePrimaryContactPhone(Trigger.new));
        }
    }
}