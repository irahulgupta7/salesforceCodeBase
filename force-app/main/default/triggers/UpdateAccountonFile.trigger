trigger UpdateAccountonFile on ContentVersion (after insert) {

    Set<Id> docIds = new Set<Id>();
    
    for(ContentVersion cv : trigger.new){  
       
      if(cv.ContentDocumentId != null)
            {
                docIds.add(cv.ContentDocumentId);
        }  
    }    
    System.debug ('Hello World'); 
    
   
}