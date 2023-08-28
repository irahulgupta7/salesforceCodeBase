public class ReteriveData {
	@AuraEnabled(cacheable=true)    
    public static list<Account> getAccountData(){
        return [Select Id, Name,Phone From Account LIMIT 10];
    }
    @AuraEnabled(cacheable=true)    
    public static list<Account> getAccountDataFromId(Id AccountId){
        return [Select Id, Name,Phone,Industry,Type,Fax,Rating From Account WHERE ID =: AccountId];
    }
}