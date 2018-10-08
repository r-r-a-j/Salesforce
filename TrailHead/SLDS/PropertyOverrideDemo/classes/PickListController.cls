/*
 *	DESCRIP		:	Apex Server Class to picklist values 
 *  AUTHOR		: 	Ravi Raj [RR]
 *	DATE		: 	04/10/18
 * 	HISTORY		: 	ID 	 	  DATE			 AUTHOR			 DESCRIPTION
 *				  	====	========		=========		=============	
 *				   	1		04/10/18		Ravi Raj		Initial
 **/ 
public class PickListController 
{
    // [objectType] = "Property__c"
    // [selectedField] = "Status__c"
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField)
    {
        List<String> pickListValuesList = new List<String>();
        
        //Cast String to Object
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        
        //Get Object's meta data
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        
        //Get the field's meta data 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        
        //Reach up to the field and retrieve its Picklist values
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry pickListVal : ple)
        {
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
}

}