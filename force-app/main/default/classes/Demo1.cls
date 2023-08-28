public class Demo1 {
   public static void mainValueMethod(){
       for (Account acc: [Select Id ,Name , (Select Id,Name FROM Contacts) FROM Account Where Name != null]){
            if (acc.Contacts.size()>0){
                System.debug('Here is Debug');
                System.debug('acc'+acc);
                System.debug('acc'+acc.Contacts);
            }
        }
    }
}