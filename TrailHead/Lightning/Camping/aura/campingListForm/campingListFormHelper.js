({
    createItem: function(component, newItem) 
    {
        //addEvent.setParams({"item" : newItem});
		//addEvent.fire();

        var createEvent = component.getEvent("addItemEvent");
        createEvent.setParams({ "item": newItem });
        createEvent.fire();
        component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c','Name': '','Packed__c': false, 'Price__c': 0,'Quantity__c': 0});






    },
    
})