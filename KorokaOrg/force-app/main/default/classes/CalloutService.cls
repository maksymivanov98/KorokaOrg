public class CalloutService {
    public static String NEW_TASK = 'New_task_is_assigned';
    public static Map<String, Id> emailTemplateNameToId;
    
    
    public static void sendEmails(List<Id>ptid){
        //init templates
        List<Project_task__c> listTask = [SELECT Name,
                                          Assignee__c,
                                          Assignee__r.Employee__c,
                                          Assignee__r.Employee__r.id
                                          FROM Project_Task__c
                                          WHERE id =: ptid];
        initEmailTemplates();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(Project_Task__c newTask : listTask){
                emailsList.add(prepareEmailMessage(newTask, emailTemplateNameToId.get(NEW_TASK), newTask.Assignee__r.Employee__r.id));
        }
        if(emailsList.size()>0){
            Messaging.sendEmail(emailsList, false);
        }
    }
    
    public static void initEmailTemplates(){
        List<EmailTemplate> templates = [SELECT Id, DeveloperName 
                                         FROM EmailTemplate 
                                         WHERE DeveloperName =: NEW_TASK];
        emailTemplateNameToId = new Map<String, Id>();
        for(EmailTemplate template : templates){
            emailTemplateNameToId.put(template.DeveloperName, template.Id);
        }
    }
    
    public static Messaging.SingleEmailMessage prepareEmailMessage(Project_Task__c projectTask, Id emailTemplate, id assigneeId){
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate, UserInfo.getUserId(), projectTask.Id);
        String emailSubject = email.getSubject();
        String emailTextBody = email.getPlainTextBody();
        email.setTargetObjectId(assigneeId);
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailTextBody);
        email.saveAsActivity = false;
        return email;
    }
}