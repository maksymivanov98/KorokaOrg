public with sharing class ProjectTaskController {
@AuraEnabled
    public static List<Project_Task__c> getProjectTask() {
        return [SELECT 
                id, 
                Name, 
                Status__c
                FROM Project_Task__c ];
    }
    @AuraEnabled
    public static void updateTask(Id newTaskId, String newStatus){
        Project_Task__c updateTask = new Project_Task__c(Id = newTaskId, Status__c = newStatus);
        Database.update(updateTask);
    }
}