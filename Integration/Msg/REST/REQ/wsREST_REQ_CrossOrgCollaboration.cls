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
    //https://rajvakati.com/2018/03/08/queueable-apex-callouts/

    private List<msgREST_REQ_CrossOrgCollaboration> lstCrossOrgCollab; 
    private String strNamedCredentials;

    private final String strHTTP_POST = 'POST';
    private final String strREQUEST_TYPE = 'batchRequests';
    private final String strURL = 'v48.0/sobjects/FeedItem';
    private final String strURI_RESOURCE = '/services/data/v48.0/composite/batch';
    private final String strCONTENT_TYPE = 'Content-Type';
    private final String strAPPLICATION_TYPE = 'application/json';
    private HTTPResponse res = null;
    private final String strBATCH = 'batchRequests';
    private final String strFEED_ITEM = 'FeedItem';
    private string strRet = '';

    //Constructor
    public wsREST_REQ_CrossOrgCollaboration(String strPayload, String strSourceOrg )
    {
        this.lstCrossOrgCollab = lstCrossOrgCollab;
        this.strNamedCredentials = strNamedCredentials;
    }

    public void execute(QueueableContext qc)
    {
        REST_REQ_Utils msg = new REST_REQ_Utils();
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String strEndPoint = 'callout:' + strNamedCredentials + strURI_RESOURCE;
        //List<msgREST_REQ_CrossOrgCollaboration> lstCrossOrgCollabRes = new List<msgREST_REQ_CrossOrgCollaboration>(); 

        try 
        {
            //get JSON string
            //Even if there is only 1 x FeedItem to send, send it in a batch (to make more generic)
            String strRet = msg.getJSON(strREQUEST_TYPE, lstCrossOrgCollab, strHTTP_POST, strURL);
            
            req.setEndpoint(strEndPoint);
            req.setMethod(strHTTP_POST);  
            req.setHeader(strCONTENT_TYPE, strAPPLICATION_TYPE); 
            req.setBody(strRet);

            //Before we send, update the Send values
            for (msgREST_REQ_CrossOrgCollaboration objCrossOrgCollab : lstCrossOrgCollab) 
            {
                objCrossOrgCollab.Sent__c = true;
                objCrossOrgCollab.Sent_DTTM__c = datetime.now();
            }

            res = http.send(req); 
             
            if(res.getStatusCode() == 200)
            {
                //successful call. Now examine responses
                List<Object> lstRetObj = msg.getJSONResponse(res.getBody());

                Integer intCount = 0;
                for (Object objRes : lstRetObj) 
                {
                    lstCrossOrgCollab.get(intCount).Received__c = true;
                    lstCrossOrgCollab.get(intCount).Received_DTTM__c = datetime.now();

                    switch on Utils.getObjectName(objRes) 
                    {
                        when 'msgREST_RES_COMP_Detail' 
                        {
                            msgREST_RES_COMP_Detail obDetail = (msgREST_RES_COMP_Detail) objRes;
                            lstCrossOrgCollab.get(intCount).Success__c = true;
                            lstCrossOrgCollab.get(intCount).OneForce_FeedItem_Id__c = obDetail.id;
                        }
                        when 'msgREST_RES_COMP_Error' 
                        {
                            msgREST_RES_COMP_Error objError = (msgREST_RES_COMP_Error) objRes;
                            lstCrossOrgCollab.get(intCount).Success__c = false;
                            lstCrossOrgCollab.get(intCount).Error_Code__c = objError.errorCode;
                            lstCrossOrgCollab.get(intCount).Error_Message__c = objError.message;
                        }
                        when else {}
                    }
                    intCount++;
                }
            }
            else
            {
                CalloutException e = new CalloutException();
                e.setMessage('>>>> ERROR! ' + res.toString() + ' | ' + strEndPoint + ' | ' + strRet);
                throw e;
            }            
        } 
        catch (Exception ex) 
        {
            throw ex;
        }
        update lstCrossOrgCollab;
    }
}
