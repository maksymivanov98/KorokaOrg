public with sharing class ProjectTaskController {
@AuraEnabled
    public static List<Project_Task__c> getProjectTask(String recordId) {
        return [SELECT 
                id, 
                Name, 
                Status__c,
                Project__c
                FROM Project_Task__c WHERE Project__c =:recordId];
    }
    @AuraEnabled
    public static void updateTask(Id newTaskId, String newStatus){
        Project_Task__c updateTask = new Project_Task__c(Id = newTaskId, Status__c = newStatus);
        Database.update(updateTask);
    }
    
    @AuraEnabled
    public static void deleteTask(Id newTaskId){
        Project_Task__c deleteTask = new Project_Task__c(Id = newTaskId);
        Database.delete(deleteTask);
    }

}