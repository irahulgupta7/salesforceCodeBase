({
	doInit : function(component, event, helper) {
		helper.getAllAccountName(component, event);
	},
    onChange: function (component, event, helper) {
        helper.getAllRelatedContact(component, event);
    },
    addSelected: function(component, event, helper){
        var tempIDs = [];
        var getAllId = component.find("checkBox");
        for (var i = 0; i < getAllId.length; i++) {
       		if (getAllId[i].get("v.value") == true) {
                tempIDs.push(getAllId[i].get("v.text"));
            }
        }
        component.set('v.SelectedContacts',tempIDs);
         
    },
    showDateandTime :function(component, event, helper){
    	document.getElementById('demo').innerHTML = Date()
    }
})