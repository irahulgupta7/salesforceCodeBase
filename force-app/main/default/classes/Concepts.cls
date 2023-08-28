public class Concepts {
    public static void insertAccountContact(){
        List<sObject> lstsobject = new list<sObject>();
		//Intialize Account 
        Account objAcc = new Account(); 
        objAcc.Name= 'Rahul';
        //Intialize Contact
        Contact objcon = new Contact(); 
        objcon.LastName= 'Rahul';
        //Add both to the list
        lstsobject.add(objAcc);
        lstsobject.add(objcon);
        insert lstsobject;
    }
}