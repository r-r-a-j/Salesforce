({
	clickCreateItem: function(component, event, helper) 
    {
        var validItem = component.find('campingform').reduce(function (validSoFar, inputCmp) 
                                                                {
                                                                    // Displays error messages for invalid fields
                                                                    inputCmp.showHelpMessageIfInvalid();
                                                                    return validSoFar && inputCmp.get('v.validity').valid;
                                                                }, true);
        // If we pass error checking, do some real work
        if(validItem)
        {
            // Create the new expense
            var lstItems = component.get("v.items");
            var objItem = component.get("v.newItem");
			 
            helper.createItem(component, objItem);

        }
    }
})