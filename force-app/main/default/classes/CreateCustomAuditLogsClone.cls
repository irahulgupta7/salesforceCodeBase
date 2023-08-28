global class CreateCustomAuditLogsClone implements Database.Batchable<sObject>{
    global List<AuditBatch__c> myCustomValues = AuditBatch__c.getAll().Values();
    global date dt = myCustomValues[0].Last_Job_Run_Dates__c;
    
   // Datetime myDate = DateTime.parse(dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')); format()
   //string datetimestr = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
   //global datetime datetimevalue = Datetime.valueOf(datetimestr);
   
    global Database.QueryLocator start(Database.BatchableContext bc) {
       //System.debug('dt'+ dt);
       String sQuery= 'SELECT Id,Action,CreatedDate,CreatedBy.Email,CreatedById,CreatedBy.Name,Display,Section FROM SetupAuditTrail';
       sQuery = sQuery+' WHERE DAY_ONLY(CreatedDate) >='+String.valueOf(dt);
       sQuery = sQuery+' ORDER BY CreatedDate DESC';
       System.debug('sQuery'+sQuery);
       return Database.getQueryLocator(sQuery);
    }
    global void execute(Database.BatchableContext bc,List<sObject>scope){
        System.debug('@@@@scope'+scope);
     }
     global void finish(Database.BatchableContext bc){  
     }
}