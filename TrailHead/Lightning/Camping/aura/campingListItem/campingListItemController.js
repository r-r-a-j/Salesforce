({
	packItem : function(component, event, helper) 
    {
		//get item obj
		component.set("v.item.Packed__c", true);
        event.set("v.disabled", true);
        
	}
})