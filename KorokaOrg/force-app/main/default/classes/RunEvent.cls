global class RunEvent{
    @AuraEnabled
    @future
    public static void addNotification(Integer numberNotif)
    {   
        List<Notification__e> notifications = new List<Notification__e>();
        for (Integer i = 0; i < numberNotif; i++ ) {
             notifications.add(new Notification__e(Message__c = 'Notification #' + i));
        }
        List<Database.SaveResult> results = EventBus.publish(notifications);

        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                 for (Database.Error error : result.getErrors()) {
                      System.debug('Error returned: ' + error.getStatusCode() +' - '+ error.getMessage());
                 }
            }
        }
    }
}