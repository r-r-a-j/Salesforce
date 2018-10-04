/*
 *	DESCRIP		:	Apex Server Class to get all properties from SF 
 *  AUTHOR		: 	Ravi Raj [RR]
 *	DATE		: 	04/10/18
 * 	HISTORY		: 	ID 	 	  DATE			 AUTHOR			 DESCRIPTION
 *				  	====	========		=========		=============	
 *				   	1		04/10/18		Ravi Raj		Initial
 *				   	2		04/10/18		Ravi Raj		Added Lightning Data Service and Communicate Between Components
 **/ 
public with sharing class MyPropertyController {
    @AuraEnabled
    public static List<Property__c> getSimilarProperties (Id recordId, String searchCriteria, Decimal beds, Decimal price, Decimal priceRange ) 
    {
        if (searchCriteria == 'Bedrooms') 
        {
            return [	SELECT   Id
                    			,Name
                    			,Beds__c
                    			,Baths__c
                    			,Price__c
                    			,Broker__c
                    			,Status__c
                    			,Thumbnail__c
                		FROM 	Property__c 
                    	WHERE 	Id != :recordId 
                    	AND 	Beds__c = :beds];
        } 
        else 
        {
            Decimal range;
            if (priceRange == null) 
            {
                range = 100000;
            }
            else
            {
                range = priceRange;
            }
            	return [
                    SELECT 	 Id
                            ,Name
                            ,Beds__c
                            ,Baths__c
                            ,Price__c
                            ,Broker__c
                            ,Status__c
                            ,Thumbnail__c
                    FROM 	Property__c 
                    WHERE 	Id != :recordId 
                    AND 	Price__c > :price - range 
                    AND 	Price__c < :price + range];
        }
    }
}