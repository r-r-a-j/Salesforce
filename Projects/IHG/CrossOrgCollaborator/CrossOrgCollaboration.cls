/******************************************************************** **  
NAME			:	CrossOrgCollaboration  
DESCRIPTION 	:	Class to aid Cross Org Collaboration between GOLS and OneForce	                                                             
DATE			:	May 2020
AUTHOUR			:	Ravi Raj, Salesforce Snr Program Architect

HISTORY

VERSION  	AUTHOR   	DATE  		DESCRIPTIOM    
1.0    		Ravi Raj  	May 2020	Initial Release
********************************************************************* **/ 
public class CrossOrgCollaboration 
{
    private final String strINT_USER_FIRST_NAME = 'Integration';
    private final String strINT_USER_LAST_NAME = 'User';
    private final String strOPPORTUNITY = 'Opportunity';
    
    /*******************************************************************    
    Purpose		: Processes a list of [FeedItems] and extracts a subset of these
    Parameters	: [lstFeedItemsNew]	: list of [FeedItems] from a Trigger    
    Returns		: n/a  
    Throws 		: [Exceptions]: [optional]
    ********************************************************************/
	public void processFeed(List<FeedItem> lstFeedItemsNew)
    {
        List<Id> lstOpptyIds = new List<Id>();
        List<FeedItem> lstFeedItemToSave = new List<FeedItem>();
        
        For(FeedItem objItem: lstFeedItemsNew)
        {
            //only process Opportunities 
			if (objItem.ParentId.getSObjectType().getDescribe().getName() == strOPPORTUNITY)
            {
                //only process where user is not the Integration user (to avoid recursion)
                If (objItem.InsertedBy.FirstName != strINT_USER_FIRST_NAME &&
                    ObjItem.InsertedBy.LastName  != strINT_USER_LAST_NAME)
                {
                    //Store the Oppties
                	lstOpptyIds.add(objItem.ParentId);                
                }  
            }
        }
        
        //get the oppties
        List<Opportunity> lstOppty = [SELECT 	 id
                                      			,OneForce_Project_Id__c 
                                      FROM 		Opportunity 
                                      WHERE 	Id IN :lstOpptyIds];
        
        For (Opportunity opp: lstOppty)
        {
            //only process Opportunities that OneForce knows about
            If (opp.OneForce_Project_Id__c != null)
            {
                System.debug('opp.Id = ' + opp.OneForce_Project_Id__c);   
                //lstFeedItemToSave.add();
            }
        }
 	}    
    
    /*private void saveCustomFeedItems()
    {
        
    }
    
    private void sendFeedItems()
    {
        
    }*/
}
