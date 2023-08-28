public class ContactBasisOnAcct {
@AuraEnabled
    public static list<Account> getAllAccount()
    {
        return[Select id, Name from Account];
    }

    @AuraEnabled
    public static list<Contact> getAllContacts( Id  AccId)
    {
       System.debug('@@Selected Id '+ AccId); 
        return[Select id, Name,Email,AccountId from Contact Where AccountId =: AccId];
    }
}