public class popup
{    
    public boolean displayPopup {get; set;}
    public String accId {get; set;}  
    public Account acc {get;set;}
    
    public popup(){
        
        accId = System.currentPageReference().getParameters().get('account');
        Account acc = [Select Id , Name from Account where Id =: accId];
        showPopup();
        
    }  
   
    public pagereference closePopup()
    {      
        displayPopup = false; 
        PageReference pr = new PageReference('/apex/ACCOUNTVF');
        pr.setRedirect(true);
        return pr; 
    }    
    public void showPopup()
    {      
        displayPopup = true;
       
    }  
  }