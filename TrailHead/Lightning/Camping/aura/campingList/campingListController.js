({
    // Load expenses from Salesforce
    doInit: function(component, event, helper) 
    {
        // Create the action
        var action = component.get("c.getItems");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) 
                                    {
                                        var state = response.getState();
                                        if (state === "SUCCESS") 
                                        {
                                            component.set("v.items", response.getReturnValue());
                                        }
                                        else 
                                        {
                                            console.log("Failed with state: " + state);
                                        }
                                    });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    handleAddItem: function(component, event, helper) 
    {
        // Create the new expense
        //var lstItems = component.get("v.items");
        //var objItem = component.get("v.newItem");
        
        var item = event.getParam("item");
        var action = component.get("c.saveItem");
		action.setParams({"item": item});
		
        action.setCallback(this, function(response)
                           			{
                                        var state = response.getState();
										if (component.isValid() && state === "SUCCESS") 
                                        {
                                            var items = component.get("v.items");
											items.push(item);
											component.set("v.items",items);
                                        }
                                    });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})