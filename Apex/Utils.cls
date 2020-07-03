/******************************************************************** **  
                            *******************
                            **** DISCAIMER ****
                            *******************

    The code below is for illustrative purposes only. It is not intended
    to be production quality, merely an example of how things can be 
    accomplished. The author takes no responsibilty for the inner workings
    and/or any defects that may occur as a result of using it. Please
    see the Salesforce Master Contract for more details.

********************************************************************* **/ 

/********************************************************************************************************** 
NAME			:	RESTMessage  
DESCRIPTION 	:	TODO
DATE			:	May 2020
AUTHOUR			:	Ravi Raj (Salesforce Snr Program Architect)

HISTORY         :
VERSION  	AUTHOR   	        DATE  		    DESCRIPTIOM    
1.0    		Ravi Raj  	        May 2020	    Initial Release
***********************************************************************************************************/
public class Utils 
{
    public static String getObjectName(Object objGeneric) 
    {
        if(objGeneric == null) return '';                   // we can't say much about null with our current techniques
        if(objGeneric instanceof SObject)                   return ((SObject)objGeneric).getSObjectType().getDescribe().getName(); 
        if(objGeneric instanceof Boolean)                   return 'Boolean';
        if(objGeneric instanceof Id)                        return 'Id';
        if(objGeneric instanceof String)                    return 'String';
        if(objGeneric instanceof Blob)                      return 'Blob';
        if(objGeneric instanceof Date)                      return 'Date';
        if(objGeneric instanceof Datetime)                  return 'Datetime';
        if(objGeneric instanceof Time)                      return 'Time';
        if(objGeneric instanceof String)                    return 'String';
        if(objGeneric instanceof Integer)                   return 'Integer';
        if(objGeneric instanceof Long)                      return 'Long';

        // we can't distinguish between decimal and double
        if(objGeneric instanceof Decimal)                   return 'Decimal';  
        if(objGeneric instanceof Double)                    return 'Double';   
        if(objGeneric instanceof List<object>)              return 'List';

        //Custom objects
        if(objGeneric instanceof Cross_Org_Collaboration__c) return 'Cross_Org_Collaboration__c';
        if(objGeneric instanceof msgREST_RES_COMP_Error)    return 'msgREST_RES_COMP_Error';
        if(objGeneric instanceof msgREST_RES_COMP_Detail)   return 'msgREST_RES_COMP_Detail';

        // Nothing on the list so return unknown
        return 'Unknown';                           
    }

    public static void sleep(Long milliSeconds)
    {
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do
        {
            timeDiff = System.now().getTime() - firstTime.getTime();
        }
        while(timeDiff <= milliSeconds);
    }
}
