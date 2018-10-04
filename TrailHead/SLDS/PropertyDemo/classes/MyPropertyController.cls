/*
 *	DESCRIP		:	Apex Server Class to get all properties from SF 
 *  AUTHOR		: 	Ravi Raj [RR]
 *	DATE		: 	04/10/18
 * 	HISTORY		: 	ID 	 	  DATE			 AUTHOR			 DESCRIPTION
 *				  	====	========		=========		=============	
 *				   	1		04/10/18		Ravi Raj		Initial
 **/ 
public with sharing class MyPropertyController 
{
    @AuraEnabled
    public static List<Property__c> findProperties (Id recordId, Decimal priceRange) 
    {
        List<Property__c> property = [SELECT Price__c FROM Property__c WHERE Id=:recordId];
        Decimal propertyPrice = property[0].Price__c;
        List<Property__c> similarProperties = getSimilarProperties(recordId, priceRange, propertyPrice);
        return similarProperties;
    }
    
    private static List<Property__c> getSimilarProperties (Id recordId, Decimal priceRange, Decimal price ) 
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