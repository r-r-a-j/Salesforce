/**********************************************************************************************************  
NAME			:	CrossOrgCollaborationTest 
DESCRIPTION 	:	CrossOrgCollaboration Test Class
DATE			:	May 2020
AUTHOUR			:	Ravi Raj, Salesforce Snr Program Architect

HISTORY

VERSION  	AUTHOR   	DATE  		DESCRIPTIOM    
1.0    		Ravi Raj  	May 2020	Initial Release
***********************************************************************************************************/
@isTest 
public class CrossOrgCollaborationTest 
{ 
    @TestSetup
    static void setup()
    { 
        //set up Account
        List<Account> lstAccount = new List<Account>();
        for(Integer x = 0; x < 10; x++)
        {
            lstAccount.add(new Account(Name = 'Account Name ' + x));
        }
        insert lstAccount;

        //set up Opportunities
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(Integer x = 0; x < 10; x++)
        {
            // Region_Level_1__c = 'Americas'
            lstOpportunity.add(new Opportunity(Name = 'Opportunity ' + x
                                                ,AccountId = lstAccount.get(x).Id
                                                ,StageName = 'New'
                                                ,CloseDate = System.today() + 90
                                                ,City__c = 'Atlanta'
                                                ,Country__c = 'United States'
                                                ,Deal_Category__c = 'New Development'
                                                ,Locator__c = 'USA'
                                                ,Region_Level_1__c = 'Americas'));    
            // Region_Level_1__c = 'EMEAA'
            lstOpportunity.add(new Opportunity(Name = 'Opportunity ' + x
                                                ,AccountId = lstAccount.get(x).Id
                                                ,StageName = 'New'
                                                ,CloseDate = System.today() + 90
                                                ,City__c = 'Atlanta'
                                                ,Country__c = 'United States'
                                                ,Deal_Category__c = 'New Development'
                                                ,Locator__c = 'USA'
                                                ,Region_Level_1__c = 'EMEAA'));                                                                                                                             
        }
        insert lstOpportunity; 
    }

    //Create [Cross_Org_Collaboration__c]. Can't be put into TestSetup as it invalides Tests. Call seperately
    public static void createCrossOrgCollab(Integer intCount)
    {
        //set up Cross_Org_Collaboration__c
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = new List<Cross_Org_Collaboration__c>();
        for(Integer x = 0; x < intCount; x++)
        {
            Cross_Org_Collaboration__c objCrossOrgCollab = new Cross_Org_Collaboration__c();
            objCrossOrgCollab.Event__c = 'NEW'; 
            objCrossOrgCollab.Active__c = True; 
            objCrossOrgCollab.isComment__c = false; 
            objCrossOrgCollab.Body__c = 'Some random payload: ' + x;  
            objCrossOrgCollab.First_Name__c = 'Tony';  
            objCrossOrgCollab.Last_Name__c = 'Stark';  
            objCrossOrgCollab.Alias__c = 'TStark';  
            objCrossOrgCollab.Internal_Record_ID__c = '123456789';  
            objCrossOrgCollab.Internal_FeedItem_ID__c = '1122334455';  
            objCrossOrgCollab.Internal_User_ID__c = '987654321'; 
            objCrossOrgCollab.Sent__c = False;       
            objCrossOrgCollab.Received__c = False;                  
            lstCrossOrgCollab.add(objCrossOrgCollab); 
        }
        insert lstCrossOrgCollab;
    }

    /**********************************************************************************************************   
        Assertion   : (1) Number of return items is the same as @param intExpectedCount
    ***********************************************************************************************************/
    public static void updateCrossOrgCollabs(Integer intExpectedCount, Boolean blnComment, String strEvent)		
	{    
        deleteCrossOrgCollabs(); 
        Integer intCount = 0;	

        //create FeedItem & CrossOrgCollab and then update CrossOrgCollab with FeedItem id created
        List<SObject> lstFeedItems;

        if (blnComment) { lstFeedItems = createFeedComments(intExpectedCount); }
        else            { lstFeedItems = createFeedItemsFromOpportunity(intExpectedCount, 0); }       

        System.assertEquals(intExpectedCount, lstFeedItems.size());

        createCrossOrgCollab(intExpectedCount);
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabsToUpdate = [SELECT id, Internal_FeedItem_ID__c, Success__c FROM Cross_Org_Collaboration__c];
        for (Cross_Org_Collaboration__c objCrossOrgCollab : lstCrossOrgCollabsToUpdate)
        {
            objCrossOrgCollab.Internal_FeedItem_ID__c = lstFeedItems.get(intCount).id;
            intCount++;
        }
        update lstCrossOrgCollabsToUpdate;

        //instatiated initial objects & call method
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  

        List<Cross_Org_Collaboration__c> lstCrossOrgCollabRet = objCrossOrgCollab.updateCrossOrgCollabs(lstCrossOrgCollabsToUpdate, lstFeedItems, blnComment, strEvent); 
        
        intCount = 0;	
        for (Cross_Org_Collaboration__c objCrossOrgCollab2 : lstCrossOrgCollabRet)
        {
            String strField = blnComment ? 'CommentBody' : 'Body';
            //Assertion (1) 
            System.assertEquals(lstFeedItems.get(intCount).get(strField) + ' ', objCrossOrgCollab2.Body__c);
            System.assertEquals(strEvent, objCrossOrgCollab2.Event__c);
            System.assertEquals(false, objCrossOrgCollab2.Sent__c);
            System.assertEquals(false, objCrossOrgCollab2.Sent__c);
            System.assertEquals(false, objCrossOrgCollab2.Received__c);
            System.assertEquals(null, objCrossOrgCollab2.Sent_DTTM__c);
            System.assertEquals(null, objCrossOrgCollab2.Received_DTTM__c);
            intCount++;
        }
    }

    //  Updates 1 x Cross_Org_Collaboration__c Feed Post(s)
    @isTest  static void updateCrossOrgCollabs_Test_01()   { updateCrossOrgCollabs(1, false, 'EDIT'); }

    //  Updates 5 x Cross_Org_Collaboration__c Feed Post(s)
    @isTest  static void updateCrossOrgCollabs_Test_02()   { updateCrossOrgCollabs(5, false, 'EDIT'); }

    //  Updates 10 x Cross_Org_Collaboration__c Feed Post(s)
    @isTest  static void updateCrossOrgCollabs_Test_03()   { updateCrossOrgCollabs(10, false, 'EDIT'); }

    //  Updates 1 x Cross_Org_Collaboration__c Feed Comment(s) 
    @isTest  static void updateCrossOrgCollabs_Test_04()   { updateCrossOrgCollabs(1, true, 'EDIT'); }

    //  Updates 5 x Cross_Org_Collaboration__c Feed Comment(s) 
    @isTest  static void updateCrossOrgCollabs_Test_05()   { updateCrossOrgCollabs(5, true, 'EDIT'); }

    //  Updates 10 x Cross_Org_Collaboration__c Feed Comment(s) 
    @isTest  static void updateCrossOrgCollabs_Test_06()   { updateCrossOrgCollabs(10, true, 'EDIT'); }

    /**********************************************************************************************************   
        Assertion   : (1) Number of return items is the same as @param intExpectedCount
    ***********************************************************************************************************/
    public static void getCrossOrgCollabsToUpdate(Integer intExpectedCount)		
	{    
        deleteCrossOrgCollabs(); 
        Integer intCount = 0;	

        //create FeedItem & CrossOrgCollab and then update CrossOrgCollab with FeedItem id created
        List<SObject> lstFeedItems = createFeedItemsFromOpportunity(intExpectedCount, 0);
        createCrossOrgCollab(intExpectedCount);
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = [SELECT id, Internal_FeedItem_ID__c, Success__c FROM Cross_Org_Collaboration__c];
        for (Cross_Org_Collaboration__c objCrossOrgCollab : lstCrossOrgCollab)
        {
            objCrossOrgCollab.Internal_FeedItem_ID__c = lstFeedItems.get(intCount).id;
            objCrossOrgCollab.Success__c = true;
            intCount++;
        }
        update lstCrossOrgCollab;

        //instatiated initial objects & call method
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabRet = objCrossOrgCollab.getCrossOrgCollabsToUpdate(lstFeedItems); 
        
        //Assertion (1) 
        System.assertEquals(intExpectedCount, lstCrossOrgCollabRet.size());
    }

    //  Tests 1 x Cross_Org_Collaboration__c is returned 
    @isTest  static void getCrossOrgCollabsToUpdate_Test_01()   { getCrossOrgCollabsToUpdate(1); }

    //  Tests 5 x Cross_Org_Collaboration__c is returned 
    @isTest  static void getCrossOrgCollabsToUpdate_Test_02()   { getCrossOrgCollabsToUpdate(5); }

    //  Tests 10 x Cross_Org_Collaboration__c is returned 
    @isTest  static void getCrossOrgCollabsToUpdate_Test_03()   { getCrossOrgCollabsToUpdate(10); }

    /**********************************************************************************************************   
        Assertion   : (1) Number of committed elements is the same as @param lstFeedItems 
                      (2) Ensure that the correct values from @param lstFeedItems are inserted into the DB
    ***********************************************************************************************************/
    public static void marshallChatterMessages(Integer intCount, String strSourceOrg, String strExpectedPayload)		
	{    
        createCrossOrgCollab(10);
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = [SELECT id, Body__c, Internal_User_ID__c, First_Name__c
                                                                    ,Last_Name__c, Alias__c, isComment__c
                                                                    ,Internal_FeedItem_ID__c, Internal_Record_ID__c
                                                                    ,Event__c, External_Record_ID__c, External_FeedItem_ID__c, External_User_ID__c
                                                             FROM   Cross_Org_Collaboration__c LIMIT :intCount]; 
           
        System.assertEquals(intCount, lstCrossOrgCollab.size());

        //instatiated initial objects & call method
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  
        String strPayload = objCrossOrgCollab.marshallChatterMessages(lstCrossOrgCollab, strSourceOrg); 

        //Assert(1): 1 [Cross_Org_Collaboration__c] created
        System.assertEquals(strExpectedPayload, strPayload);
    }

    //  Tests 1 x msgREST_REQ_COMP_FeedItem 
    @isTest  static void marshallChatterMessages_Test_01()  
    {  
        String strPayload = '{"SourceOrg":"GOLS","FeedItems":[{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 0","alias":"TStark"}]}';
        marshallChatterMessages(1, 'GOLS', strPayload);
    }

    //  Tests 5 x msgREST_REQ_COMP_FeedItem 
    @isTest  static void marshallChatterMessages_Test_02()  
    {  
        String strPayload = '{"SourceOrg":"GOLS","FeedItems":[{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 0","alias":"TStark"}'
                                                           +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 1","alias":"TStark"}'
                                                           +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 2","alias":"TStark"}'
                                                           +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 3","alias":"TStark"}'
                                                           +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 4","alias":"TStark"}'
                                                           +']}';
        marshallChatterMessages(5, 'GOLS', strPayload);
    }

    //  Tests 10 x msgREST_REQ_COMP_FeedItem 
    @isTest  static void marshallChatterMessages_Test_03()  
    {  
        String strPayload = '{"SourceOrg":"GOLS","FeedItems":[{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 0","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 1","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 2","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 3","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 4","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 5","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 6","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 7","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 8","alias":"TStark"}'
                                                            +',{"success":false,"lastName":"Stark","isComment":false,"internalUserId":"987654321","internalRecordId":"123456789","internalFeedItemId":"1122334455","firstName":"Tony","externalUserId":null,"externalRecordId":null,"externalFeedItemId":null,"event":"NEW","errorMessage":null,"errorFields":null,"errorCode":null,"body":"Some random payload: 9","alias":"TStark"}'
                                                            +']}';
        marshallChatterMessages(10, 'GOLS', strPayload);
    }

    public static void deleteCrossOrgCollabs() 		
	{ 
        List<Cross_Org_Collaboration__c> lstToDelete =  [SELECT Id FROM Cross_Org_Collaboration__c];
        //ensure clean DB
        Delete lstToDelete;
    }

    /**********************************************************************************************************   
        Assertion   : (1) Number of committed elements is the same as @param lstFeedItems 
                      (2) Ensure that the correct values from @param lstFeedItems are inserted into the DB
    ***********************************************************************************************************/
    public static void  saveCustomFeedItems(List<SObject> lstFeedItems, Boolean blnComment, String strEvent, Integer intExpectedFeedItems) 		
	{   
        deleteCrossOrgCollabs(); 	

        //instatiated initial objects & call method
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  
        Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();
        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = objCrossOrgCollab.saveCustomFeedItems(lstFeedItems, blnComment, strEvent, mapCrossOrgCollabByFeedId); 

        //Assert(1): check the appropraite amounts of [Cross_Org_Collaboration__c] & [mapCrossOrgCollabByFeedId] are created
        System.assertEquals(intExpectedFeedItems, lstCrossOrgCollab.size());
        System.assertEquals(intExpectedFeedItems, mapCrossOrgCollabByFeedId.size());

        //check to see if anything was inserted due to the call
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabCheck =  [SELECT Id,Event__c,Active__c ,Body__c,First_Name__c,Last_Name__c
                                                                            ,Internal_Record_ID__c,Internal_FeedItem_ID__c,Sent__c,Received__c
                                                                            ,Alias__c, Internal_User_ID__c
                                                                    FROM   Cross_Org_Collaboration__c];
        
        System.assertEquals(intExpectedFeedItems, lstCrossOrgCollabCheck.size());

        //Assert(2): Cross check the individual values insert correctly
        Integer intCount = 0;
        For (Cross_Org_Collaboration__c objCrossOrgCollabDB : lstCrossOrgCollabCheck)
        {
            System.assertEquals(lstFeedItems.get(intCount).id, objCrossOrgCollabDB.Internal_FeedItem_ID__c);
            System.assertEquals(strEvent, objCrossOrgCollabDB.Event__c);
            FeedItem objFeedItem = (FeedItem)lstFeedItems.get(intCount);
            System.assertEquals(objFeedItem.Body, objCrossOrgCollabDB.Body__c, '[' + objFeedItem.Body + '] | [' + objCrossOrgCollabDB.Body__c + ' ]');
            System.assertEquals(objFeedItem.createdby.FirstName, objCrossOrgCollabDB.First_Name__c);
            System.assertEquals(objFeedItem.createdby.LastName, objCrossOrgCollabDB.Last_Name__c);
            System.assertEquals(objFeedItem.createdby.Alias, objCrossOrgCollabDB.Alias__c);
            //System.assertEquals(objFeedItem.createdbyId, objCrossOrgCollabDB.Internal_User_ID__c);
            System.assertEquals(objFeedItem.ParentId, objCrossOrgCollabDB.Internal_Record_ID__c);
            System.assertEquals(False, objCrossOrgCollabDB.Sent__c);
            System.assertEquals(False, objCrossOrgCollabDB.Received__c);

            //now check to see if the map also holds the same objects
            Cross_Org_Collaboration__c objCrossOrgCollabByFeedId = mapCrossOrgCollabByFeedId.get(objCrossOrgCollabDB.Internal_FeedItem_ID__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Internal_FeedItem_ID__c, objCrossOrgCollabDB.Internal_FeedItem_ID__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Event__c, objCrossOrgCollabDB.Event__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Body__c, objCrossOrgCollabDB.Body__c + ' ' , '[' + objCrossOrgCollabByFeedId.Body__c + '] | [' + objCrossOrgCollabDB.Body__c + ']');
            System.assertEquals(objCrossOrgCollabByFeedId.First_Name__c, objCrossOrgCollabDB.First_Name__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Last_Name__c, objCrossOrgCollabDB.Last_Name__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Alias__c, objCrossOrgCollabDB.Alias__c);
            //System.assertEquals(objCrossOrgCollabByFeedId.Internal_User_ID__c, objCrossOrgCollabDB.Internal_User_ID__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Internal_Record_ID__c, objCrossOrgCollabDB.Internal_Record_ID__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Sent__c, objCrossOrgCollabDB.Sent__c);
            System.assertEquals(objCrossOrgCollabByFeedId.Received__c, objCrossOrgCollabDB.Received__c);
            intCount++;
        }
    }

    //  Tests 0 x FeedItem 
    @isTest  static void saveCustomFeedItems_Test_01()  
    {  
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 0));	
        saveCustomFeedItems(lstFeedItems, false, 'NEW', 0);
    }

    //  Tests 1 x FeedItem 
    @isTest  static void saveCustomFeedItems_Test_02()  
    {  
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 1));	
        saveCustomFeedItems(lstFeedItems, false, 'NEW', 1);
    }

    //  Tests 10 x FeedItem 
    @isTest  static void saveCustomFeedItems_Test_03()  
    {  
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 10));	
        saveCustomFeedItems(lstFeedItems, false, 'NEW', 10);
    }

    public static void  saveCustomFeedComment(Boolean blnComment, String strEvent, Integer intExpectedFeedItems) 		
	{   
        deleteCrossOrgCollabs(); 	

        //create the FeedComments
        List<SObject> lstFeedComments = createFeedComments(intExpectedFeedItems);
        //create the [create_Cross_Org_Collab__c] objects
        createCrossOrgCollab(intExpectedFeedItems);
        //link the FeedComments to the [create_Cross_Org_Collab__c] objects
        List<Cross_Org_Collaboration__c> lstParentFeedItemCrossOrgCollab = [SELECT   id,Internal_FeedItem_ID__c FROM Cross_Org_Collaboration__c];
        Integer i = 0;
        for (Cross_Org_Collaboration__c obj: lstParentFeedItemCrossOrgCollab)
        {
            obj.Internal_FeedItem_ID__c = String.valueOf(lstFeedComments.get(i).get('FeedItemId')) ;
            obj.External_Record_ID__c =  '123456789';
            i++;
        }
        update lstParentFeedItemCrossOrgCollab;

        //instatiated initial objects & call method
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  
        Map<String, Cross_Org_Collaboration__c> mapCrossOrgCollabByFeedId = new Map<String, Cross_Org_Collaboration__c>();

        List<Cross_Org_Collaboration__c> lstCrossOrgCollab = objCrossOrgCollab.saveCustomFeedComments(lstFeedComments, blnComment, strEvent, mapCrossOrgCollabByFeedId); 

        //Assert(1): check the appropraite amounts of [Cross_Org_Collaboration__c] & [mapCrossOrgCollabByFeedId] are created
        System.assertEquals(intExpectedFeedItems, lstCrossOrgCollab.size());
        System.assertEquals(intExpectedFeedItems, mapCrossOrgCollabByFeedId.size());

        //check to see if anything was inserted due to the call
        List<Cross_Org_Collaboration__c> lstCrossOrgCollabCheck =  [SELECT Id,Event__c,Active__c ,Body__c,First_Name__c,Last_Name__c
                                                                            ,Internal_Record_ID__c,Internal_FeedItem_ID__c,Sent__c,Received__c
                                                                            ,Alias__c, Internal_User_ID__c
                                                                    FROM   Cross_Org_Collaboration__c];
        
        //System.assertEquals(intExpectedFeedItems, lstCrossOrgCollabCheck.size());
    }

    //  Tests 1 x FeedComment 
    @isTest  static void saveCustomFeedComments_Test_01()  
    {  
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 1));	
        saveCustomFeedComment(true, 'NEW', 1);
    }

    /**********************************************************************************************************   
        Assertion   : (1) Size of returned list is the same as @param intExpectedFeedItems
                      (2) Each element's parent object in the returned list is an Opportunity
    ***********************************************************************************************************/
    public static void  getRelevantFeedItems(List<SObject> lstFeedItems, String strRelevantObject, Integer intExpectedFeedItems) 	
	{   
        String strQuery = '';
        if (strRelevantObject.equalsIgnoreCase('Opportunity'))
        {
            strQuery = 'SELECT Id, Region_Level_1__c FROM Opportunity WHERE Region_Level_1__c <> \'Americas\' AND id IN ';
        }

        //set up and call
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();
        List<Object> lstRetFeedItems = objCrossOrgCollab.getRelevantFeedItems(lstFeedItems, strRelevantObject, strQuery);

        //Assert (1)
        System.assertEquals(intExpectedFeedItems, lstRetFeedItems.size());

        for (Object sobjItem:lstRetFeedItems)
        {
            FeedItem objItem = (FeedItem)sobjItem;
            //Assert (2)
            System.assertEquals(strRelevantObject, objItem.ParentId.getSObjectType().getDescribe().getName());
        }
    }
   
    //  Tests 0 x FeedItem 
    @isTest static void getRelevantFeedItems_Test_01() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 0));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 0);
    }

    //  Tests 1 x FeedItem associated with 1 x Non Americas Opporunity   
    @isTest static void getRelevantFeedItems_Test_02() 	
	{
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 1));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 1);
    }

    //  Tests 2 x FeedItem associated with 1 x Non Americas Opporunity and 1 x Americas Opporunity   
    @isTest static void getRelevantFeedItems_Test_03() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(1, 1));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 1);
    }

    //  Tests 10 x FeedItem associated with 5 x Non Americas Opporunity and 5 x Americas Opporunity   
    @isTest static void getRelevantFeedItems_Test_04() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(5, 5));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 5);
    }

    //  Tests 20 x FeedItem associated with 10 x Non Americas Opporunity and 10 x Americas Opporunity   
    @isTest static void getRelevantFeedItems_Test_05() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(10, 10));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 10);
    }

    //  Tests 10 x FeedItem associated with 10 x Non Americas Opporunity 
    @isTest static void getRelevantFeedItems_Test_06() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 10));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 10);
    }

    //  Tests 20 x FeedItem associated with 10 x Non Americas Opporunity - different ordering
    @isTest static void getRelevantFeedItems_Test_06_1() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 4));
        lstFeedItems.addAll(createFeedItemsFromProject(4));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 1));
        lstFeedItems.addAll(createFeedItemsFromProject(1));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 4));
        lstFeedItems.addAll(createFeedItemsFromProject(4));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(1, 1));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 10);
    }

    //  Tests 10 x FeedItem associated with 10 x Americas Opporunity 
    @isTest static void getRelevantFeedItems_Test_07() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(10, 0));
        getRelevantFeedItems(lstFeedItems, 'Opportunity', 0);
    }

    //  Tests 1 x FeedItem associated with 1 X Account
    @isTest static void getRelevantFeedItems_Test_08() 	
    {
        Account objAcct = new Account(Name = 'getRelevantFeedItems_Test_08');
        insert objAcct;

        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.add(new FeedItem(Body = 'getRelevantFeedItems_Test_08', Type = 'TextPost', ParentId = objAcct.Id));

        getRelevantFeedItems(lstFeedItems, 'Opportunity', 0);
    }

    //  Tests 1 x FeedItem associated with 1 x Project
    @isTest static void getRelevantFeedItems_Test_09() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromProject(1));
        getRelevantFeedItems(lstFeedItems, 'Project__c', 1);
    }

    //  Tests 5 x FeedItem associated with 5 x Projects
    @isTest static void getRelevantFeedItems_Test_10() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromProject(5));
        getRelevantFeedItems(lstFeedItems, 'Project__c', 5);
    }

    //  Tests 10 x FeedItems associated with 10 x Projects
    @isTest static void getRelevantFeedItems_Test_11() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromProject(10));
        getRelevantFeedItems(lstFeedItems, 'Project__c', 10);
    }
    
    //  Tests 20 x FeedItems associated but only 10 x Projects associations
    @isTest static void getRelevantFeedItems_Test_12() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(5, 0));
        lstFeedItems.addAll(createFeedItemsFromProject(10));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(5, 0));
        getRelevantFeedItems(lstFeedItems, 'Project__c', 10);
    }

    //  Tests 20 x FeedItems associated but only 10 x Projects associations - with different ordering
    @isTest static void getRelevantFeedItems_Test_13() 	
    {
        List<SObject> lstFeedItems = new List<SObject>();
        lstFeedItems.addAll(createFeedItemsFromOpportunity(4, 0));
        lstFeedItems.addAll(createFeedItemsFromProject(4));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(0, 4));
        lstFeedItems.addAll(createFeedItemsFromProject(4));
        lstFeedItems.addAll(createFeedItemsFromOpportunity(2, 2));
        lstFeedItems.addAll(createFeedItemsFromProject(2));
        getRelevantFeedItems(lstFeedItems, 'Project__c', 10);
    }


    /**********************************************************************************************************   
        Assertion   : (1) Size of returned list is the same as @param intExpectedFeedItems
                      (2) Each element's parent object in the returned list is an Opportunity
    ***********************************************************************************************************/
    public static void  getRelevantFeedComments(Integer intExpectedFeedItems) 	
	{   
        //create the FeedComments
        List<SObject> lstFeedComments = createFeedComments(intExpectedFeedItems);
        //create the [create_Cross_Org_Collab__c] objects
        createCrossOrgCollab(intExpectedFeedItems);
        //link the FeedComments to the [create_Cross_Org_Collab__c] objects

        List<Cross_Org_Collaboration__c> lstParentFeedItemCrossOrgCollab = [SELECT   id,Internal_FeedItem_ID__c FROM Cross_Org_Collaboration__c];
        Integer i = 0;
        for (Cross_Org_Collaboration__c obj: lstParentFeedItemCrossOrgCollab)
        {
            obj.Internal_FeedItem_ID__c = String.valueOf(lstFeedComments.get(i).get('FeedItemId')) ;
            i++;
        }
        update lstParentFeedItemCrossOrgCollab;

        //set up and call
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();
        List<Object> lstRetFeedItems = objCrossOrgCollab.getRelevantFeedComments(lstFeedComments, '');

        //Assert (1)
        System.assertEquals(intExpectedFeedItems, lstRetFeedItems.size());
    }
   
    //  Tests 0 x FeedItem 
    @isTest static void getRelevantFeedComments_Test_01() 	
    {
        getRelevantFeedComments(0);
    }

    //  Tests 1 x FeedItem 
    @isTest static void getRelevantFeedComments_Test_02() 	
    {
        getRelevantFeedComments(1);
    }



    /**********************************************************************************************************   
        Description : Creates N x FeedItems based on Projects
        Parameters	: @param intCount    : Number of Feed Items to create associated with the same number of Projects
    ***********************************************************************************************************/
    public static List<SObject> createFeedItemsFromProject(Integer intCount) 	
	{
        //set up Project
        List<Project__c> lstProjects = new List<Project__c>();
        for(Integer x = 0; x < intCount; x++)
        {
            lstProjects.add(new Project__c());
        }
        insert lstProjects;

        List<FeedItem> lstFeedItems = new List<FeedItem>();
        for(Integer x = 0; x < intCount; x++)
        {
            lstFeedItems.add(new FeedItem(Body = 'Project Comment :' + x, Type = 'TextPost', ParentId = lstProjects.get(x).Id));
        }
        insert lstFeedItems; 

        return  lstFeedItems;
    }

    /**********************************************************************************************************   
        Description : Creates N x FeedItems based on Opportunities with different [Region_Level_1__c] 
        Parameters	: @param intAmerica    : Number of Feed Items to create where the Opportunities [Region_Level_1__c]  = 'Americas'
                      @param intNotAmerica : Number of Feed Items to create where the Opportunities [Region_Level_1__c] <> 'Americas'
    ***********************************************************************************************************/
    public static List<SObject> createFeedItemsFromOpportunity(Integer intAmerica, Integer intNotAmerica) 	
	{
        //get Opportunitys, limited by [Region_Level_1__c]
        List<Opportunity> lstOpptyAMER      = [SELECT id FROM Opportunity WHERE Region_Level_1__c =  'Americas' LIMIT :intAmerica];
        List<Opportunity> lstOpptyNonEMEAA  = [SELECT id FROM Opportunity WHERE Region_Level_1__c <> 'Americas' LIMIT :intNotAmerica];

        List<FeedItem> lstFeedItems = new List<FeedItem>();

        //create FeedItems where Opportunity.[Region_Level_1__c] = 'Americas'
        for(Integer x = 0; x < intAmerica; x++)
        {
            lstFeedItems.add(new FeedItem(Body = 'Americas Comment :' + x, Type = 'TextPost', ParentId = lstOpptyAMER.get(x).Id));
        }

        //create FeedItems where Opportunity.[Region_Level_1__c] <> 'Americas'
        for(Integer x = 0; x < intNotAmerica; x++)
        {
            lstFeedItems.add(new FeedItem(Body = 'Non Americas Comment :' + x, Type = 'TextPost', ParentId = lstOpptyNonEMEAA.get(x).Id));
        }
        insert lstFeedItems;  

        return  lstFeedItems;
    }

    public static List<FeedComment> createFeedComments(Integer intNum) 	
	{
        //get Opportunitys, limited by [Region_Level_1__c]
        List<Opportunity> lstOpptyAMER = [SELECT id FROM Opportunity];

        List<FeedItem> lstFeedItems = new List<FeedItem>();

        //create FeedItems 
        for(Integer x = 0; x < intNum; x++)
        {
            lstFeedItems.add(new FeedItem(Body = 'Generic Feed Item Comment :' + x, Type = 'TextPost', ParentId = lstOpptyAMER.get(0).Id));
        }
        insert lstFeedItems;  
        List<FeedComment> lstFeedComments = new List<FeedComment>();

        //create FeedItems 
        for(Integer x = 0; x < intNum; x++)
        {
            lstFeedComments.add(new FeedComment(CommentBody  = 'Generic Feed Comment :' + x, FeedItemId = lstFeedItems.get(0).id));
        }
        insert lstFeedComments;  

        return  lstFeedComments;
    }
} 