public class TestFuture{
    
    public static void callFuture(){
        Account obj = new Account ();
        obj.AccountNumber = 'Test';
        obj.Name = 'Rahul';
        insert obj;
        System.debug('Step1'+obj);
        futureMethood(obj.Id);
    }
    
    @future
    public static void futureMethood(Id objFId){
       System.debug('Step2'+objFId);
       Savepoint sp;
       try{
        Account  obj = new Account (Id = objFId);   
        obj.AccountNumber = 'Test1';
        update obj;
        System.debug('Step3'+obj);
        sp = Database.setSavepoint();
        obj.AccountNumber = 'Test3';
        update obj;
        System.debug('Step4'+obj);
        integer i= 1/0;
        
        }
        catch(Exception excn){
            Database.RollBack(sp);
            System.debug('Exception'+excn);
        }
    }
}