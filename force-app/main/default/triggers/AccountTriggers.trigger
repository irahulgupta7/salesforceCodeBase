trigger AccountTriggers on Account (before insert, before update,after insert, after update, before delete, after delete) {
    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('I am in AccountTrigger before insert context');
        System.debug('I am in AccountTrigger before insert context'+ trigger.size);
        AccountControllerUnManaged.CallFromTrigger(Trigger.isExecuting);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        System.debug('I am in AccountTrigger before update context');
        AccountControllerUnManaged.CallFromTrigger2();
        //AccountControllerUnManaged.CallFromTrigger4();
        //AccountControllerUnManaged.CallFromTrigger3();
        
        
    }
    if(Trigger.isAfter && Trigger.isInsert){
        AccountControllerUnManaged.CallFromTrigger3(trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('I am in AccountTrigger after update context');
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        System.debug('I am in AccountTrigger before delete context');
    }
    if(Trigger.isAfter && Trigger.isDelete){
        System.debug('I am in AccountTrigger After delete context');
    }
    
    
}