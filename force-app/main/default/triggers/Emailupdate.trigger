trigger Emailupdate on User (before insert) {
    list<String> userEmails = new list<String>();
	for(User u:trigger.new){
      system.debug('user after for-->'+u);
      userEmails.add(u.Manager_Email__c);
	  
	}
    list<user> userlist =  [Select Id,Email,Manager_Email__c,ManagerId from User where Email IN : userEmails];
	Map<String, Id> mapUser = new Map<String,Id>();
    for(User u:userlist){
        mapUser.put(u.Email,u.Id);
    }
    for(User u : trigger.new){
		u.ManagerId = mapUser.get(u.Manager_Email__c);
	}
}