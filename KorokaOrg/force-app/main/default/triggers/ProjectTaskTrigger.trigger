trigger ProjectTaskTrigger on Project_Task__c (before insert, before update, after update) {
     TriggerFactory.getInstance().handle(Project_Task__c.sObjectType);
}