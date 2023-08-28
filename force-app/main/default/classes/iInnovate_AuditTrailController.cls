public class iInnovate_AuditTrailController {
	
    @AuraEnabled(cacheable=true)
    public static List<User> fetchUsersFromOrg(){
        try {
            List<User> listUserName = new List<User>();
            listUserName = [Select Id,Name FROM User WHERE IsActive = true WITH SECURITY_ENFORCED];
            return listUserName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<SetupAuditTrail> fetchAuditTrails(){
        try {
            List<SetupAuditTrail>listTrails = [SELECT Id,Action,CreatedBy.Name,CreatedBy.Email,CreatedDate,
                                               Display,Section ,DelegateUser FROM SetupAuditTrail 
                                               Where Action != null
                                               WITH SECURITY_ENFORCED
                                               LIMIT 100];
            return listTrails;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}