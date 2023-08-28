public class Demo {
    
    public void mainValueMethod(){
        
        String websiteUrl = 'www.google.com';
        
        System.debug('Before value call ' + websiteUrl);
        passByValueCall(websiteUrl);
        System.debug('After value call ' + websiteUrl);
    }
    
    private static void passByValueCall(String websiteUrlValue){       
        
        System.debug('websiteUrlValue'+websiteUrlValue);    
        websiteUrlValue = 'www.salesforce.com'; 
        System.debug('websiteUrlValue'+websiteUrlValue);
    }
    
    public static void mainReferenceMethod(){
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Website = 'www.google.com';
        
        System.debug('Before reference call ' + a);
        passByRefCall(a);
        System.debug('After reference call ' + a);
    }     

    private static void passByRefCall(Account a){                      
        a.Website = 'www.salesforce.com';
    }
}