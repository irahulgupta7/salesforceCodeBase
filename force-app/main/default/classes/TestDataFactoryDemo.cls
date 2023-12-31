@isTest
public with sharing class TestDataFactoryDemo
{
    /** 
    * ********************************************************
    * This method is test data for create Lead
    * ********************************************************
    */

    public static Lead createLead(Boolean doInsert)
    {
        Lead newLead = new Lead() ;
        newLead.FirstName = 'Cole';
        newLead.LastName = 'Swain';
        newLead.Company = 'BlueWave';
        newLead.Status = 'contacted';
        if(doInsert){
            insert newLead;
        }
        return newLead;
    }

    public static Void convertLead(Lead newLead )
    {
        database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(newLead.id);
        leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        lc.setOpportunityName('Cole Swain');
        
    }
        
    /** 
    * ******************************************************
    * This method is test data for create Account
    * ******************************************************
    */
    
    public static Account createAccount(Boolean doInsert)
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        if(doInsert){
            insert acc;
        }
        return acc;
    }
       
     /**
     * *******************************************************
     * This method is test data for create contact object
     * *******************************************************
     */
    public static Contact createContact(Boolean doInsert)
    {
        return createContact(doInsert, createAccount(true).Id);
    }
    
    public static Contact createContact(Boolean doInsert, Id accId)
    {
        Contact con = new Contact();
        con.AccountId = accId;
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.Email = 'FirstName@test.com' + Math.floor(Math.random() * 1000);
        if(doInsert)
        {
            insert con;
        }
        return con;
    }

    /**
    * ***********************************************************
    * This method is test data for create Opportunity object
    * ***********************************************************
    */
    
    public static Opportunity createOpportunity(Boolean doInsert, Id accId)
    {
        Opportunity oppt = new Opportunity(Name ='New mAWS Deal',
                            AccountID = accId,
                            StageName = 'Customer Won',
                            Amount = 3000,
                            CloseDate = System.today()
                            );
        if(doInsert)
        {
            insert oppt;
        }
        return oppt;
    }   
    
    /**
    * ************************************************************
    * This method is test data for create Case object
    * ************************************************************
    */
        
    public static Case  createCase(Boolean doInsert )
    {
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email');
        if(doInsert)
        {
            insert cas ;
        }
        return cas ;
    }    
    
}