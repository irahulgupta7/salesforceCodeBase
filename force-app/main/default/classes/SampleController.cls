public class SampleController {
    @AuraEnabled( cacheable=true )  
    public static List < FAQ__mdt > fetchSampleRecs() {
        return [ SELECT Id, Question__c ,Answer__c  FROM FAQ__mdt  ];
        
    }

}