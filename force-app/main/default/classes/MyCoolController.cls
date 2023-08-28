public class MyCoolController {
    public List<Account> accountList { // Create something for your VF page to look at
        get;
        set;
    }

    public MyCoolController() { // When the controller is called, query and populate accountList
        accountList = [Select Id, Name FROM Account LIMIT 10];
    }
}