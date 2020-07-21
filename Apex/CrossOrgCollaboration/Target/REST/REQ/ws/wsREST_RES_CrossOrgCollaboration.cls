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
NAME			:	wsREST_CrossCollaboration  
DESCRIPTION 	:	A REST web service for cross org collaboration
DATE			:	June 2020
AUTHOUR			:	Ravi Raj (Salesforce Snr Program Architect)

HISTORY         :
VERSION  	AUTHOR   	        DATE  		    DESCRIPTIOM    
1.0    		Ravi Raj  	        June 2020	    Initial Release
***********************************************************************************************************/
@RestResource(urlMapping='/CrossOrgCollaboration/*')
global class wsREST_RES_CrossOrgCollaboration 
{
    @HttpPost
    global static msgREST_REQ_CrossOrgCollaboration addFeedItem()
    {
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab;
        String strPostFix = '@XOrgCollab.com';
        String strChatterFreeProfile = '';
        Map<String, User> mapUsersKeyByName  = new Map<String, User>();

        try 
        {
            //get Request body & unmarshal
            String body = System.RestContext.request.requestBody.toString();
            msgCrossOrgCollab = (msgREST_REQ_CrossOrgCollaboration)JSON.deserialize(body,msgREST_REQ_CrossOrgCollaboration.class); 

            //begin by getting all active Users 
            Map<String, User> mapUsersKeyByUsername = REST_RES_Utils.getUserMap(mapUsersKeyByName, strPostFix);

            //get the event type. Check the first one - the rest will be the same
            if (msgCrossOrgCollab.FeedItems.get(0).event == 'EDIT') 
            { 
                return updateFeed(msgCrossOrgCollab, mapUsersKeyByName); 
            }

            //get the Chatter Free Profile ID
            strChatterFreeProfile = REST_RES_Utils.getChatterFreeProfileId(mapUsersKeyByUsername, strPostFix);
            
            //set the User either by fetching or creating
            String strRet = REST_RES_Utils.setFeedUsers(msgCrossOrgCollab, strPostFix, strChatterFreeProfile, mapUsersKeyByUsername);
            If (strRet.startsWith('Error')) {throw new NoDataFoundException();}

            //Now save the FeedItems/FeedComments
            msgCrossOrgCollab = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

            //check for @mentions
            for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
            {
                //only update @mentions if the FeedItem/FeedComment has already been successfully inserted - continue to next iteration otherwise
                if (!msgFeedItem.success) { continue; }

                //get @mentions for the given feed body
                List<String> lstMentions = REST_RES_Utils.getUserNameMentions(msgFeedItem.body, mapUsersKeyByName);

                //if no @mentions (that match concreate Users) present in body, continue to next iteration 
                if (lstMentions.size() == 0 ) { continue; }

                //the feed body does have @mentions, so split the the @mentions by the value concrete Users
                List<String> lstPieces = REST_RES_Utils.splitByMentions(lstMentions, msgFeedItem.body);

                //if no @mentions present in body, continue to next iteration 
                if (lstPieces.size() == 0) { continue; }
    
                msgFeedItem = REST_RES_Utils.updateFeed(lstMentions, msgFeedItem, lstPieces, mapUsersKeyByName);      
            }
            //RestContext.response.statusCode = 200;
        } 
        catch (Exception ex) 
        {
            RestContext.response.statusCode = 404;
            //ex.getMessage();
        }
        return msgCrossOrgCollab;
    }

    public static msgREST_REQ_CrossOrgCollaboration updateFeed(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab, Map<String, User> mapUsersKeyByName)
    {
        try 
        {
            //check for @mentions
            for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
            {
                
                if (msgFeedItem.event != 'EDIT') { continue; }
               
                //get @mentions for the given feed body
                List<String> lstMentions = REST_RES_Utils.getUserNameMentions(msgFeedItem.body, mapUsersKeyByName);
                
                //if no @mentions (that match concreate Users) present in body, continue to next iteration 
                if (lstMentions.size() == 0 ) 
                { 
                   
                    //No @mentions so update the vanilla feed
                    msgFeedItem = REST_RES_Utils.updateFeed(msgFeedItem);
                    continue; 
                }
                
                //the feed body does have @mentions, so split the the @mentions by the value concrete Users
                List<String> lstPieces = REST_RES_Utils.splitByMentions(lstMentions, msgFeedItem.body);
                
                //if no @mentions present in body, continue to next iteration 
                if (lstPieces.size() == 0) { continue; }
               
                msgFeedItem = REST_RES_Utils.updateFeed(lstMentions, msgFeedItem, lstPieces, mapUsersKeyByName);  
            }
        } 
        catch (Exception ex) 
        {

        }
        return msgCrossOrgCollab;
    }

    /*
    //WORKING VERSION LAST DAY
    @HttpPost
    global static msgREST_REQ_CrossOrgCollaboration addFeedItem()
    {
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab;
        String strPostFix = '@XOrgCollab.com';
        String strChatterFreeProfile = '';
        Map<String, User> mapUsersKeyByName  = new Map<String, User>();

        try 
        {
            //get Request body & unmarshal
            String body = System.RestContext.request.requestBody.toString();
            msgCrossOrgCollab = (msgREST_REQ_CrossOrgCollaboration)JSON.deserialize(body,msgREST_REQ_CrossOrgCollaboration.class); 
            
            //begin by getting all active Users 
            Map<String, User> mapUsersKeyByUsername = REST_RES_Utils.getUserMap(mapUsersKeyByName, strPostFix);

            //get the Chatter Free Profile ID
            strChatterFreeProfile = REST_RES_Utils.getChatterFreeProfileId(mapUsersKeyByUsername, strPostFix);
            
            //set the User either by fetching or creating
            String strRet = REST_RES_Utils.setFeedUsers(msgCrossOrgCollab, strPostFix, strChatterFreeProfile, mapUsersKeyByUsername);
            If (strRet.startsWith('Error')) {throw new NoDataFoundException();}

            //Now save the FeedItems/FeedComments
            msgCrossOrgCollab = REST_RES_Utils.(msgCrossOrgCollab);

            //check for @mentions
            for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
            {
                //only update @mentions if the FeedItem/FeedComment has already been successfully inserted - continue to next iteration otherwise
                if (!msgFeedItem.success) { continue; }
                
                //get @mentions for the given feed body
                List<String> lstMentions = REST_RES_Utils.getUserNameMentions(msgFeedItem.body, mapUsersKeyByName);

                //if no @mentions (that match concreate Users) present in body, continue to next iteration 
                if (lstMentions.size() == 0) { continue; }
               
                //the feed body does have @mentions, so split the the @mentions by the value concrete Users
                List<String> lstPieces = REST_RES_Utils.splitByMentions(lstMentions, msgFeedItem.body);
                
                //if no @mentions present in body, continue to next iteration 
                if (lstPieces.size() == 0) { continue; }
               
                msgFeedItem = REST_RES_Utils.updateFeed(lstMentions, msgFeedItem, lstPieces, mapUsersKeyByName);       
            }
            //RestContext.response.statusCode = 200;
        } 
        catch (Exception ex) 
        {
            RestContext.response.statusCode = 404;
            //ex.getMessage();
        }
        return msgCrossOrgCollab;
    }
    */
}
