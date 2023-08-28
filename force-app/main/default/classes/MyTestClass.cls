@isTest(SeeAllData=false)
private class MyTestClass 
{
    @testSetup
    static void TestSetupMethood(){
        Lead leadObj = TestDataFactoryDemo.createLead(true);
        Lead leadObj2 = TestDataFactoryDemo.createLead(false);
        leadObj2.LastName ='MyName';
        insert leadObj2 ;
        Account accObj = TestDataFactoryDemo.createAccount(true);
        Contact contObj = TestDataFactoryDemo.createContact(true,accObj.id);
        Opportunity oppObj = TestDataFactoryDemo.createOpportunity(true,accObj.id);
        Case caseObj = TestDataFactoryDemo.createCase(true);
    }
    
    @isTest 
    static void myUnitTest() 
    {
        //Lead leadObj = TestDataFactoryDemo.createLead(true);
        Lead leadobj = [Select Id FROM Lead LIMIT 1];
        Account accObj = TestDataFactoryDemo.createAccount(true);
        Contact contObj = TestDataFactoryDemo.createContact(true,accObj.id);
        Opportunity oppObj = TestDataFactoryDemo.createOpportunity(true,accObj.id);
        Case caseObj = TestDataFactoryDemo.createCase(true);
    }
    // If you want to edit data according to apex class then try like below
    
    @isTest 
    static void myUnitTest1() 
    {
        Lead leadObj = TestDataFactoryDemo.createLead(false); // pass false
        leadObj.LastName ='MyName';
        insert leadObj ;
        
        Account accObj = TestDataFactoryDemo.createAccount(false);
        accObj.Name ='MyName';
        insert accObj;
        
    }
    
}