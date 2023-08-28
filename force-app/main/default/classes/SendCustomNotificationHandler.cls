public class SendCustomNotificationHandler {
	
    public static void sendNotifs(){
       	CustomNotificationType objCustomNotif = [SELECT Id FROM CustomNotificationType 
                                                 WHERE DeveloperName = 'Send_Notification_When_Oppty_is_Closed_Won_Lost'];
        Messaging.CustomNotification sendNotification = new Messaging.CustomNotification();
        sendNotification.setBody('Custom Notification -- Winter 21 Release');
        sendNotification.setTitle('Custom Notifications By Apex');
        sendNotification.setSenderId(Userinfo.getUserId());
        sendNotification.setNotificationTypeId(objCustomNotif.id);
        sendNotification.setTargetId(Userinfo.getUserId()); 
        sendNotification.send(new Set<String> { Userinfo.getUserId() });
    }
}