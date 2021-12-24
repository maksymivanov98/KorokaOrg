global class PrepareSpentTimeEmail implements Schedulable{
    public static void execute(SchedulableContext ctx) {
    sendRequest();
    }
    
    @future(callout = true)
    global static void sendRequest(){
        List <User> users = [SELECT id From User];
        List<id> iduser = new List<id>();
        for(User idusers:users){
            iduser.add(idusers.id);
        }
    
    List<Project_Task__c> projectTask = [SELECT Name, 
                                         Total_Time_Spent_h__c, 
                                         CreatedById,
                                         CreatedBy.FirstName, 
                                         CreatedDate
                                         FROM Project_Task__c 
                                         WHERE CreatedDate = YESTERDAY
                                         ORDER BY CreatedById];
    List <String> messagesList = new List<String>();
    List <id> usersid = new List<id>();
    List <String> userFirstName = new List<String>();
    String nameUser = '';
    String singleMessage = '';
    integer userNumber = 0;
    for(integer i = 0; i< projectTask.size();i++){
        if(i==0){
            usersid.add(projectTask.get(i).CreatedById);
            userFirstName.add(projectTask.get(i).CreatedBy.FirstName);
            singleMessage = singleMessage + 'Hi ' + userFirstName.get(i) + ', here is a summary of your project tasks progress:';
            singleMessage = singleMessage + '\n' + '<br>- task ' + projectTask.get(i).Name + ': ' + projectTask.get(i).Total_Time_Spent_h__c + 'h spent yesterday;';
        }
        if(i!=0 && projectTask.get(i-1).CreatedById == projectTask.get(i).CreatedById){
            singleMessage = singleMessage + '\n' + '<br>- task ' + projectTask.get(i).Name + ': ' + projectTask.get(i).Total_Time_Spent_h__c + 'h spent yesterday;';
        }else if(i!=0 && projectTask.get(i-1).CreatedById != projectTask.get(i).CreatedById ){
            messagesList.add(singleMessage);
            singleMessage = '';       
            usersid.add(projectTask.get(i).CreatedById);
            userFirstName.add(projectTask.get(i).CreatedBy.FirstName);
            userNumber++;
            singleMessage = singleMessage + 'Hi ' + userFirstName.get(userNumber) + ', here is a summary of your project tasks progress:';
            singleMessage = singleMessage + '\n' + '<br>- task ' + projectTask.get(i).Name + ': ' + projectTask.get(i).Total_Time_Spent_h__c + 'h spent yesterday;';
        }
        if(i == projectTask.size() - 1){
            messagesList.add(singleMessage);
        }
    }
    
    System.debug(usersid);
    System.debug(messagesList);
    CalloutServiceSpentTimeEmail.sendEmails(usersid,messagesList);
    }
     
}