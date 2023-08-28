public with sharing class OW_LandingPageController {
    public OW_LandingPageController() {
        /* Constructor Empty for now */
        System.debug('Hello');
    }
    @AuraEnabled(cacheable=true)
    public static List<string> fetchObjectDataFromOrg(){
        try {
            Map<String,String> objectMap = new Map<String,String>();
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
               String name = objTyp.getDescribe().getName();
               String label = objTyp.getDescribe().getLabel();
               if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
                    !name.containsignorecase('share') && !name.containsignorecase('feed') && 
                       !name.containsignorecase('group') && !name.containsignorecase('public') &&
                    !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() &&
                    objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                    objectMap.put(name,label);
               }
            }
            System.debug(objectMap);
            if(objectMap != null && objectMap.size() > 0){
                System.debug('@@@List'+objectMap.values());
                return objectMap.values();   
            }else{
                return null;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<User> fetchUsersFromOrg(){
        try {
            List<User> listUserName = new List<User>();
            /*for(User objUser : [Select Id,Name FROM User WHERE IsActive = true WITH SECURITY_ENFORCED]){
                listUserName.add(objUser.Name);
            }*/
            listUserName = [Select Id,Name FROM User WHERE IsActive = true WITH SECURITY_ENFORCED];
            return listUserName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}