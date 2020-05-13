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
    Returns		: void
    Throws 		: n/a
    ********************************************************************/
	public void processFeed(List<FeedItem> lstFeedItemsNew)
    {
        //List<String> lstOpptyIds = new List<String>();
        List<List<FeedItem>> lstFeedItemToSave = new List<List<FeedItem>>();
        Map<String, List<FeedItem>> mapMyMap = new Map<String, List<FeedItem>>();
        Map<Opportunity, List<FeedItem>> mapOpptyFeedItems = new Map<Opportunity, List<FeedItem>>();

        try 
        {
            List<String> lstOpptyIds = getOpportunitySubSet(lstFeedItemsNew,  mapMyMap);
            
            If(!lstOpptyIds.isEmpty())
            {
                mapOpptyFeedItems = getOpportunityForOneForce(lstOpptyIds, mapMyMap);
                /*  if (!lstFeedItemToSave.isEmpty())
                {
                    saveCustomFeedItems(lstFeedItemToSave);
                } */ 
            }   
        } 
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [processFeed()]' );
        }
 	}  

    /*******************************************************************    
    Purpose		: Given a set of FeedItems, return a subset that don't meet a particular criteria
                  (i.e. FeedItems that are not linked to Opportunties and are not created by certain Users)
    Parameters	: [lstFeedItemsNew]	: list of [FeedItems] to process
                  [mapMyMap]        : Map structure to hold Opportuntiy Ids and their corresponding FeedItems 
    Returns		: List<String> which contains a list of Opportunity Ids. 
                  Note: [mapMyMap] is used here By Reference  
    Throws 		: n/a
    ********************************************************************/
    public Map<Opportunity, List<FeedItem>> getOpportunityForOneForce(List<String> lstOpptyIds, Map<String, List<FeedItem>> mapMyMap)
    {
        Map<Opportunity, List<FeedItem>> mapOpptyFeedItems = new Map<Opportunity, List<FeedItem>>();

        try 
        {
            //get the oppties that OneForce knows about
            //** TODO ** - replace the OneForce field name on Opportunity with the real one
            List<Opportunity> lstOppty = [SELECT 	 Id
                                                    ,OneForce_Project_Id__c 
                                            FROM 	Opportunity 
                                            WHERE   Id IN :lstOpptyIds
                                            AND     OneForce_Project_Id__c <> NULL];

            For (Opportunity opp: lstOppty)
            {
                //add the Opportunity object along with a list of [FeedItems] from the original Map to a newly created Map
                mapOpptyFeedItems.put(opp, mapMyMap.get(opp.Id));
            }        
        }
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [getOpportunityForOneForce()]' );
        }  
        return mapOpptyFeedItems;   
    }

    /*******************************************************************    
    Purpose		: Given a set of FeedItems, return a subset that don't meet a particular criteria
                  (i.e. FeedItems that are not linked to Opportunties and are not created by certain Users)
    Parameters	: [lstFeedItemsNew]	: list of [FeedItems] to process
                  [mapMyMap]        : Map structure to hold Opportuntiy Ids and their corresponding FeedItems 
    Returns		: List<String> which contains a list of Opportunity Ids. 
                  Note: [mapMyMap] is used here By Reference  
    Throws 		: n/a
    ********************************************************************/
    public List<String> getOpportunitySubSet(List<FeedItem> lstFeedItemsNew, Map<String, List<FeedItem>> mapMyMap)
    {
        List<String> lstOpptyIds = new List<String>();

        try 
        {
            For(FeedItem objItem: lstFeedItemsNew)
            {
                //only process Opportunities 
                if (objItem.ParentId.getSObjectType().getDescribe().getName() == strOPPORTUNITY)
                {
                    //only process where user is not the Integration user (to avoid recursion)
                    If (objItem.InsertedBy.FirstName != strINT_USER_FIRST_NAME &&
                        ObjItem.InsertedBy.LastName  != strINT_USER_LAST_NAME)
                    {                    
                        mapMyMap = saveToMap(mapMyMap, objItem.ParentId, objItem);

                        //Store the Oppties (if not stored before)
                        If(!lstOpptyIds.contains(objItem.ParentId))
                        {
                            lstOpptyIds.add(objItem.ParentId); 
                        }                                       
                    }  
                }
            }
        } 
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [getOpportunitySubSet]');
        }  
        return lstOpptyIds;       
    }

    /*******************************************************************    
    Purpose		: Helper method
    Parameters	: [lstFeedItems]	: list of [FeedItems] to save
    Returns		: void  
    Throws 		: n/a
    ********************************************************************/
    public Map<String, List<FeedItem>> saveToMap(Map<String, List<FeedItem>> mapMyMap
                                                ,String strOpportunityId
                                                ,FeedItem objFeedItem)
    {
        try 
        {
            //check to see if the Oppty Id exists
            List<FeedItem> lstFeedItems = mapMyMap.get(strOpportunityId);

            //if((lstFeedItems.isEmpty()) || (lstFeedItems = null))
            if(lstFeedItems == null)
            {
                //Oppty does NOT exist, so create
                List<FeedItem> lstNewFeedItems = new List<FeedItem>();
                lstNewFeedItems.add(objFeedItem);
                mapMyMap.put(strOpportunityId, lstNewFeedItems);
            }
            else
            {
                //Oppty does exist, so append 
                lstFeedItems.add(objFeedItem);
                mapMyMap.put(strOpportunityId, lstFeedItems);               
            }
        } 
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [saveToMap()]' );
        }
        return mapMyMap;
     }

     /*
    public class CollaborationWrapper
    {
        public FeedItem objFeedItem = new FeedItem();
        public Opportunity objOpportunity = new Opportunity();
        public String idOpportunity = '';
    }
    */
}



