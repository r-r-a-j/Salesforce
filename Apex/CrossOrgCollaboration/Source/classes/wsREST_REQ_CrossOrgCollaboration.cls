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
NAME			:	IntCrossOrgCollaboration  
DESCRIPTION 	:	Class to send FeedItems/msgREST_REQ_CrossOrgCollaboration message to external systems
DATE			:	May 2020
AUTHOUR			:	Ravi Raj (Salesforce Snr Program Architect)

HISTORY         :
VERSION  	AUTHOR   	        DATE  		    DESCRIPTIOM    
1.0    		Ravi Raj  	        May 2020	    Initial Release
***********************************************************************************************************/
public class wsREST_REQ_CrossOrgCollaboration implements Queueable,Database.AllowsCallouts
{
    private final String strURI_RESOURCE = '/services/apexrest/CrossOrgCollaboration';
    private final String strCONTENT_TYPE = 'Content-Type';
    private final String strAPPLICATION_TYPE = 'application/json';
    private final String strHTTP_POST = 'POST';
    private final String strGOLS = 'GOLS';
    private final String strONEFORCE= 'ONEFORCE';
    private HTTPResponse res = null;
    private string strPayload = '';
    private String strSourceOrg = '';
    private String strNamedCredentials = '';
    private Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId;

    /**********************************************************************************************************   
        Purpose		: Constructor. Prepares the WS calls
        Parameters	: @param strPayload                 : The JSON payload to send
                      @param mapCrossOrgCollabByFeedId  : Map to hold the sObjects (Key = Internal FeedID) so that they
                                                          can be update in the reponse
                      @param strSourceOrg  	            : "GOLS" or "OneForce". Used as a switch between org Triggers
        Returns		: void
    ***********************************************************************************************************/
    public wsREST_REQ_CrossOrgCollaboration(String strPayload, Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId, String strSourceOrg)
    {
        this.strPayload = strPayload;
        this.mapCrossOrgCollabByFeedId = mapCrossOrgCollabByFeedId;
        this.strSourceOrg = strSourceOrg;
        //set which Named Credentials to use
        if      (strSourceOrg.equalsIgnoreCase(strGOLS))        { strNamedCredentials = 'OneForce'; }
        else if (strSourceOrg.equalsIgnoreCase(strONEFORCE))    { strNamedCredentials = 'GOLS';     }
        else    { /*throw;*/  }
        log(this.strPayload);
    }

    public void execute(QueueableContext qc)
    {
        REST_REQ_Utils msg = new REST_REQ_Utils();
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabToUpdate = new List<Cross_Org_Collaboration__c>();

        String strEndPoint = 'callout:' + strNamedCredentials + strURI_RESOURCE;

        try 
        {         
            req.setEndpoint(strEndPoint);
            req.setMethod(strHTTP_POST);  
            req.setHeader(strCONTENT_TYPE, strAPPLICATION_TYPE); 
            req.setBody(strPayload);

            //capture DateTime of send. Only update the DB on the way back to perseve DML calls
            Datetime  dttmDateTimeSent = datetime.now();

            res = http.send(req); 

            if(res.getStatusCode() == 200)
            {
                //successful call. Now examine responses
                //get Request body & unmarshal
              //String body = System.RestContext.request.requestBody.toString();
                //msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = (msgREST_REQ_CrossOrgCollaboration)JSON.deserialize(body, msgREST_REQ_CrossOrgCollaboration.class); 
                msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = (msgREST_REQ_CrossOrgCollaboration)JSON.deserialize(res.getBody(), msgREST_REQ_CrossOrgCollaboration.class); 

                //log('305');
                //loop through return list
                for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems)
                {
                    //log('306');
                    //get the physical object from the map
                    Cross_Org_Collaboration__c objCrossOrgCollabByFeedId = mapCrossOrgCollabByFeedId.get(msgFeedItem.internalFeedItemId);
                    if (objCrossOrgCollabByFeedId == null) { continue; }    

                    //update Sent values
                    objCrossOrgCollabByFeedId.Sent__c = true;
                    objCrossOrgCollabByFeedId.Sent_DTTM__c = dttmDateTimeSent;

                    //update received values
                    objCrossOrgCollabByFeedId.Received__c = true;
                    objCrossOrgCollabByFeedId.Received_DTTM__c = datetime.now();

                    //update success and any error values
                    objCrossOrgCollabByFeedId.Success__c = msgFeedItem.success;
                    objCrossOrgCollabByFeedId.Error_Code__c = msgFeedItem.errorCode;
                    objCrossOrgCollabByFeedId.Error_Message__c = msgFeedItem.errorMessage;
                    objCrossOrgCollabByFeedId.Error_Fields__c = String.ValueOf(msgFeedItem.errorFields);

                    //update destination's values
                    objCrossOrgCollabByFeedId.External_FeedItem_ID__c = msgFeedItem.externalFeedItemId;
                    objCrossOrgCollabByFeedId.External_Record_ID__c = msgFeedItem.externalRecordId;
                    objCrossOrgCollabByFeedId.External_User_ID__c = msgFeedItem.externalUserId;

                    lstCrossOrgCollabToUpdate.add(objCrossOrgCollabByFeedId);
                }
            }
            else
            {
                CalloutException e = new CalloutException();
                e.setMessage('>>>> ERROR! ' + res.toString() + ' | ' + strEndPoint );
                throw e;
            }           
        } 
        catch (Exception ex) 
        {
            throw ex;
        }
        update lstCrossOrgCollabToUpdate;
    }

    public void log(String strNum)
    {
        Cross_Org_Collaboration__c objCrossOrgCollab = new Cross_Org_Collaboration__c();
        objCrossOrgCollab.Body__c = strNum;  
        objCrossOrgCollab.Internal_FeedItem_Id__c = 'strNum';  
        //insert objCrossOrgCollab;  
    }
}