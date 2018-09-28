public with sharing class CampingListController 
{
    @AuraEnabled
	public static List<Camping_Item__c> getItems()
    {
        /*
         * Correct way to check visibility of fields. This needs to be done be the developer         * 
         * 
         **/
         
        // Check to make sure all fields are accessible to this user
        String[] fieldsToCheck = new String[] {'Id', 'Name', 'Amount__c', 'Client__c', 'Date__c','Reimbursed__c', 'CreatedDate'};
        
        Map<String, Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Camping_Item__c.fields.getMap();
        
        for(String field : fieldsToCheck) {
            if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        
       //If we're here, then visibilty is ok, so proceed.... 
        
       return [SELECT	 Id
               			,Name
               			,Price__c
               			,Quantity__c
               			,Packed__c   			
                FROM 	Camping_Item__c];
     }
    
    @AuraEnabled
	public static Camping_Item__c saveItem(Camping_Item__c objItem)
    {
        // Perform isUpdatable() checking first, then
        upsert objItem;
        return objItem;
        
    }
}