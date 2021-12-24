@isTest
public class CalloutServiceTest {
@isTest static void getMe() {
    
    Project__c project = new Project__c(Name = 'Test Project', Project_stage__c = 'New');
    insert project;
    Project_Task__c pt = new Project_Task__c(Name = 'Test Project Task', Project__c = project.id);
    insert pt;
    List<id> recordid = new List<id>();
    recordid.add(pt.id);
       Test.startTest();
       System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

       CalloutService.sendEmails(recordid);

       System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
       Test.stopTest();
    }
}