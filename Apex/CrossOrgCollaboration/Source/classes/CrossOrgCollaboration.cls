/******************************************************************** **  
                            *******************
                            **** DISCAIMER ****
                            *******************

    The code below is for illustrative purposes only. It is not intended
    to be production quality, merely an example of how things can be 
    accomplished. The author takes no responsibilty for the inner workings
    and/or any defects that may occur as a result of using it. Please
    see the Salesforce Master Contract for more details

********************************************************************* **/ 

/********************************************************************************************************** 
NAME			:	CrossOrgCollaboration  
DESCRIPTION 	:	Class to aid Cross Org Collaboration                                                             
DATE			:	May 2020
AUTHOUR			:	Ravi Raj (Salesforce Snr Program Architect)

HISTORY         :
VERSION  	AUTHOR   	        DATE  		    DESCRIPTIOM    
1.0    		Ravi Raj  	        May 2020	    Initial Release
***********************************************************************************************************/
public class CrossOrgCollaboration 
{
    private final String strINT_USER_NAME = 'Chatter Bot';
    private final String strOPPORTUNITY = 'Opportunity';
    private final String strPROJECT = 'Project';
    private final String strGOLS = 'GOLS';
    private final String strONEFORCE= 'ONEFORCE';
    private final String strONEFORCE_NAMED_CREDENTIAL = 'OneForce_DevPro';
    
    public void updateFeed(List<SObject> lstFeedElements, Boolean blnComment, String strSourceOrg, String strEvent)
    {
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabsToUpdate = new List<Cross_Org_Collaboration__c>();

        try
        {
            //look up which feed element to update from [Cross_Org_Collaboration__c]
            lstCrossOrgCollabsToUpdate = getCrossOrgCollabsToUpdate(lstFeedElements);

            if (lstCrossOrgCollabsToUpdate.size() > 0)
            {
                //update DB values
                lstCrossOrgCollabsToUpdate = updateCrossOrgCollabs(lstCrossOrgCollabsToUpdate, lstFeedElements, blnComment, strEvent);

                if (lstCrossOrgCollabsToUpdate.size() > 0)
                {
                    Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();
                    for (Cross_Org_Collaboration__c objCrossOrgCollab : lstCrossOrgCollabsToUpdate)
                    {
                        mapCrossOrgCollabByFeedId.put(objCrossOrgCollab.Internal_FeedItem_ID__c, objCrossOrgCollab); 
                    }
 
                    String strPayload = marshallChatterMessages(lstCrossOrgCollabsToUpdate, strSourceOrg);
                    if (strPayload.startsWith('ERROR')) { throw new StringException('Error with payload');}
                    ID jobID = System.enqueueJob(new wsREST_REQ_CrossOrgCollaboration(strPayload, mapCrossOrgCollabByFeedId, strSourceOrg));
                } 
            }
        } 
        catch (Exception ex) 
        {
            //throw new NoDataFoundException(ex.getMessage(););
        }
    }
    /**********************************************************************************************************     
        Purpose		: Look up which feed element to update from [Cross_Org_Collaboration__c] table
        Parameters	: @param lstFeedElementsToUpdate    : List of Feed Elements to update
        Returns		: List<Cross_Org_Collaboration__c> 
    ***********************************************************************************************************/
    @TestVisible 
    private List<Cross_Org_Collaboration__c> getCrossOrgCollabsToUpdate(List<SObject> lstFeedElementsToUpdate)
    {
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabsToUpdate = new List<Cross_Org_Collaboration__c>();
        try 
        {
            //Extract all [id] and use this to match against [Internal_FeedItem_ID__c]
            Map<ID, SObject> mapFeedElementsToUpdate = new Map<ID, SObject>();
            //convert list to Map
            mapFeedElementsToUpdate.putAll(lstFeedElementsToUpdate);
            //get Keys from Map
            Set<Id> setKeysOfFeedElementsToUpdate = mapFeedElementsToUpdate.keySet();
            
            lstCrossOrgCollabsToUpdate = [SELECT 	 id
                                                    ,Event__c
                                                    ,Body__c
                                                    ,First_Name__c
                                                    ,Last_Name__c
                                                    ,Alias__c
                                                    ,Internal_FeedItem_ID__c
                                                    ,Internal_Record_ID__c
                                                    ,Internal_User_ID__c
                                                    ,Success__c
                                                    ,Sent__c
                                                    ,Sent_DTTM__c
                                                    ,Received__c
                                                    ,Received_DTTM__c
                                                    ,External_FeedItem_ID__c
                                                    ,External_Record_ID__c
                                                    ,External_User_ID__c
                                                    ,Error_Code__c
                                                    ,Error_Message__c
                                                    ,isComment__c
                                            FROM    Cross_Org_Collaboration__c
                                            WHERE   Internal_FeedItem_ID__c IN :setKeysOfFeedElementsToUpdate
                                            AND     Success__c = true];
        }
        catch (Exception ex) 
        {
            throw new QueryException(ex.getMessage());
        }  
        return lstCrossOrgCollabsToUpdate;
    }

    /**********************************************************************************************************     
        Purpose		: Updates [updateCrossOrgCollabs] records with new values
        Parameters	: @param lstCrossOrgCollabsToUpdate : List of Feed Elements to update
                      @param lstFeedElements            : List of Feed Elements to update
                      @param blnComment                 : Whether the FeedItems are Comments or not
                      @param strEvent                   : "NEW"; "EDIT"; "DELETE"
        Returns		: List<Cross_Org_Collaboration__c> 
    ***********************************************************************************************************/
    @TestVisible 
    private List<Cross_Org_Collaboration__c> updateCrossOrgCollabs(List<Cross_Org_Collaboration__c> lstCrossOrgCollabsToUpdate, List<SObject> lstFeedElements
                                                                  ,Boolean blnComment, String strEvent)
    {
        List<Cross_Org_Collaboration__c> lstRetCrossOrgCollabs = new List<Cross_Org_Collaboration__c>();
        Boolean blnFound;

        try 
        {
            String strField = blnComment ? 'CommentBody' : 'Body';

            //loop through list to update
            for (Cross_Org_Collaboration__c objCrossOrgCollab :lstCrossOrgCollabsToUpdate)
            {
                blnFound = false;
                String strBody = '';

                //loop the original Trigger list
                for (SObject sobj : lstFeedElements)
                {
                    if (objCrossOrgCollab.Internal_FeedItem_ID__c == sobj.id)
                    {

                        if (String.valueOf(sobj.get(strField)).startsWith('<p>') && String.valueOf(sobj.get(strField)).endsWith('/<p>'))
                        {
                            strBody = String.valueOf(sobj.get(strField)).substringBetween('<p>','</p>') + ' '; 
                        }
                        else
                        {
                            strBody = String.valueOf(sobj.get(strField)) + ' '; 
                        }
                        blnFound = true;
                        break;
                    }
                }

                if (blnFound)
                {
                    objCrossOrgCollab.Body__c = strBody; 
                    objCrossOrgCollab.Event__c = strEvent; 
                    objCrossOrgCollab.Sent__c = False;       
                    objCrossOrgCollab.Received__c = False;  
                    objCrossOrgCollab.Sent_DTTM__c = null;    
                    objCrossOrgCollab.Received_DTTM__c = null; 
                    objCrossOrgCollab.Success__c = false;   
                    lstRetCrossOrgCollabs.add(objCrossOrgCollab);
                }
            }
            update lstRetCrossOrgCollabs;
        }
        catch (Exception ex) 
        {
            throw new QueryException(ex.getMessage());
        }  
        return lstRetCrossOrgCollabs;
    }

    /**********************************************************************************************************   
        Purpose		: Processes a list of [FeedItems] and extracts a subset of these
        Parameters	: @param lstFeedElements :list of [FeedItems] from a Trigger   
                      @param blnComment	     : Whether *this* call is in relation to a Comment or not
                      @param strSourceOrg  	 : "GOLS" or "OneForce". Used as a switch between org Triggers
                      @param strEvent	     : "NEW"; "EDIT"; "DELETE"
        Returns		: void
    ***********************************************************************************************************/
    public void processFeed(List<SObject> lstFeedElements, Boolean blnComment, String strSourceOrg, String strEvent)
    {
        List<SObject> lstNewFeedElements = new List<SObject>();

        String strQuery = '';

        try 
        {
            //set which Object we need to extract from (either Opportunity or Projects)
            String strRelevantObject;
            If (strSourceOrg.equalsIgnoreCase(strGOLS))        
            {   
                strRelevantObject = strOPPORTUNITY; 
                //Set specifically for GOLS: only retrieve Opportunities that are not in America. This way, OneForce will want to know about these
                strQuery = 'SELECT Id, Region_Level_1__c FROM Opportunity WHERE Region_Level_1__c <> \'Americas\' AND id IN ';
            }
            else if (strSourceOrg.equalsIgnoreCase(strONEFORCE))    
            {
                 strRelevantObject = strPROJECT; 
            }
            else    
            { 
                //throw; 
            }

            If (blnComment) { lstNewFeedElements = getRelevantFeedComments(lstFeedElements, strRelevantObject); }
                else        { lstNewFeedElements = getRelevantFeedItems(lstFeedElements, strRelevantObject, strQuery); }
            
            if (!lstNewFeedElements.isEmpty())
            {
                Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();
                
                List<Cross_Org_Collaboration__c> lstCrossOrgCollab;
                
                If (blnComment) { lstCrossOrgCollab = saveCustomFeedComments(lstNewFeedElements, blnComment, strEvent, mapCrossOrgCollabByFeedId);}
                else            { lstCrossOrgCollab = saveCustomFeedItems(lstNewFeedElements, blnComment, strEvent, mapCrossOrgCollabByFeedId); }
                
                If (! lstCrossOrgCollab.isEmpty())
                { 
                    String strPayload = marshallChatterMessages(lstCrossOrgCollab, strSourceOrg);
                    ID jobID = System.enqueueJob(new wsREST_REQ_CrossOrgCollaboration(strPayload, mapCrossOrgCollabByFeedId, strSourceOrg));
                }
            } 
        } 
        catch (Exception ex) 
        {
            NoDataFoundException e = new NoDataFoundException();
            e.setMessage('>>>> ERROR! '  + ex) ;
            throw e;
        }
    } 

    /**********************************************************************************************************     
        Purpose		: Prepares and marshalls the List<Cross_Org_Collaboration__c> into an 
                      [msgREST_REQ_CrossOrgCollaboration] object message
        Parameters	: @param lstCrossOrgCollab    : List of [Cross_Org_Collaboration__c] 
                      @param strSourceOrg         : "GOLS" or "OneForce". Used as a switch between org Triggers
        Returns		: String payload (in JSON format)
    ***********************************************************************************************************/
    @TestVisible 
    private String marshallChatterMessages(List<Cross_Org_Collaboration__c> lstCrossOrgCollab, String strSourceOrg)
    {
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = new msgREST_REQ_CrossOrgCollaboration();
        List<msgREST_REQ_COMP_FeedItem> lstFeedItems= new List<msgREST_REQ_COMP_FeedItem> ();
        String strPayload = '';

        try 
        {
            //create messages
            for (Cross_Org_Collaboration__c objCrossOrgCollab : lstCrossOrgCollab)
            {
                msgREST_REQ_COMP_FeedItem msgFeedItem = new msgREST_REQ_COMP_FeedItem();
                msgFeedItem.body = objCrossOrgCollab.Body__c;
                msgFeedItem.internalUserId = objCrossOrgCollab.Internal_User_ID__c;
                msgFeedItem.firstName = objCrossOrgCollab.First_Name__c;
                msgFeedItem.lastName = objCrossOrgCollab.Last_Name__c ;
                msgFeedItem.alias = objCrossOrgCollab.Alias__c ;
                msgFeedItem.isComment = objCrossOrgCollab.isComment__c;
                msgFeedItem.internalFeedItemId = objCrossOrgCollab.Internal_FeedItem_ID__c;
                msgFeedItem.internalRecordId = objCrossOrgCollab.Internal_Record_ID__c;
                msgFeedItem.success = false;
                msgFeedItem.event = objCrossOrgCollab.Event__c;

                //filled in by destination system
                msgFeedItem.externalFeedItemId = objCrossOrgCollab.External_FeedItem_ID__c ;
                msgFeedItem.externalUserId = objCrossOrgCollab.External_User_ID__c ;
                msgFeedItem.externalRecordId = objCrossOrgCollab.External_Record_ID__c ;
                lstFeedItems.add(msgFeedItem);
            }
            msgCrossOrgCollab.FeedItems = lstFeedItems;
            msgCrossOrgCollab.SourceOrg = strSourceOrg;
            strPayload = JSON.serialize(msgCrossOrgCollab);
        }
        catch (Exception ex) 
        {
            strPayload = 'ERROR in marshallChatterMessages(): ' + strPayload;
            System.debug('############ ERROR at: [sendCustomComments()]' );
        }  
        return strPayload;
    }

    /**********************************************************************************************************     
        Purpose		: Given a List of FeedItems, save the details into [Cross_Org_Collaboration__c]
        Parameters	: @param lstFeedItemsNew            : list of [FeedItems] 
                      @param blnComment                 : Whether the FeedItems are Comments or not
                      @param strEvent                   : "NEW"; "EDIT"; "DELETE"
                      @param mapCrossOrgCollabByFeedId  : Map to hold the sObjects (Key = FeedID) so that they
                                                          can be update in the reponse
        Returns		: List<Cross_Org_Collaboration__c>
    ***********************************************************************************************************/
    @TestVisible 
    private List<Cross_Org_Collaboration__c> saveCustomFeedItems(List<SObject> lstFeedItems, Boolean blnComment, String strEvent
                                                                ,Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId)
    {
        //Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = new List<Cross_Org_Collaboration__c>();
        
        try 
        {
            //construct sObject(s)
            For (SObject sobjItem : lstFeedItems)
            {
                FeedItem objFeedItem = (FeedItem)sobjItem;
                Cross_Org_Collaboration__c objCrossOrgCollab = new Cross_Org_Collaboration__c();

                objCrossOrgCollab.Event__c = strEvent; 
                objCrossOrgCollab.Active__c = True; 
                objCrossOrgCollab.isComment__c = blnComment; 
                //add a space at the end to account for Rich Text formatting
                //objCrossOrgCollab.Body__c = objFeedItem.Body + ' ';  
                if (objFeedItem.Body.startsWith('<p>') && objFeedItem.Body.endsWith('/<p>'))
                {
                    objCrossOrgCollab.Body__c = objFeedItem.Body.substringBetween('<p>','</p>') + ' '; 
                }
                else
                {
                    objCrossOrgCollab.Body__c = objFeedItem.Body + ' '; 
                }

                /**
                 *  BUG -   for some reason, where getting these User values, they return null.
                 *          We need to make a separate call to the DB to get the values
                 */
                //objCrossOrgCollab.First_Name__c = objFeedItem.CreatedBy.FirstName;  
                //objCrossOrgCollab.Last_Name__c = objFeedItem.CreatedBy.LastName;  
                //objCrossOrgCollab.Alias__c = objFeedItem.CreatedBy.Alias; 

                string strFeedItemId = objFeedItem.Id;
                List<FeedItem> lstFeedItems1 = [SELECT CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Alias FROM FeedItem WHERE id =:strFeedItemId LIMIT 1];
    
                objCrossOrgCollab.First_Name__c = lstFeedItems1.get(0).CreatedBy.FirstName;  
                objCrossOrgCollab.Last_Name__c = lstFeedItems1.get(0).CreatedBy.LastName;  
                objCrossOrgCollab.Alias__c = lstFeedItems1.get(0).CreatedBy.Alias; 

                objCrossOrgCollab.Internal_Record_ID__c = objFeedItem.ParentId;  
                objCrossOrgCollab.Internal_FeedItem_ID__c = objFeedItem.Id;  
                objCrossOrgCollab.Internal_User_ID__c = objFeedItem.createdbyId; 
                objCrossOrgCollab.Sent__c = False;       
                objCrossOrgCollab.Received__c = False;                  
                lstCrossOrgCollab.add(objCrossOrgCollab);  
                //update the map
                mapCrossOrgCollabByFeedId.put(String.valueOf(objFeedItem.Id), objCrossOrgCollab);  
            } 
            //Commit sObject(s)
            If (! lstCrossOrgCollab.isEmpty())
            {
                insert lstCrossOrgCollab;
            }
        }
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [saveCustomFeedItems()]' );
        }  
        return lstCrossOrgCollab;
    }

    /**********************************************************************************************************     
        Purpose		: Given a List of FeedItems, save the details into [Cross_Org_Collaboration__c]
        Parameters	: @param lstFeedItemsNew            : list of [FeedItems] 
                      @param blnComment                 : Whether the FeedItems are Comments or not
                      @param strEvent                   : "NEW"; "EDIT"; "DELETE"
                      @param mapCrossOrgCollabByFeedId  : Map to hold the sObjects (Key = FeedID) so that they
                                                          can be update in the reponse
        Returns		: List<Cross_Org_Collaboration__c>
    ***********************************************************************************************************/
    @TestVisible 
    private List<Cross_Org_Collaboration__c> saveCustomFeedComments(List<SObject> lstFeedItems, Boolean blnComment, String strEvent
                                                                ,Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId)
    {
        //Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = new List<Cross_Org_Collaboration__c>();
        
        try 
        {
            //construct sObject(s)
            For (SObject sobjItem : lstFeedItems)
            {
                FeedComment objFeedItem = (FeedComment)sobjItem;
                Cross_Org_Collaboration__c objCrossOrgCollab = new Cross_Org_Collaboration__c();

                objCrossOrgCollab.Event__c = strEvent; 
                objCrossOrgCollab.Active__c = True; 
                objCrossOrgCollab.isComment__c = blnComment; 
                //add a space at the end to account for Rich Text formatting
                //objCrossOrgCollab.Body__c = objFeedItem.CommentBody  + ' ';  
                objCrossOrgCollab.Body__c = objFeedItem.CommentBody.substringBetween('<p>','</p>')  + ' '; 

                /**
                 *  BUG -   for some reason, when getting these User values, they return null.
                 *          We need to make a separate call to the DB to get the values
                 */
                //objCrossOrgCollab.First_Name__c = objFeedItem.CreatedBy.FirstName;  
                //objCrossOrgCollab.Last_Name__c = objFeedItem.CreatedBy.LastName;  
                //objCrossOrgCollab.Alias__c = objFeedItem.CreatedBy.Alias; 

                string strFeedItemId = objFeedItem.Id;
                List<FeedComment> lstFeedItems1 = [SELECT CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Alias FROM FeedComment WHERE id =:strFeedItemId LIMIT 1];
    
                objCrossOrgCollab.First_Name__c = lstFeedItems1.get(0).CreatedBy.FirstName;  
                objCrossOrgCollab.Last_Name__c = lstFeedItems1.get(0).CreatedBy.LastName;  
                objCrossOrgCollab.Alias__c = lstFeedItems1.get(0).CreatedBy.Alias; 

                objCrossOrgCollab.Internal_Record_ID__c = objFeedItem.FeedItemId;  
                objCrossOrgCollab.Internal_FeedItem_ID__c = objFeedItem.Id;  
                objCrossOrgCollab.Internal_User_ID__c = objFeedItem.createdbyId; 

                objCrossOrgCollab.Sent__c = False;       
                objCrossOrgCollab.Received__c = False;                  
                lstCrossOrgCollab.add(objCrossOrgCollab);  
                //update the map
                mapCrossOrgCollabByFeedId.put(String.valueOf(objFeedItem.Id), objCrossOrgCollab);  
            } 

            //Commit sObject(s)
            If (! lstCrossOrgCollab.isEmpty())
            {
                //construct list of string of [Internal_Record_ID__c]
                List<String> lstInClause = new List<String>();
                for (Cross_Org_Collaboration__c objCrossOrgCollab :lstCrossOrgCollab) { lstInClause.add(objCrossOrgCollab.Internal_Record_ID__c); }

                //the [External_Record_ID__c] is known at this point so store
                List<Cross_Org_Collaboration__c> lstCrossOrgCollabExtFeedItemId = [SELECT id, External_FeedItem_ID__c, Internal_FeedItem_ID__c
                                                                                    FROM    Cross_Org_Collaboration__c 
                                                                                    WHERE   Internal_FeedItem_ID__c IN :lstInClause];
                //loop the sObjects again
                for (Cross_Org_Collaboration__c objCrossOrgCollab :lstCrossOrgCollab)
                {
                    //loop the returned SOQL values
                    for (Cross_Org_Collaboration__c objCrossOrgCollabExtFeedItemId :lstCrossOrgCollabExtFeedItemId)
                    {
                        if(objCrossOrgCollab.Internal_Record_ID__c == objCrossOrgCollabExtFeedItemId.Internal_FeedItem_ID__c)
                        {
                            objCrossOrgCollab.External_Record_ID__c = objCrossOrgCollabExtFeedItemId.External_FeedItem_ID__c;
                        }
                    }
                }
                insert lstCrossOrgCollab;
            }
        }
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [saveCustomFeedItems()]' );
        }  
        return lstCrossOrgCollab;
    }

    /**********************************************************************************************************     
        Purpose		: Given a set of FeedItems, elimiate Feed Items that:
                        (i)   don't match the relevant object and 
                        (ii)  is not created by the Integration User 
                        (iii) [optional] if [strQuery] is present, retrieve data from DB and compare values against it
        Parameters	: @param lstFeedItemsNew    : list of [FeedItems] to process
                      @param strRelevantObject  : Relevant object
                      @param strQuery           : Dynamic query to execute to retrieve DB values
        Returns		: List<FeedItem> which contains a subset of the Feed Items that were passed in
    ***********************************************************************************************************/
    @TestVisible 
    private List<SObject> getRelevantFeedItems(List<SObject> lstFeedItems, String strRelevantObject, String strQuery)
    {
        List<FeedItem> lstNewFeedItems = new List<FeedItem>();
        List<String> lstInternalRecordIds = new List<String>();

        try 
        {
            //loop incoming Feed Item List
            for(SObject sobjItem: lstFeedItems)
            {
                FeedItem objItem = (FeedItem)sobjItem;

                //skip if FeedItem is not attached to the relevant object (Opportunities or Projects)
                if (! objItem.ParentId.getSObjectType().getDescribe().getName().equalsIgnoreCase(strRelevantObject)) { continue; }

                //skip if user is the Integration user (to avoid recursion)
                if (objItem.InsertedBy.name == strINT_USER_NAME) { continue; }

                //store to a new subset list
                lstNewFeedItems.add(objItem);
               
                //store the parent Id to retrieve later on
                lstInternalRecordIds.add(objItem.ParentId);
            }
           
            if ((lstInternalRecordIds.size() != 0) && (strQuery != ''))
            {
                //construct string similar to: "('qwerty', 'qwerty', 'qwerty')"
                String strList = '(';
                for (String arg :lstInternalRecordIds) { strList = strList + '\'' + arg + '\','; }
                strList = strList.removeEnd(',') + ')';

                //Get Regions
                List<SObject> sobjRet = Database.query(strQuery + strList);
                List<FeedItem> lstNewFeedItems2 = new List<FeedItem>();
    
                //loop the return SOQL
                for(SObject sObj: sobjRet)
                {
                    //loop the feed Items again
                    for(Object sobjItem: lstFeedItems)
                    {
                        FeedItem objItem = (FeedItem)sobjItem;
                        if ( sObj.id == objItem.ParentId)
                        {
                            //ID matches Feed Item's parent ID, so we need to send
                            lstNewFeedItems2.add(objItem);
                        }
                    }
                }
                lstNewFeedItems = lstNewFeedItems2;
            }
        } 
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [getRelevantFeedItems] ' + ex);
        }  
        return lstNewFeedItems;       
    }


    /**********************************************************************************************************     
        Purpose		: Given a set of Feed Comments, elimiate Feed Items that:
                        (i)   don't match the relevant object and 
                        (ii)  is not created by the Integration User 
                        (iii) [optional] if [strQuery] is present, retrieve data from DB and compare values against it
        Parameters	: @param lstFeedComments    : list of [FeedItems] to process
                      @param strRelevantObject  : Relevant object
        Returns		: List<FeedItem> which contains a subset of the Feed Items that were passed in
    ***********************************************************************************************************/
    @TestVisible 
    private List<SObject> getRelevantFeedComments(List<SObject> lstFeedItems, String strRelevantObject)
    {
        List<FeedComment> lstNewFeedItems = new List<FeedComment>();

        List<FeedComment> lstSubFeedComments = new List<FeedComment>();

        List<String> lstInternalRecordIds = new List<String>();

        try 
        {
            //loop incoming Feed Item List
            for(SObject sobjItem: lstFeedItems)
            {
                FeedComment objItem = (FeedComment)sobjItem;

                //skip if user is the Integration user (to avoid recursion)
                if (objItem.InsertedBy.name == strINT_USER_NAME) { continue; }
               
                //store the Comment to retrieve later on
                lstSubFeedComments.add(objItem);
            }
           
            if (lstSubFeedComments.size() != 0)
            {
                //construct list of string of [FeedItemId]
                List<String> lstInClause = new List<String>();

                for (FeedComment objFeedComment :lstSubFeedComments) { lstInClause.add(objFeedComment.FeedItemId ); }

                //Examin the [Cross_Org_Collaboration__c] table - only need to send if the parent has already been sent
                List<Cross_Org_Collaboration__c> lstParentFeedItemCrossOrgCollab = [SELECT   id
                                                                                            ,Event__c
                                                                                            ,Body__c
                                                                                            ,First_Name__c
                                                                                            ,Last_Name__c
                                                                                            ,Internal_FeedItem_ID__c
                                                                                            ,Internal_Record_ID__c
                                                                                            ,Internal_User_ID__c
                                                                                            ,Success__c
                                                                                            ,Sent__c
                                                                                            ,Sent_DTTM__c
                                                                                            ,Received__c
                                                                                            ,Received_DTTM__c
                                                                                            ,External_FeedItem_ID__c
                                                                                            ,External_Record_ID__c
                                                                                            ,External_User_ID__c
                                                                                            ,Error_Code__c
                                                                                            ,Error_Message__c 
                                                                                        FROM Cross_Org_Collaboration__c
                                                                                        WHERE Internal_FeedItem_ID__c IN :lstInClause];
                
                List<FeedComment> lstNewFeedItems2 = new List<FeedComment>();

                //loop the feed Items again
                for (FeedComment objFeedComment :lstSubFeedComments)
                {
                    for(Cross_Org_Collaboration__c objCrossOrgCollab : lstParentFeedItemCrossOrgCollab)
                    {
                        if ( objFeedComment.FeedItemId == objCrossOrgCollab.Internal_FeedItem_ID__c)
                        {
                            //ID matches Feed Item's parent ID, so we need to send
                            lstNewFeedItems2.add(objFeedComment);
                        }
                    }
                }
                lstNewFeedItems = lstNewFeedItems2;
            }
        } 
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [getRelevantFeedItems] ' + ex);
        }  
        return lstNewFeedItems;       
    }
}