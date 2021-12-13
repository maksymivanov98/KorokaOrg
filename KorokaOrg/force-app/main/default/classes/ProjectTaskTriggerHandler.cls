public class ProjectTaskTriggerHandler implements ITriggerHandler{
    
    private static final String ASSIGNEE_IS_CHANGED_TEMPLATE_NAME = 'Task_assignee_is_changed';
    private static final String STATUS_IS_CHANGED_TEMPLATE_NAME = 'Task_status_is_changed';
    private Map<String, Id> emailTemplateNameToId;

    
    public void beforeInsert(List<SObject> newList){} 

    public void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){}

    public void beforeDelete(Map<Id, SObject> oldMap){}

    public void afterInsert(Map<Id, SObject> newMap){}
    
    public void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        //send emails to the task owner and task assignee if aprropriate field is changed
        sendEmails((Map<Id, Project_Task__c>)newMap, (Map<Id, Project_Task__c>)oldMap); 
    }

    private void sendEmails(Map<Id, Project_Task__c> newMap, Map<Id, Project_Task__c> oldMap){
        //init templates
        initEmailTemplates();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(Project_Task__c newTask : newMap.values()){
            
            Boolean isStatusChanged = true; //TODO: check if status is changed
            Boolean isAssigneeChanged = true; //TODO: check if assignee is changed
            
            if(newMap.get(newTask.id).Status__c!= oldMap.get(newTask.id).Status__c){
                isStatusChanged = true;
            }else{
                isStatusChanged = false;
            }
            if(newMap.get(newTask.id).Assignee__c!= oldMap.get(newTask.id).Assignee__c){
                isAssigneeChanged = true;
            }else{
                isAssigneeChanged = false;
            }
            
            if(isStatusChanged){
                //Prepare email message using the Messaging.SingleEmailMessage class
                emailsList.add(prepareEmailMessage(newTask, emailTemplateNameToId.get(STATUS_IS_CHANGED_TEMPLATE_NAME)));
            } 
            if(isAssigneeChanged){
                //Prepare email message using the Messaging.SingleEmailMessage class
                emailsList.add(prepareEmailMessage(newTask, emailTemplateNameToId.get(ASSIGNEE_IS_CHANGED_TEMPLATE_NAME)));
            }
        }
        if(emailsList.size()>0){
            Messaging.sendEmail(emailsList, false);
        }
        //TODO: if emailsList is not empty, send emails using the Messaging.sendEmail() method.
    }

    private void initEmailTemplates(){
        List<EmailTemplate> templates = [SELECT Id, DeveloperName 
                                            FROM EmailTemplate 
                                            WHERE DeveloperName =: STATUS_IS_CHANGED_TEMPLATE_NAME
                                            OR DeveloperName =: ASSIGNEE_IS_CHANGED_TEMPLATE_NAME];
        this.emailTemplateNameToId = new Map<String, Id>();
        for(EmailTemplate template : templates){
            emailTemplateNameToId.put(template.DeveloperName, template.Id);
        }
    }
    
    private Messaging.SingleEmailMessage prepareEmailMessage(Project_Task__c projectTask, Id emailTemplate){
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate, UserInfo.getUserId(), projectTask.Id);
        String emailSubject = email.getSubject();
        String emailTextBody = email.getPlainTextBody();
        email.setTargetObjectId(UserInfo.getUserId());
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailTextBody);
        email.saveAsActivity = false;
        return email;
        
       /* Messaging.SingleEmailMessage newEmailMessage = new Messaging.SingleEmailMessage();
        newEmailMessage.setTemplateId(emailTemplate);
        newEmailMessage.setTargetObjectId(projectTask.CreatedById);
        newEmailMessage.setWhatId(projectTask.Id);
        newEmailMessage.setSaveAsActivity (false);
        return newEmailMessage;*/
    }

    
    public void afterDelete(Map<Id, SObject> oldMap){}

    public void afterUndelete(Map<Id, SObject> oldMap){}


}