public with sharing class AuditTrailController {
    @AuraEnabled(cacheable=true)
    public static List<AuditTrailEntry> getAuditTrailData(Date startDate, Date endDate, String section, String category, Integer pageSize, Integer pageNumber) {
        Integer offset = (pageNumber - 1) * pageSize;
        
        String query = 'SELECT Id, Action, CreatedDate, Display, Section, Category FROM SetupAuditTrail';

        if (startDate != null && endDate != null) {
            query += ' WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate';
        }

        if (section != null && section != '') {
            if (query.contains('WHERE')) {
                query += ' AND Section = :section';
            } else {
                query += ' WHERE Section = :section';
            }
        }

        if (category != null && category != '') {
            if (query.contains('WHERE')) {
                query += ' AND Category = :category';
            } else {
                query += ' WHERE Category = :category';
            }
        }

        query += ' ORDER BY CreatedDate DESC LIMIT :pageSize OFFSET :offset';

        List<SetupAuditTrail> auditTrailList = Database.query(query);
        List<AuditTrailEntry> auditTrailEntries = new List<AuditTrailEntry>();

        for (SetupAuditTrail auditTrail : auditTrailList) {
            AuditTrailEntry entry = new AuditTrailEntry();
            entry.Id = auditTrail.Id;
            entry.Action = auditTrail.Action;
            entry.CreatedDate = auditTrail.CreatedDate;
            entry.Display = auditTrail.Display;
            entry.Section = auditTrail.Section;
            //entry.Category = auditTrail.Category;
            auditTrailEntries.add(entry);
        }

        return auditTrailEntries;
    }

    public class AuditTrailEntry {
        @AuraEnabled public Id Id;
        @AuraEnabled public String Action;
        @AuraEnabled public DateTime CreatedDate;
        @AuraEnabled public String Display;
        @AuraEnabled public String Section;
        @AuraEnabled public String Category;
    }
}