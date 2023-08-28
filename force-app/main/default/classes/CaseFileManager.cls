@RestResource(urlMapping='/FilesWithCase/*')
global with sharing class CaseFileManager {
   
    @HttpPost
    global static void createCase(List <String>contentFileIds , String CaseId) {
       System.debug ('Hello'+ contentFileIds );
       System.debug ('Hello CaseId'+ CaseId);
       List<ContentVersion> cvList = new List<ContentVersion>();
       For ( String objString : contentFileIds ){
       
       Blob b=Blob.valueOf('This is version data');
       ContentVersion cv = new ContentVersion();
       cv.ContentLocation = 'S';
       cv.ContentDocumentId = objString;
       //cv.versiondata=Encodingutil.base64Encode(b);

       cv.Title = 'Hello';
       //cv.PathOnClient = filename;
       cvList.add(cv); 
        
       }
       System.debug ('List'+ cvList);
       
    }
}