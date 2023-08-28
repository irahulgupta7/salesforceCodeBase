({
    handleSaveRecord : function(component, event, helper) {
        component.find("AccountRecordCreator").saveRecord($A.getCallback(function(saveResult) {
             if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                //console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                cmp.set("v.recordSaveError", errMsg);
            }
             else {
                cmp.set("v.recordSaveError", "");
                }
            
                
                
               
        }));
    }
})