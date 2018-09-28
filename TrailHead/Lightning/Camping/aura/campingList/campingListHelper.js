({
    createItem: function(component, item) 
    {
        this.saveItem(component, item, function(response)
                         						{
                                                    var state = response.getState();
                                                    if (state === "SUCCESS") 
                                                    {
                                                        var item = component.get("v.items");
                                                        item.push(response.getReturnValue());
                                                        component.set("v.items", item);
                                                    }
                                                });
    },
    updateItem: function(component, item) 
    {
        this.saveItem(component, item);
    },
})