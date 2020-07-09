@isTest 
public with sharing class REST_REQ_Utils_Test
{ 
    @TestSetup
    static void setup()
    { 
        //set up [Cross_Org_Collaboration__c]
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = new List<Cross_Org_Collaboration__c>();

        for(Integer x = 0; x < 10; x++)
        {
            Cross_Org_Collaboration__c objCrossOrgCollab = new Cross_Org_Collaboration__c();
            objCrossOrgCollab.Body__c = 'Test Comment ' + x;  
            objCrossOrgCollab.Active__c = True;  
            objCrossOrgCollab.First_Name__c = 'Oswald';  
            objCrossOrgCollab.Last_Name__c = 'Cobblepot';  
            //objCrossOrgCollab.OneForce_Project_Id__c = '123456789';  
            //objCrossOrgCollab.Opportunity_Id__c = 'a066E000006Ijt9QAC' + x;  
            objCrossOrgCollab.Sent__c = False;       
            objCrossOrgCollab.Received__c = False;  
            lstCrossOrgCollab.add(objCrossOrgCollab);
        }
        insert lstCrossOrgCollab;  
    }

    /**********************************************************************************************************   
    Method to Test  : public List<Object> getJSONResponse(String jsonStr, String strType)
    Description     : Given 1 x successful result from an REST API call in a list, return a corresponding List<Object>
    Expected Output : List<Object> containing 1 x [msgREST_RES_COMP_Detail] object
    ***********************************************************************************************************/
    @isTest 
    static void getJSONResponse_BatchRequests_Test1() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        String jsonStr = '{"hasErrors": false,"results": [{"statusCode": 201,"result": {"id": "0D56E00000LHjvVSAT","success": true,"errors": []}}]}';
        List<Object> lstRetObj = msg.getJSONResponse(jsonStr);

        System.assertEquals(1, lstRetObj.size());
        System.assertEquals('msgREST_RES_COMP_Detail', Utils.getObjectName(lstRetObj[0]));

        msgREST_RES_COMP_Detail objDetail = (msgREST_RES_COMP_Detail) lstRetObj[0];
        System.assertEquals('0D56E00000LHjvVSAT', objDetail.id);
        System.assertEquals(true, objDetail.success);
    }

    /**********************************************************************************************************   
    Method to Test  : public List<Object> getJSONResponse(String jsonStr, String strType)
    Description     : Given 2 x successful result from an REST API call in a list, return a corresponding List<Object>
    Expected Output : List<Object> containing 2 x [msgREST_RES_COMP_Detail] objects
    ***********************************************************************************************************/
    @isTest 
    static void getJSONResponse_BatchRequests_Test2() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        String jsonStr = '{"hasErrors": false,"results": [{"statusCode": 201,"result": {"id": "0D56E00000LHkTwSAL","success": true,"errors": []}},{"statusCode": 201,"result": {"id": "0D56E00000LHjvVSAT","success": true,"errors": []}}]}';
        List<Object> lstRetObj = msg.getJSONResponse(jsonStr);

        System.assertEquals(2, lstRetObj.size());
        System.assertEquals('msgREST_RES_COMP_Detail', Utils.getObjectName(lstRetObj[0]));
        System.assertEquals('msgREST_RES_COMP_Detail', Utils.getObjectName(lstRetObj[1]));

        msgREST_RES_COMP_Detail objDetail1 = (msgREST_RES_COMP_Detail) lstRetObj[0];
        System.assertEquals('0D56E00000LHkTwSAL', objDetail1.id);
        System.assertEquals(true, objDetail1.success);

        msgREST_RES_COMP_Detail objDetail2 = (msgREST_RES_COMP_Detail) lstRetObj[1];
        System.assertEquals('0D56E00000LHjvVSAT', objDetail2.id);
        System.assertEquals(true, objDetail2.success);        
    }
    /**********************************************************************************************************   
    Method to Test  : public List<Object> getJSONResponse(String jsonStr, String strType)
    Description     : Given 1 x unsuccessful result from an REST API call in a list, return a corresponding List<Object>
    Expected Output : List<Object> containing 1 x [msgREST_RES_COMP_Error] object
    ***********************************************************************************************************/
    @isTest 
    static void getJSONResponse_BatchRequests_Test3() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        String jsonStr = '{"hasErrors": true,"results": [{"result": [{"errorCode": "INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST","message": "Feed Item Type: bad value for restricted picklist field: Post"}],"statusCode": 400}]}';
        List<Object> lstRetObj = msg.getJSONResponse(jsonStr);

        System.assertEquals(1, lstRetObj.size());
        System.assertEquals('msgREST_RES_COMP_Error', Utils.getObjectName(lstRetObj[0]));

        msgREST_RES_COMP_Error objDetail1 = (msgREST_RES_COMP_Error) lstRetObj[0];
        System.assertEquals('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST', objDetail1.errorCode);
        System.assertEquals('Feed Item Type: bad value for restricted picklist field: Post', objDetail1.message);     
    }

    /**********************************************************************************************************   
    Method to Test  : public List<Object> getJSONResponse(String jsonStr, String strType)
    Description     : Given 2 x unsuccessful result from an REST API call in a list, return a corresponding List<Object>
    Expected Output : List<Object> containing 2 x [msgREST_RES_COMP_Error] objects
    ***********************************************************************************************************/    
    @isTest 
    static void getJSONResponse_BatchRequests_Test4() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        String jsonStr = '{"hasErrors": true,"results": [{"result": [{"errorCode": "INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST","message": "Feed Item Type: bad value for restricted picklist field: Post"}],"statusCode": 400},{"result": [{"errorCode": "NULL_POINTER_EXCEPTION","message": "Generic Error Message"}],"statusCode": 400}]}';
        List<Object> lstRetObj = msg.getJSONResponse(jsonStr);

        System.assertEquals(2, lstRetObj.size());
        System.assertEquals('msgREST_RES_COMP_Error', Utils.getObjectName(lstRetObj[0]));
        System.assertEquals('msgREST_RES_COMP_Error', Utils.getObjectName(lstRetObj[1]));

        msgREST_RES_COMP_Error objDetail1 = (msgREST_RES_COMP_Error) lstRetObj[0];
        System.assertEquals('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST', objDetail1.errorCode);
        System.assertEquals('Feed Item Type: bad value for restricted picklist field: Post', objDetail1.message);     

        msgREST_RES_COMP_Error objDetail2 = (msgREST_RES_COMP_Error) lstRetObj[1];
        System.assertEquals('NULL_POINTER_EXCEPTION', objDetail2.errorCode);
        System.assertEquals('Generic Error Message', objDetail2.message);            
    }

    /**********************************************************************************************************   
    Method to Test  : public List<Object> getJSONResponse(String jsonStr, String strType)
    Description     : Given 1 x successful & 1 x unseccessful result from an REST API call in a list, 
                      return a corresponding List<Object>
    Expected Output : List<Object> containing : 1 x [msgREST_RES_COMP_Detail] object &
                                                1 x [msgREST_RES_COMP_Error] object
    ***********************************************************************************************************/    
    @isTest 
    static void getJSONResponse_BatchRequests_Test5() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        String jsonStr = '{"hasErrors": false,"results": [{"result": [{"errorCode": "INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST","message": "Feed Item Type: bad value for restricted picklist field: Post"}],"statusCode": 400},{"statusCode": 201,"result": {"id": "0D56E00000LHkTwSAL","success": true,"errors": []}}]}';
        List<Object> lstRetObj = msg.getJSONResponse(jsonStr);

        System.assertEquals(2, lstRetObj.size());
        System.assertEquals('msgREST_RES_COMP_Error', Utils.getObjectName(lstRetObj[0]));
        System.assertEquals('msgREST_RES_COMP_Detail', Utils.getObjectName(lstRetObj[1]));

        msgREST_RES_COMP_Error objDetail1 = (msgREST_RES_COMP_Error) lstRetObj[0];
        System.assertEquals('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST', objDetail1.errorCode);
        System.assertEquals('Feed Item Type: bad value for restricted picklist field: Post', objDetail1.message);     

        msgREST_RES_COMP_Detail objDetail2 = (msgREST_RES_COMP_Detail) lstRetObj[1];
        System.assertEquals('0D56E00000LHkTwSAL', objDetail2.id);
        System.assertEquals(true, objDetail2.success);       
    }

    /**********************************************************************************************************   
    Method to Test  : void saveCustomFeedItems(Map<Opportunity, List<FeedItem>> mapOpptyFeedItem)
    Description     : Given 1 x [Cross_Org_Collaboration__c] in a list, return valid JSON REST message.
    Expected Output : 
    ***********************************************************************************************************/
 /*   @isTest 
    static void getJSON_BatchRequests_Test1() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = [SELECT Id, Body__c, Opportunity_Id__c FROM Cross_Org_Collaboration__c LIMIT 1];
        
        //call testing method
        String strRet = msg.getJSON('batchRequests', lstCrossOrgCollab, 'POST', 'v48.0/sobjects/FeedItem');

        //unmarshal and assert
        BatchRequest objBatchRequest = (BatchRequest)JSON.deserialize(strRet, BatchRequest.class);

        if (objBatchRequest == null)
        {
            //force throwing an error
            System.assertEquals('', 'objBatchRequest == null');
        }
        else 
        {
            System.assertEquals(objBatchRequest.batchRequests.size(), 1);

            Integer intCount = 0;

            for (GenericRequest objGenReq : objBatchRequest.batchRequests) 
            {
                System.assertEquals(objGenReq.method, 'POST');
                System.assertEquals(objGenReq.url, 'v48.0/sobjects/FeedItem');
                System.assertEquals(objGenReq.richInput.Body, 'Test Comment ' + intCount);
                System.assertEquals(objGenReq.richInput.ParentId, 'a066E000006Ijt9QAC' + intCount);
                intCount++;
            }
        }
    }
*/
    /**********************************************************************************************************   
    Method to Test  : void saveCustomFeedItems(Map<Opportunity, List<FeedItem>> mapOpptyFeedItem)
    Description     : Given 10 x [Cross_Org_Collaboration__c] in a list, return valid JSON REST message.
    Expected Output : 
    ***********************************************************************************************************/
 /*   @isTest 
    static void getJSON_BatchRequests_Test2() 	
	{
        //set up
        REST_REQ_Utils msg = new REST_REQ_Utils();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = [SELECT Id, Body__c, Opportunity_Id__c FROM Cross_Org_Collaboration__c LIMIT 10];
        
        //call testing method
        String strRet = msg.getJSON('batchRequests', lstCrossOrgCollab, 'POST', 'v48.0/sobjects/FeedItem');

        //unmarshal and assert
        BatchRequest objBatchRequest = (BatchRequest)JSON.deserialize(strRet, BatchRequest.class);

        if (objBatchRequest == null)
        {
            //force throwing an error
            System.assertEquals('', 'objBatchRequest == null');
        }
        else 
        {
            System.assertEquals(objBatchRequest.batchRequests.size(), 10);

            Integer intCount = 0;

            for (GenericRequest objGenReq : objBatchRequest.batchRequests) 
            {
                System.assertEquals(objGenReq.method, 'POST');
                System.assertEquals(objGenReq.url, 'v48.0/sobjects/FeedItem');
                System.assertEquals(objGenReq.richInput.Body, 'Test Comment ' + intCount);
                System.assertEquals(objGenReq.richInput.ParentId, 'a066E000006Ijt9QAC' + intCount);
                intCount++;
            }
        }
    }*/
} 
