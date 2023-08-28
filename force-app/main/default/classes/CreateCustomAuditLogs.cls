global class CreateCustomAuditLogs implements Database.Batchable<sObject>{
    
    global List<AuditBatch__c> myCustomValues = AuditBatch__c.getAll().Values();
    global date dt = myCustomValues[0].Last_Job_Run_Dates__c;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
       String sQuery= 'SELECT Id,Action,CreatedDate,CreatedBy.Email,CreatedById,CreatedBy.Name,Display,Section FROM SetupAuditTrail';
       sQuery = sQuery+' WHERE DAY_ONLY(CreatedDate) >='+String.valueOf(dt);
       sQuery = sQuery+' ORDER BY CreatedDate DESC';
       System.debug('sQuery'+sQuery);
       return Database.getQueryLocator(sQuery);
    }
    global void execute(Database.BatchableContext bc,List<sObject>scope){
        System.debug('@@@@scope'+scope);
        List<Audit_Trails__c> insertAuditTrails = new List<Audit_Trails__c>();
        List< Audit_Logs__b > insertAuditBigObject = new List< Audit_Logs__b >();
        for (SetupAuditTrail objLogs: (List<SetupAuditTrail>)scope){
            
            Audit_Logs__b objBigObject = new Audit_Logs__b();
            objBigObject.Audit_Record_Id__c = objLogs.Id;
            objBigObject.Audit_Action__c    = objLogs.Action;
            objBigObject.Audit_Display__c = objLogs.Display;
            objBigObject.Audit_Section__c = objLogs.Section ;
            objBigObject.Audit_CreatedBy__c= objLogs.CreatedBy.Name;
            objBigObject.Audit_CreatedBy_Email__c = objLogs.CreatedBy.Email;
            objBigObject.Audit_Created_Date__c = objLogs.CreatedDate;
            insertAuditBigObject.add(objBigObject);
            
            Audit_Trails__c objCreateAudit = new Audit_Trails__c();
            objCreateAudit.Audit_Record_Id__c = objLogs.Id;
            objCreateAudit.Audit_Action__c    = objLogs.Action;
            objCreateAudit.Audit_Display__c = objLogs.Display;
            objCreateAudit.Audit_Section__c = objLogs.Section ;
            objCreateAudit.Audit_CreatedBy__c= objLogs.CreatedById;
            objCreateAudit.Audit_CreatedBy_Email__c = objLogs.CreatedBy.Email;
            objCreateAudit.Audit_Created_Date__c = objLogs.CreatedDate;
            insertAuditTrails.add(objCreateAudit);
            
        }
        
        if (!insertAuditBigObject.isEmpty()){
            database.insertImmediate(insertAuditBigObject);
        }
        
        if (!insertAuditTrails.isEmpty()){
            insert insertAuditTrails;
        }
    } 
    global void finish(Database.BatchableContext bc){
        AuditBatch__c obj = AuditBatch__c.getValues('Data');
        obj.Last_Job_Run_Dates__c = System.today();
        update obj;
    }
}