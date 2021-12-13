@isTest
public class ProjectTaskTestDataFactory {
    public static list<Project_Task__c> createProjectTask(Integer numProjTask){
        
        Project__c project = new Project__c(Name = 'Test Project', Project_Stage__c = 'New');
        insert project;
        
        list<Project_Task__c> ptList = new list<Project_Task__c>();
        
        for(integer i = 0; i < numProjTask; i++){
            Project_Task__c pt = new Project_Task__c(Name = 'Test Project Task' + i , Project__c = project.id);
            ptList.add(pt);
        }
        insert ptList;
        
        return ptList;
    }
      public static Project_Member__c createProjectMember(){
          
        Project__c project = new Project__c(Name = 'Test Project', Project_Stage__c = 'New');
        insert project;
        
        Project_Member__c projectMember = new Project_Member__c(Name = 'Test Project Member', Project__c = project.id , Job_Role__c = 'QA');
        insert projectMember;
        return projectMember;
    }
}