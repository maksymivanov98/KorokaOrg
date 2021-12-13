@isTest
public class ProjectTaskTest {
    @isTest static void TestChangeStatusProjectTask() {
         Project_Task__c[] pt = ProjectTaskTestDataFactory.createProjectTask(5);
         for(integer i = 0; i < pt.size(); i ++){
             pt.get(i).Status__c = 'Status 1';
         }
         update pt;
    }
    @isTest static void TestChangeAssigneeProjectTask() {
         Project_Task__c[] pt = ProjectTaskTestDataFactory.createProjectTask(5);
         Project_Member__c pm = ProjectTaskTestDataFactory.createProjectMember();

        
        for(integer i = 0; i < pt.size(); i ++){
             pt.get(i).Assignee__c = pm.Id;
         }
         
         update pt;
    }
}