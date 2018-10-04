/*
 *	DESCRIP		:	Controller class
 *  AUTHOR		: 	Ravi Raj [RR]
 *	DATE		: 	04/10/18
 * 	HISTORY		: 	ID 	 	  DATE			 AUTHOR			 DESCRIPTION
 *				  	====	========		=========		=============	
 *				   	1		04/10/18		Ravi Raj		Added [navToRecord] method to navigate to similar property
 *				   	2		04/10/18		Ravi Raj		Added [handleSuccess] & [handleCancel] methods
 **/ 
({
    navToRecord : function (component, event, helper) 
    {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({"recordId": component.get("v.property.Id")});
        navEvt.fire();
    },
    editRecord : function(component, event, helper) 
    {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({"recordId": component.get("v.property.Id")});
        editRecordEvent.fire();
    },
    handleSuccess : function(component, event, helper) 
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
                                "title": "Success!",
                                "message": "The property's info has been updated.",
                                "type": "success"
                            });
        toastEvent.fire();
        helper.showHide(component);
    },
    handleCancel : function(component, event, helper) 
    {
        helper.showHide(component);
        event.preventDefault();
    }

})