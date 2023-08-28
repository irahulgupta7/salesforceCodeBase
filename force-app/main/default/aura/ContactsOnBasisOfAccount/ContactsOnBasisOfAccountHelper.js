({
	getAllAccountName : function(component, event) {
		var action = component.get("c.getAllAccount");
        action.setCallback(this, function(actionResult) {
     		component.set('v.accounts', actionResult.getReturnValue());
    		});
    	$A.enqueueAction(action);
  		},
    
    getAllRelatedContact:function(component, event) {
        var action = component.get("c.getAllContacts");
        var selectedAccountId = component.find('acc').get('v.value');
        alert(component.find('acc').get('v.value') + ' pie is good.' + selectedAccountId);
        action.setParams({
            AccId: selectedAccountId
        });
        action.setCallback(this, function(a) {
            //get the response state
            var state = a.getState();
                component.set('v.Contacts', a.getReturnValue());
           
        });
    	 
        $A.enqueueAction(action);
    },
    getAllShowSelectedRecords:function(component, event,ChildRecordIds) {
        component.set('v.SelectedContacts',ChildRecordIds);
    }
	
    
    
})