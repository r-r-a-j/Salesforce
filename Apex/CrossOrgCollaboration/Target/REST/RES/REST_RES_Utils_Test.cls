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
public class REST_RES_Utils_Test 
{ 
    
    @TestSetup
    static void setup()
    { 
        //set up Users
        //get a known Profile that exists in the DB
        String strChatterFreeProfileId = [SELECT id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1].id;
        
        List<User> lstUser = new List<User>();

        //add users
        lstUser.add(REST_RES_Utils_Test.createUser('Tony', 'Stark', 'TStark', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Pepper', 'Potts', 'PPotts', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Bruce', 'Banner', 'BBanner', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Nick', 'Fury', 'NFury', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('The', 'Hulk', 'HHulk', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Iron', 'Man', 'IMan', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Captain', 'America', 'CAmerica', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('War', 'Machine', 'WMachine', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Than', 'Os', 'TOs', '@xorgcollabmentions.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Thunder', 'God', 'TGod', '@xorgcollabmentions.com', strChatterFreeProfileId));
        
        insert lstUser;

        //create Project__c
        List<Project__c> lstProjects = new List<Project__c>();
        for(Integer x = 0; x < 10; x++)
        {
            Project__c objProject = new Project__c();
            objProject.GOLS_Id__c = REST_RES_Utils_Test.generateRandomId();
            lstProjects.add(objProject);
        }
        insert lstProjects;

        //create Feed Posts
        List<FeedItem> lstFeedItems = new List<FeedItem>();
        for(Integer x = 0; x < 10; x++)
        {
            FeedItem objFeedItem = new FeedItem();
            objFeedItem.ParentId = String.valueOf(lstProjects.get(x).id);
            objFeedItem.CreatedById = String.valueOf(lstUser.get(x).id);
            objFeedItem.Body = 'This is the message body number ' + x;
            lstFeedItems.add(objFeedItem);
        }
        insert lstFeedItems;

        //create FeedComment
        List<FeedComment> lstFeedComment = new List<FeedComment>();
        for(Integer x = 0; x < 10; x++)
        {
            lstFeedComment.add(new FeedComment(CommentBody  = 'Generic Feed Comment :' + x, FeedItemId = lstFeedItems.get(0).id));
        }
        insert lstFeedComment;

        lstUser.clear();
        //add more users AFTER we have created and attached Feed Items to users
        lstUser.add(REST_RES_Utils_Test.createUser('Alfred', 'Pennyworth', 'APenny', '@crossollaborationest.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Selina', 'Kyle', 'SKyle', '@crossollaborationest.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Original', 'Poster', 'OPoster', '@originalposter.com', strChatterFreeProfileId));

        lstUser.add(REST_RES_Utils_Test.createUser('Scott', 'Summers', 'SSummers', '@updateusertest.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Eric', 'Lehnsherr', 'ELehnshe', '@updateusertest.com', strChatterFreeProfileId));
        lstUser.add(REST_RES_Utils_Test.createUser('Charles', 'Xavier', 'CXavier', '@updateusertest.com', strChatterFreeProfileId));
        
        insert lstUser;
    }

    public static msgREST_REQ_COMP_FeedItem updateFeed(List<msgREST_REQ_COMP_FeedItem> msgFeedItem, List<String> lstMentions
                                                        ,List<String> lstPieces ,Map<String, User> mapUsersKeyByName ) 	
    { 
        //call method to test
        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(msgFeedItem.get(0));

        return msgFeedItemRet;
    }

    @isTest static void updateFeed_Test_01() 	
	{
        Integer intCount = 1;
        List<String> lstMentions = new List<String>();
        List<String> lstPieces = new List<String>{'This is a comment'};
        Map<String, User> mapUsersKeyByName = new Map<String, User>();
        //List<FeedComment> createFeedComments(intCount); 	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, false, 'NEW') ;

        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(msgCrossOrgCollab.FeedItems.get(0));
    }

    @isTest static void updateFeed_Test_02() 	
	{
        Integer intCount = 1;
        List<String> lstMentions = new List<String>();
        List<String> lstPieces = new List<String>{'This is a comment'};
        Map<String, User> mapUsersKeyByName = new Map<String, User>();
        //List<FeedComment> createFeedComments(intCount); 	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, true, 'NEW') ;
        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(msgCrossOrgCollab.FeedItems.get(0));
    }

    @isTest static void updateFeed_Test_03() 	
	{
        Integer intCount = 1;
        List<String> lstMentions = new List<String>();
        List<String> lstPieces = new List<String>{'This is a comment'};
        Map<String, User> mapUsersKeyByName = new Map<String, User>();
        //List<FeedComment> createFeedComments(intCount); 	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, true, 'NEW') ;
        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(lstMentions, msgCrossOrgCollab.FeedItems.get(0), lstPieces, mapUsersKeyByName);
    }

    @isTest static void updateFeed_Test_04() 	
	{
        Integer intCount = 1;
        List<String> lstMentions = new List<String>();
        List<String> lstPieces = new List<String>{'This is a comment'};
        Map<String, User> mapUsersKeyByName = new Map<String, User>();
        //List<FeedComment> createFeedComments(intCount); 	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, false, 'NEW') ;
        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(lstMentions, msgCrossOrgCollab.FeedItems.get(0), lstPieces, mapUsersKeyByName);
    }

    /**********************************************************************************************************
    ***********************************************************************************************************   
        Method to test  : REST_RES_Utils.createChatterPost()
        Pre-Requistes   : **** If on OneForce Org, you must disable "FeedItemTrigger" from Set up, else this test will fail ****
        Parameters	    : @param intCount       The number of records to create and check for
                        @param blnSameProject Whether the created records should be associated with the same Project 
        Returns         : void
    ***********************************************************************************************************   
    ***********************************************************************************************************/
    public static msgREST_REQ_CrossOrgCollaboration createChatterFeed(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab, Boolean blnEmptyExternalRecordId) 	
	{
        //call method to test
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab2.FeedItems) 
        {
            //Assert (1)
            //if (!msgFeedItem.success){ System.assertEquals('Error', msgFeedItem.errorCode + '|' + msgFeedItem.errorMessage);}

            //get FeedItems that should have been created as a result
            String strFeedItemId = msgFeedItem.externalFeedItemId;
            List<FeedItem> lstFeedItems = [SELECT id, body, createdbyid, parentid FROM FeedItem WHERE id = :strFeedItemId];

            //Assert (2)
            If (lstFeedItems.size() == 0) {System.assertEquals('Error', 'Empty list : [lstFeedItems]');}

            //Account for the [externalRecordId] value being different. If this is empty on the way into the call, then the logic will replace
            //using the [internalRecordId] as a lookup
            if (blnEmptyExternalRecordId)
            {
                //Get Project__c record using [internalRecordId]
                String strInternalRecordId = msgFeedItem.internalRecordId;
                Project__c obProjects = [SELECT id FROM Project__c WHERE GOLS_Id__c = :strInternalRecordId LIMIT 1];
                System.assertEquals(obProjects.id, msgFeedItem.externalRecordId);
            }
            else
            {
                System.assertEquals(String.valueOf(lstFeedItems.get(0).parentid), msgFeedItem.externalRecordId);
            }
            
            System.assertEquals(String.valueOf(lstFeedItems.get(0).createdbyid), msgFeedItem.externalUserId);
            System.assertEquals(lstFeedItems.get(0).body, msgFeedItem.Body);
        }
        return msgCrossOrgCollab2;
    }

    //    Description     : Creates 1 x new Feed Post against 1 x Projects
    @isTest static void createChatterPost_POS_Test_01() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        Boolean blnEmptyExternalRecordId = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, blnComment, blnEmptyExternalNumbers);

        //get all Projects__c  & set the [msgREST_REQ_COMP_FeedItem].[externalRecordId] to the projects
        List<Project__c> lstProjects = [SELECT id, name, createddate FROM Project__c ];
        Integer x = 0;
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.externalRecordId = String.valueOf(lstProjects.get(x).id);
            x++;
        }
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = createChatterFeed(msgCrossOrgCollab, blnEmptyExternalRecordId);
    }

    //    Description     : Creates 1 x new Feed Item, but External ID is blank. The logic will use the [internalRecordId] instead as a lookup
    @isTest static void createChatterPost_POS_Test_02() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        Boolean blnEmptyExternalRecordId = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, blnComment, blnEmptyExternalNumbers);

        //get all Projects__c  & set the [msgREST_REQ_COMP_FeedItem].[internalRecordId] to the projects
        List<Project__c> lstProjects = [SELECT id, name, createddate, GOLS_Id__c FROM Project__c ];
        Integer x = 0;
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.internalRecordId = String.valueOf(lstProjects.get(x).GOLS_Id__c);
            x++;
            blnEmptyExternalRecordId = true;
        }
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = createChatterFeed(msgCrossOrgCollab, blnEmptyExternalRecordId);
    }

    //    Description     : Creates 10 x new Feed Post against 10 x Projects
    @isTest static void createChatterPost_POS_Test_03() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        Boolean blnEmptyExternalRecordId = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(10, strPostFix, blnComment, blnEmptyExternalNumbers);

        //get all Projects__c  & set the [msgREST_REQ_COMP_FeedItem].[externalRecordId] to the projects
        List<Project__c> lstProjects = [SELECT id, name, createddate FROM Project__c ];
        Integer x = 0;
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.externalRecordId = String.valueOf(lstProjects.get(x).id);
            x++;
        }
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = createChatterFeed(msgCrossOrgCollab, blnEmptyExternalRecordId);
    }

    //    Description     : Creates 10 x new Feed Item, but External ID is blank. The logic will use the [internalRecordId] instead as a lookup
    @isTest static void createChatterPost_POS_Test_04() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        Boolean blnEmptyExternalRecordId = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(10, strPostFix, blnComment, blnEmptyExternalNumbers);

        //get all Projects__c  & set the [msgREST_REQ_COMP_FeedItem].[internalRecordId] to the projects
        List<Project__c> lstProjects = [SELECT id, name, createddate, GOLS_Id__c FROM Project__c ];
        Integer x = 0;
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.internalRecordId = String.valueOf(lstProjects.get(x).GOLS_Id__c);
            x++;
            blnEmptyExternalRecordId = true;
        }
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = createChatterFeed(msgCrossOrgCollab, blnEmptyExternalRecordId);
    }

    public static msgREST_REQ_CrossOrgCollaboration createChatterFeedError(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab, List<String> lstExpectedErrors) 	
	{
        //call method to test
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab2.FeedItems) 
        {
            System.assertEquals(false, msgFeedItem.success);
            
            System.assertEquals('STRING_EXCEPTION', msgFeedItem.errorCode);
            System.assertEquals('Fields [externalRecordId] and [internalRecordId] are not a valid ID (18 chars long)', msgFeedItem.errorMessage);
            
            Integer x = 0;
            for (String strError :msgFeedItem.errorFields) 
            {
                System.assertEquals(lstExpectedErrors.get(x), strError);   
                x++;
            }
        }
        return msgCrossOrgCollab2;
    }

    //    Description     : Negative test. Creates 1 x new Feed Post but force an error - [externalRecordId] & [internalRecordId] are blank
    @isTest static void createChatterPost_NEG_Test_01() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        //deliberately force an error - [externalRecordId] is blank
        Boolean blnEmptyExternalNumbers = true;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, blnComment, blnEmptyExternalNumbers);

        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.internalRecordId = '';
            msgFeedItem.externalRecordId = '';
        }
        List<String> lstExpectedErrors = new List<String> {'externalRecordId = ', 'internalRecordId = '};

        //call method to test
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab2.FeedItems) 
        {
            System.assertEquals(false, msgFeedItem.success);
            
            System.assertEquals('STRING_EXCEPTION', msgFeedItem.errorCode);
            System.assertEquals('Fields [externalRecordId] and [internalRecordId] are not a valid ID (18 chars long)', msgFeedItem.errorMessage);
            
            Integer x = 0;
            for (String strError :msgFeedItem.errorFields) 
            {
                System.assertEquals(lstExpectedErrors.get(x), strError);   
                x++;
            }
        }
    }

    //    Description     : Negative test. Creates 1 x new Feed Post but force an error - [externalUserId] is less than 18 chars
    @isTest static void createChatterPost_NEG_Test_02() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, blnComment, blnEmptyExternalNumbers);

        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.externalUserId = '';
        }
        List<String> lstExpectedErrors = new List<String> {'externalUserId = '};

        //call method to test
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab2.FeedItems) 
        {
            System.assertEquals(false, msgFeedItem.success);
            
            System.assertEquals('STRING_EXCEPTION', msgFeedItem.errorCode);
            System.assertEquals('Field [externalUserId] is not a valid ID (18 chars long)', msgFeedItem.errorMessage);
            
            Integer x = 0;
            for (String strError :msgFeedItem.errorFields) 
            {
                System.assertEquals(lstExpectedErrors.get(x), strError);   
                x++;
            }
        }
    }

    //    Description     : Negative test. Creates 1 x new Feed Post but force an error - [externalRecordId] is fake
    @isTest static void createChatterPost_NEG_Test_03() 	
	{
        String strPostFix = '@xorgcollabmentions.com';
        Boolean blnComment = false;
        Boolean blnEmptyExternalNumbers = false;
        //attach to Ghost User(s)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, blnComment, blnEmptyExternalNumbers);

        String strRandomId = generateRandomId();
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            msgFeedItem.externalUserId = strRandomId;
        }

        //call method to test
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab2 = REST_RES_Utils.createChatterPost(msgCrossOrgCollab);

        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab2.FeedItems) 
        {
            System.assertEquals(false, msgFeedItem.success);
            
            System.assertEquals('GENERAL_EXCEPTION', msgFeedItem.errorCode);
            System.assertEquals('List has no rows for assignment to SObject', msgFeedItem.errorMessage);
        }
    }

    /**********************************************************************************************************   
        Description     : Given N x FeedItem, return either newly created user(s), or ones that already exist
        Expected Output : (1) Returned String does not start with 'Error'
                          (2) externalUserId is not null/empty
                          (3) External Id is present and a valid DB record
    ***********************************************************************************************************/    
    public static void setFeedUsers(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab, Map<String, User> mapGhostUsersByUsername, String strPostFix) 	
	{        
        String strProfileId = getProfileId();

        String strRet = REST_RES_Utils.setFeedUsers(msgCrossOrgCollab, strPostFix, strProfileId, mapGhostUsersByUsername);
      
        //Assert (1)
        if (strRet.startsWithIgnoreCase('Error')) {System.assertEquals('Error', 'Error returning String: ' + strRet);}
        
        //loop incoming FeedItem list
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            //Assert (2)
            if ((String.isBlank(msgFeedItem.externalUserId))) { System.assertEquals('Error', 'externalUserId is empty'); }

            //Assert (3)
            List<User> lstUser = [SELECT ProfileId, Firstname, Lastname FROM User WHERE id = :msgFeedItem.externalUserId];
            System.assertNotEquals(0, lstUser.size());
        }
    }

    //    Description     : Given 1 x FeedItem, return 1 x newly created user
    @isTest static void setFeedUsers_Test_01() 	
    {   
        String strPostFix = '@xorgcollabmentions.com';
        Map<String, User> mapGhostUsersByUsername = new Map<String, User>();
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, false, true);
        setFeedUsers(msgCrossOrgCollab, mapGhostUsersByUsername, strPostFix); 
    }

    //    Given 1 x FeedItem, return 1 x known user
    @isTest static void setFeedUsers_Test_02() 	
    {   
        String strPostFix = '@xorgcollabmentions.com';
        Map<String, User> mapGhostUsersByUsername = getUsersByNameUserNamesEndsWith(strPostFix);
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(1, strPostFix, false, true);
        setFeedUsers(msgCrossOrgCollab, mapGhostUsersByUsername, strPostFix); 
    }

    //    Given 10 x FeedItem, return 10 x newly created user
    @isTest static void setFeedUsers_Test_03() 	
    {   
        String strPostFix = '@xorgcollabmentions.com';
        Map<String, User> mapGhostUsersByUsername = new Map<String, User>();
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(10, strPostFix, false, true);
        setFeedUsers(msgCrossOrgCollab, mapGhostUsersByUsername, strPostFix); 
    }

    //    Given 10 x FeedItem, return 10 x known user
    @isTest static void setFeedUsers_Test_04() 	
    {   
        String strPostFix = '@xorgcollabmentions.com';
        Map<String, User> mapGhostUsersByUsername = getUsersByNameUserNamesEndsWith(strPostFix);
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(10, strPostFix, false, true);
        setFeedUsers(msgCrossOrgCollab, mapGhostUsersByUsername, strPostFix); 
    }

    /**********************************************************************************************************   
        Description     : Tests to see if all distinct users are retrieved from method
        Parameters      : @param strUserNamePostFix : The Username's post fix to query against
                          @param intNumOfGhostUsers : Number of Shost User expected to be returned
        Expected Output : (1) A DB supplied Profile ID is returned
    ***********************************************************************************************************/
    public static void getUserMap(String strUserNamePostFix, Integer intNumOfGhostUsers) 	
	{
        Map<String, User> mapUsersByNameNonGhostUsers = new Map<String, User>();
        
        Map<String, User> mapUsersKeyByUsername = REST_RES_Utils.getUserMap(mapUsersByNameNonGhostUsers, strUserNamePostFix);
      
        //Assert (1)
        System.assertEquals(intNumOfGhostUsers, mapUsersKeyByUsername.size());

        //Assert (2)
        //get all users (Ghost users + Non-Ghost User). Send in empty string to act as wildcard
        Map<String, User> mapAllUsers = REST_RES_Utils_Test.getUsersByNameUserNamesEndsWith('');
        Integer intUserNumDifference = mapAllUsers.size() - intNumOfGhostUsers;

        System.assertEquals(intUserNumDifference, mapUsersByNameNonGhostUsers.size());
    }

    //  Description     : Tests to see if all distinct users are retrieved from method
    @isTest static void getUserMap_Test_01() { getUserMap('@XThisShouldNotWork.com', 0); }	

    //  Description     : Tests to see if all distinct users are retrieved from method
    @isTest static void getUserMap_Test_02() { getUserMap('@crossollaborationest.com', 2); }	

    /**********************************************************************************************************   
        Description     : Test to see if a valid Profile ID is returned of the Chatter Free Profile.
        Parameters      : @param strProfile         : The profile name to fetch
                          @param strUserNamePostFix : The Username's post fix to query against
        Expected Output : (1) A DB supplied Profile ID is returned
    ***********************************************************************************************************/
    public static void getChatterFreeProfileId(String strProfile, String strUserNamePostFix) 	
	{
        String strChatterFreeProfileID = [SELECT id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1].id;

        List<Profile> lstProfile = [SELECT id FROM Profile WHERE Name = :strProfile];

        If (lstProfile.size() == 0) {System.assertEquals('Error', 'Error fetchinig ' + strProfile + ' User Profile');}

        Map<String, User> mapUser = REST_RES_Utils_Test.getUsersByUserNameUserNamesEndsWith(strUserNamePostFix);

        String strChatterFreeProfile = REST_RES_Utils.getChatterFreeProfileId(mapUser, strUserNamePostFix);

        //Assert (1)
        System.assertEquals(strChatterFreeProfileID, strChatterFreeProfile);
    }

    //  Description : Provides 1 x Chatter Free based users, therefore the logic should simply return the Profile ID stored against this user
    @isTest static void getChatterFreeProfileId_Test_01() { getChatterFreeProfileId('Chatter Free User', '@xorgcollabmentions.com'); }
    
    //  Description : Provides 1 x Non Chatter Free based users, forcing the a DB search on the Profile table
    @isTest static void getChatterFreeProfileId_Test_02() { getChatterFreeProfileId('Read Only', ''); }

    /**********************************************************************************************************
        Parameters	    : @param intCountAtMentions The number of  @mentions to expect
                          @param strFeed            The feed to parse against
        Expected Output : (1) Size of returned list is [intCountAtMentions]
                          (2) The returned list contains the found Names
    ***********************************************************************************************************/
    public static void getUserNameMentions(Integer intCountAtMentions, String strFeed) 	
	{                       
        String strPostFix = '@xorgcollabmentions.com';
        Map<String, User> mapUsersKeyByName = REST_RES_Utils_Test.getUsersByNameUserNamesEndsWith(strPostFix);

        //System.System.debug('>>>>> getUserNameMentions () mapUsersKeyByName: ' + mapUsersKeyByName);

        //System.assertEquals(null, mapUsersKeyByName); 
        List<String> lstMentions = REST_RES_Utils.getUserNameMentions(strFeed, mapUsersKeyByName);
        
        //returned list is not empty
        //System.assertNotEquals(null, lstMentions); 

        //Assert (1)
        //System.assertEquals(intCountAtMentions, lstMentions.size());

        //Assert (2)
        /*for (String strName :lstMentions)
        {
            System.assertNotEquals(null, mapUsersKeyByName.get(strName)); 
        }*/
    }

    //    Description     : Test a string containing zero @mentions
    @isTest static void getUserNameMentions_Test_01() 	
	{
        getUserNameMentions(0, 'Hey Tony Stark, this is Pepper Potts! from London. Did you manage to talk to Bruce Banner>>>????? yet?');
    }

    //    Description     : Test a string containing 1 x @mentions
    @isTest static void getUserNameMentions_Test_02()	
	{
        getUserNameMentions(1, 'Hey @Tony Stark, this is Pepper Potts! from London. Did you manage to talk to Bruce Banner>>>????? yet?');
    }

    //    Description     : Test a string containing 2 x @mentions
    @isTest static void getUserNameMentions_Test_03()
	{
        getUserNameMentions(2, 'Hey @Tony Stark, this is @Pepper Potts! from London. Did you manage to talk to Bruce Banner>>>????? yet?');
    }
  
    //  Description     : Test a string containing 3 x @mentions
    @isTest static void getUserNameMentions_Test_04()	
	{
        getUserNameMentions(3, 'Hey @Tony Stark, this is @Pepper Potts! from London. Did you manage to talk to @Bruce Banner>>>????? yet?');
    }

    /********************************************************************************************************** 
        Method to test  : REST_RES_Utils.splitByMentions()
        Parameters	    : @param strFeed            The string to parse for @mentions
                          @param lstMentions        List of Users to match against
                          @param lstExpectedReturn  List of the expected returned pieces of String elements
        Returns         : List<String> 
        Expected Output : (1) Size of returned list is [lstMentions.size()]
                          (2) The returned list contains the expected pieces
    ***********************************************************************************************************/
    public static void splitByMentions(String strFeed, List<String> lstMentions, List<String> lstExpectedReturn) 	
	{              
        List<String> lstPieces = REST_RES_Utils.splitByMentions(lstMentions, strFeed);

        //Assert (1)
        System.assertEquals(lstExpectedReturn.size(), lstPieces.size());

        Integer x = 0;
        for (String strExpectedPiece : lstExpectedReturn) 
        {
            //Assert (2)
            System.assertEquals(strExpectedPiece, lstPieces.get(x));
            x++;
        }
    }

    //  Description     : Test a string containing zero @mentions
    @isTest static void splitByMentions_Test_01() 	
	{
        String strFeed = 'Hey Bruce Wayne, this is Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>();
        List<String> lstExpectedReturn =  new List<String>();
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 1 x @mention
    @isTest static void splitByMentions_Test_02()	
	{
        String strFeed = 'Hey @Bruce Wayne, this is Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Bruce Wayne'};
        List<String> lstExpectedReturn =  new List<String>{'Hey ', ', this is Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 2 x @mention
    @isTest static void splitByMentions_Test_03()	
	{
        String strFeed = 'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Bruce Wayne', 'Hank McCoy'};
        List<String> lstExpectedReturn =  new List<String>{'Hey ', ', this is ', '! from London. Did you manage to talk to Sally Gunnal>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 3 x @mention
    @isTest static void splitByMentions_Test_04()	
	{
        String strFeed = 'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to @Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Bruce Wayne', 'Hank McCoy', 'Sally Gunnal'};
        List<String> lstExpectedReturn =  new List<String>{'Hey ', ', this is ', '! from London. Did you manage to talk to ', '>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 3 x @mention, but only 2 x @mentions are mentioned in the list   
    @isTest static void splitByMentions_Test_05()	
	{
        String strFeed = 'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to @Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Bruce Wayne', 'Sally Gunnal'};
        List<String> lstExpectedReturn =  new List<String>{'Hey ', ', this is @Hank McCoy! from London. Did you manage to talk to ', '>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 3 x @mention, but only 1 x @mentions are mentioned in the list
    @isTest static void splitByMentions_Test_06()
	{
        String strFeed = 'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to @Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Sally Gunnal'};
        List<String> lstExpectedReturn =  new List<String>{'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to ', '>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 3 x @mention, but only 1 x @mentions are mentioned in the list
    @isTest static void splitByMentions_Test_07()
	{
        String strFeed = 'Hey @Bruce Wayne, this is @Hank McCoy! from London. Did you manage to talk to @Sally Gunnal>>>????? yet?';
        List<String> lstMentions = new List<String>{'Bruce Wayne'};
        List<String> lstExpectedReturn =  new List<String>{'Hey ', ', this is @Hank McCoy! from London. Did you manage to talk to @Sally Gunnal>>>????? yet?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    //  Description     : Test a string containing 3 x @mention at the beginning of the post, with 3 x @mentions are mentioned in the list
    @isTest static void splitByMentions_Test_08()	
	{
        String strFeed = '@Bruce Wayne @Hank McCoy @Sally Gunnal Testing beginning?';
        List<String> lstMentions = new List<String>{'Bruce Wayne', 'Hank McCoy', 'Sally Gunnal'};
        List<String> lstExpectedReturn =  new List<String>{' ', ' ', ' ', ' Testing beginning?'};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }
  
    //  Description     : Test a string containing 3 x @mention at the end of the post, with 3 x @mentions are mentioned in the list
    @isTest static void splitByMentions_Test_09()	
	{
        String strFeed = 'Testing the end@Bruce Wayne @Hank McCoy @Sally Gunnal';
        List<String> lstMentions = new List<String>{'Bruce Wayne', 'Hank McCoy', 'Sally Gunnal'};
        List<String> lstExpectedReturn =  new List<String>{'Testing the end', ' ', ' '};
        splitByMentions(strFeed, lstMentions, lstExpectedReturn);
    }

    /********************************************************************************************************** 
        HELPER METHODS 
    ***********************************************************************************************************/
    public static msgREST_REQ_CrossOrgCollaboration getCrossOrgCollabAgainstGhostUsers(Integer intCount, String strUserNamePostFix, Boolean blnComment, Boolean blnEmptyExternalNumbers)
    {
        strUserNamePostFix = '%' + strUserNamePostFix;
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = new msgREST_REQ_CrossOrgCollaboration();

        for(Integer x = 0; x < intCount; x++)
        {
            //get Ghost Users
            List<User> lstUser = [SELECT  id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name 
                                 FROM     User 
                                 WHERE    isActive = true
                                 AND      Username LIKE :strUserNamePostFix];     

             msgREST_REQ_COMP_FeedItem objFeedItem  = new msgREST_REQ_COMP_FeedItem();
            objFeedItem.body = 'Some Text ' + x;

            objFeedItem.firstName = lstUser.get(x).Firstname;
            objFeedItem.lastName = lstUser.get(x).Lastname;
            objFeedItem.alias = lstUser.get(x).Alias;
            objFeedItem.isComment = blnComment;

            objFeedItem.internalFeedItemId = generateRandomId();
            objFeedItem.internalRecordId = generateRandomId();
            objFeedItem.internalUserId = generateRandomId();

            //objFeedItem.externalFeedItemId  = ( blnEmptyExternalNumbers ? '' : generateRandomId());
            //objFeedItem.externalRecordId    = ( blnEmptyExternalNumbers ? '' : generateRandomId());
            objFeedItem.externalUserId      = ( blnEmptyExternalNumbers ? '' : String.valueOf(lstUser.get(x).id));

    
            msgCrossOrgCollab.FeedItems.add(objFeedItem);
        }
        return msgCrossOrgCollab;
    }

    public static String getProfileId() 	
	{   
        //get/set Profile ID
        String strProfileId = [SELECT id FROM Profile WHERE Name = 'Chatter Free User'].id;
        If (String.isBlank(strProfileId)) {System.assertEquals('Error', 'Error fetchinig Chatter Free User Profile');}
        return strProfileId;
    }
    
    public static Map<String, User> getUsersByNameUserNamesEndsWith(String strUserNameLike)
    {
        strUserNameLike = '%' + strUserNameLike;

        Map<String, User> mapUser = new Map<String, User>(); 
        List<User> lstUser = [SELECT  id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name 
                             FROM     User 
                             WHERE    isActive = true
                             AND      Username LIKE :strUserNameLike];     
        for (User objUser : lstUser) 
        {
            mapUser.put(objUser.Name.toLowerCase(), objUser);
        }  
        return mapUser;
    }

    public static Map<String, User> getUsersByUserNameUserNamesEndsWith(String strUserNameLike)
    {
        Map<String, User> mapUser = new Map<String, User>(); 
        If (strUserNameLike == '') {return mapUser;}

        strUserNameLike = '%' + strUserNameLike;

        List<User> lstUser = [SELECT  id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name 
                             FROM     User 
                             WHERE    isActive = true
                             AND      Username LIKE :strUserNameLike];     
        for (User objUser : lstUser) 
        {
            mapUser.put(objUser.Username, objUser);
        }  
        return mapUser;
    }

    public static User createUser(String strFirstname, String strLastname, String strAlias, String strEmailPostFix, String strProfile)
    {
        User objUser = new User(ProfileId = strProfile
                                ,Firstname = strFirstname
                                ,Lastname = strLastname
                                ,Email = strFirstname + '.' + strLastname + strEmailPostFix
                                ,Alias = strAlias
                                ,CommunityNickname = strAlias + '.Chatter.Free'
                                ,LocaleSidKey = 'en_US'
                                ,EmailEncodingKey = 'ISO-8859-1'
                                ,LanguageLocaleKey = 'en_US'
                                ,TimeZoneSidKey = 'GMT');
        objUser.Username = strAlias.toLowerCase() + strEmailPostFix;
        return objUser;
    }

    /**********************************************************************************************************   
        Description     : Generates a random SF friendly Id (18 chars long: <NNNNLNNNNNNLLLLLLL>)
        Returns         : String        An 18 chars SF friendly Id
    ***********************************************************************************************************/
    public static String generateRandomId() 	
	{
        String ret = '';
        Integer intNum = Integer.valueof((Math.random() * 1000));
        ret += String.valueOf(intNum).leftPad(4, '0');
        ret += generateRandomString(1);
        intNum = Integer.valueof((Math.random() * 100000));
        ret += String.valueOf(intNum).leftPad(6, '0');
        ret += generateRandomString(7);
        return ret;
    }
    /**********************************************************************************************************   
        Description     : Generates a random letter sequence for the given lengthen (mixture of upper and lower case) 
        Parameters	    : @param len    Desired length of random string
        Returns         : String        The random letter sequence
    ***********************************************************************************************************/
    public static String generateRandomString(Integer len) 
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) 
        {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    public static msgREST_REQ_CrossOrgCollaboration createCrossOrgCollabPost(Integer intNum, Boolean blnComment, String strEvent) 	
	{
        List<SObject> lstFeed = new List<SObject>();
        
        if (blnComment)
        {
            lstFeed = [SELECT id FROM FeedComment];
        }
        else
        {
            lstFeed = [SELECT id FROM FeedItem];
        }

        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = new msgREST_REQ_CrossOrgCollaboration();
        List<msgREST_REQ_COMP_FeedItem> lstFeedItems= new List<msgREST_REQ_COMP_FeedItem> ();

        try 
        {
            //create messages
            for (Integer x = 0; x < intNum; x++)
            {
                msgREST_REQ_COMP_FeedItem msgFeedItem = new msgREST_REQ_COMP_FeedItem();
                msgFeedItem.body = 'Comment ' + x;
                msgFeedItem.internalUserId = generateRandomId() ;
                msgFeedItem.firstName = 'Firstname';
                msgFeedItem.lastName = 'Lastname' ;
                msgFeedItem.alias = 'qwer' ;
                msgFeedItem.isComment = blnComment;
                msgFeedItem.internalFeedItemId = generateRandomId() ;
                msgFeedItem.internalRecordId = generateRandomId() ;
                msgFeedItem.success = false;
                msgFeedItem.event =strEvent ;

                //filled in by destination system
                msgFeedItem.externalFeedItemId = lstFeed.get(x).id;
                msgFeedItem.externalUserId = generateRandomId() ;
                msgFeedItem.externalRecordId = generateRandomId() ;
                lstFeedItems.add(msgFeedItem);
            }
            msgCrossOrgCollab.FeedItems = lstFeedItems;
            msgCrossOrgCollab.SourceOrg = 'OneForce';
        }
        catch (Exception ex) 
        {
            System.debug('############ ERROR at: [sendCustomComments()]' );
        }  
        return msgCrossOrgCollab;
    }
}