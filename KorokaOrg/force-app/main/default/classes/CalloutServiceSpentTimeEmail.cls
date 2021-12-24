public class CalloutServiceSpentTimeEmail {
    
    public static void sendEmails(List<id>userid,List<String>messageEmail){
        List<User>emailsUser = [SELECT id,Email FROM User WHERE id=:userid];
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(integer i = 0; i< userid.size();i++){
                emailsList.add(prepareEmailMessage(emailsUser.get(i).Email, messageEmail.get(i), userid.get(i)));
        }
        if(emailsList.size()>0){
            Messaging.sendEmail(emailsList, false);
        }
    }
    
    public static Messaging.SingleEmailMessage prepareEmailMessage(String Emailaddress, String emailmessage, id userid){
        Messaging.SingleEmailMessage newEmailMessage = new Messaging.SingleEmailMessage();
        newEmailMessage.setTargetObjectId(userid);
        List <String> emaillist = new List<String>();
        emaillist.add(Emailaddress);
        newEmailMessage.setToAddresses(emaillist);
        newEmailMessage.setSubject('Spent Time');
        newEmailMessage.setHtmlBody(emailmessage);
        newEmailMessage.setSaveAsActivity (false);
        return newEmailMessage;
    }
}