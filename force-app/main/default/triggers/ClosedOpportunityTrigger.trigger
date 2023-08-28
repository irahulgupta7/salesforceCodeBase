trigger ClosedOpportunityTrigger on Opportunity (before insert) {
    
    List<Task> taskList = new List<Task>();
    for(Opportunity opr : Trigger.new){
        if(opr.stageName =='Closed Won'){
           Task newTask = new Task(whatID = opr.ID, Subject='Follow Up Test Task'); 
            //A task is created with Opportunity ID and with the subject.
                taskList.add(newTask);  
        }
        
    }
    if(taskList.size()>0){
        insert tasklist;
    }

}