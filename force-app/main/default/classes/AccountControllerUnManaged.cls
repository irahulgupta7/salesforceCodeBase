Public class AccountControllerUnManaged {
    public static void CallFromTrigger( boolean triggerContext){
        System.debug('triggerContext'+triggerContext);
    }
    public static void CallFromTrigger2(){
        System.debug('triggerContext22222');
    }
    public static void CallFromTrigger3(List<Account> listAccount){
        System.debug('triggerContext22222');
        list<Contact> listContactCreated = new List<Contact>();
        for (Account Acc: listAccount){
            Contact obj = new Contact();
            obj.lastName = Acc.name;
            obj.Title = 'Created from Trigger';
            obj.AccountId = Acc.Id;
            listContactCreated.add(obj);
        }
        if (listContactCreated != null && listContactCreated.size()>0){
            insert listContactCreated;
        }
    }
}