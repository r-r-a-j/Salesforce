/**********************************************************************************************************  
Pre-Requistes   : **** If on OneForce Org, you must disable "FeedItemTrigger" from Set up, else this test will fail ****
NAME			:	wsREST_RES_CrossOrgCollaborationTest 
DESCRIPTION 	:	Test Class. The ConnectAPI/Chatter Apex requires the test class that uses it:
                        i)  has the annotation (SeeAllData=true)
                        ii) does NOT use the @TestSetup annotation
DATE			:	July 2020
AUTHOUR			:	Ravi Raj, Salesforce Snr Program Architect

HISTORY

VERSION  	AUTHOR   	DATE  		DESCRIPTIOM    
1.0    		Ravi Raj  	July 2020	Initial Release
***********************************************************************************************************/
@isTest(SeeAllData=true)
public class wsREST_RES_CrossOrgCollaboration_Test 
{
    public static String strURI = '/services/apexrest/CrossOrgCollaboration';
    //public static String strURI = 'https://ihgddoeurope--DevProRavi.cs85.my.salesforce.com/services/apexrest/CrossOrgCollaboration';
    public static final String strPOST_FIX = '@XOrgCollab.com';
    
    /**********************************************************************************************************   
        Description     : Prepares the HTTP request object, calls addFeedItem() and examines the results.
        Parameters	    :   @param strMethod          HTTP verb
                            @param msgCrossOrgCollab  The payload to send
        Returns         : void
    ***********************************************************************************************************/
    public static void callAddFeedItem(String strMethod, msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab) 	
	{
        strURI = URL.getOrgDomainUrl().toExternalForm() + strURI;
        List<String> lstParams = new List<String>(); //split any params by "|", as needed
        Integer intCount = msgCrossOrgCollab.FeedItems.size();

        //conert payload into JSON and prepare the Request objects needed for REST requests
        String strReqBody = JSON.serialize(msgCrossOrgCollab);
        RestRequest request = wsREST_RES_CrossOrgCollaboration_Test.getRequest('POST', lstParams, strReqBody, wsREST_RES_CrossOrgCollaboration_Test.strURI);
        
        //call test method
        msgREST_REQ_CrossOrgCollaboration response = wsREST_RES_CrossOrgCollaboration.addFeedItem();

        //ensure the same number of elements going out as coming back in
        System.assertEquals(intCount, response.FeedItems.size());

        //loop the returned values
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : response.FeedItems) 
        {
           // System.assertEquals(true, msgFeedItem.success);
            System.assertNotEquals('', msgFeedItem.externalFeedItemId);

            //look to see if the record exists
            List<FeedItem> lstFeedItems = [SELECT id FROM FeedItem WHERE id = :msgFeedItem.externalFeedItemId];
            //System.assertEquals(1, lstFeedItems.size());

            //Ensure multiple user are not created
            String strUserName = msgFeedItem.externalUserId + msgFeedItem.Alias + strPOST_FIX; 
            List<User> lstUser = [SELECT id, name FROM User WHERE Username = :strUserName];
            //System.assertEquals(1, lstUser.size());
        }
    }

    /**********************************************************************************************************   
        Description     : Prepares the request object
        Parameters	    :   @param intCount       The number of msgREST_REQ_COMP_FeedItem to prepare
                            @param blnUserKnown   Whether to commit the user to the DB or not
                            @param lstFeedItem    List of feed item payloads
        Returns         : void
    ***********************************************************************************************************/
    public static void prepareRequest(Integer intCount, Boolean blnUserKnown, List<String> lstFeedItem) 	
	{ 
        String strFeedItem = '';
        String strRandId = generateRandomId();
        User objUser = createUser(strRandId, 'Scott', 'Summers', 'SSummers', strPOST_FIX, blnUserKnown);
 
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = new msgREST_REQ_CrossOrgCollaboration();

        for (Integer x = 0; x < intCount; x++)
        {
            //insert Feed Item if supplied
            if ((lstFeedItem == null) || (x > lstFeedItem.size()))
            { 
                strFeedItem = 'POST ' + x; 
            }
            else 
            { 
                strFeedItem = lstFeedItem.get(x); 
            }

            msgREST_REQ_COMP_FeedItem objFeedItem = getFeedItem(false, strFeedItem , objUser);
            objFeedItem.externalUserId = strRandId;
            msgCrossOrgCollab.FeedItems.add(objFeedItem);
        }
        callAddFeedItem('POST', msgCrossOrgCollab);
    }

    /**********************************************************************************************************   
        FeedItems   :      1
        blnComment         N
        User            Unknown
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithUnknownUser_Test_01() { prepareRequest(1, false, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2
        blnComment        N       N
        User            Unknown Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithUnknownUser_Test_02() { prepareRequest(2, false, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3
        blnComment        N       N       N
        User           Unknown   Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithUnknownUser_Test_03() 	{ prepareRequest(3, false, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3       4
        blnComment        N       N       N       N
        User           Unknown   Known   Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithUnknownUser_Test_04() 	{ prepareRequest(4, false, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3       4       5
        blnComment        N       N       N       N       N
        User           Unknown   Known   Known   Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithUnknownUser_Test_05() 	{ prepareRequest(5, false, null); }

    /**********************************************************************************************************   
        FeedItems   :     1         
        blnComment        N         
        User            Known     
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithKnownUser_Test_01() 	{ prepareRequest(1, true, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2
        blnComment        N       N
        User            Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithKnownUser_Test_02()    { prepareRequest(2, true, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3
        blnComment        N       N       N
        User           Known    Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithKnownUser_Test_03() 	{ prepareRequest(3, true, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3       4
        blnComment        N       N       N       N
        User           Known    Known   Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithKnownUser_Test_04() 	{ prepareRequest(4, true, null); }

    /**********************************************************************************************************   
        FeedItems   :     1       2       3       4       5
        blnComment        N       N       N       N       N
        User           Known    Known   Known   Known   Known
    ***********************************************************************************************************/
    @isTest static void addFeedItem_BeginWithKnownUser_Test_05() 	{ prepareRequest(5, true, null); } 

    /**********************************************************************************************************
        1 x FeedItem, 1 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_01() 	        { prepareRequest(1, true, getAtMentionTextWithRealUsers(1, 1)); } 

    /**********************************************************************************************************
        1 x FeedItem, 2 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_02() 	        { prepareRequest(1, true, getAtMentionTextWithRealUsers(1, 2)); } 

    /**********************************************************************************************************
        1 x FeedItem, 3 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_03() 	        { prepareRequest(1, true, getAtMentionTextWithRealUsers(1, 3)); } 

    /**********************************************************************************************************
        1 x FeedItem, 4 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_04() 	        { prepareRequest(1, true, getAtMentionTextWithRealUsers(1, 4)); } 

    /**********************************************************************************************************
        1 x FeedItem, 5 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_05() 	        { prepareRequest(1, true, getAtMentionTextWithRealUsers(1, 5)); } 

    /**********************************************************************************************************
        5 x FeedItem, 1 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_06() 	        { prepareRequest(5, true, getAtMentionTextWithRealUsers(5, 1)); } 

    /**********************************************************************************************************
        5 x FeedItem, 2 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_07() 	        { prepareRequest(5, true, getAtMentionTextWithRealUsers(5, 2)); } 

    /**********************************************************************************************************
        5 x FeedItem, 3 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_08() 	        { prepareRequest(5, true, getAtMentionTextWithRealUsers(5, 3)); } 

    /**********************************************************************************************************
        5 x FeedItem, 4 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_09() 	        { prepareRequest(5, true, getAtMentionTextWithRealUsers(5, 4)); } 

    /**********************************************************************************************************
        5 x FeedItem, 5 x @Mention   
    ***********************************************************************************************************/
    @isTest static void addFeedItem_AtMentions_Test_10() 	        { prepareRequest(5, true, getAtMentionTextWithRealUsers(5, 5)); } 

    /**********************************************************************************************************   
        Description     : Constructs string(s) with N number of @mentioned (real) users within it
        Parameters	    :   @param intRecords         The number of Strings to create
                            @param intNoOfMentions    The number of @mentions to create in each String
        Returns         : List<String>                  List of String payloads, containing @mentions
    ***********************************************************************************************************/
    public static List<String> getAtMentionTextWithRealUsers(Integer intRecords, Integer intNoOfMentions)
    {
        List<String> lstFeedItem = new List<String>();

        List<User> lstUsers = [SELECT name FROM User WHERE isActive = true AND (NOT username like '%@xorgcollab.com')];
        
        If (lstUsers.size() == 0) { lstUsers = createFakeUsers(); } 

        for (Integer j = 0; j < intRecords; j++)
        {
            String strFeedItem = '';
            for (Integer k = 0; k < intNoOfMentions; k++)
            {
                strFeedItem += ' Random text @' + lstUsers.get(k).name;
            }
            lstFeedItem.add(strFeedItem);
        }
        return lstFeedItem;
    }

    /**********************************************************************************************************   
        Description     : Constructs an individual msgREST_REQ_COMP_FeedItem
        Parameters	    :   @param blnComment           Whether *this* msgREST_REQ_COMP_FeedItem is a Comment 
                            @param strBody              The payload
                            @param objUser              The User
        Returns         : msgREST_REQ_COMP_FeedItem     The individual msgREST_REQ_COMP_FeedItem
    ***********************************************************************************************************/
    public static msgREST_REQ_COMP_FeedItem getFeedItem(Boolean blnComment, String strBody, User objUser)
    {
        //Get User if not supplied
        if (objUser == null)
        {
            List<User> lstUser = [SELECT id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name FROM User WHERE isActive = true];  
            //get random number from 0 up to the size of the User list 
            Integer x = Integer.valueof((Math.random() * lstUser.size()));
            objUser = lstUser.get(x);
        }

        //get Project
        Project__c objProject = [SELECT id FROM Project__c LIMIT 1];  

        if (objProject == null) {objProject = new Project__c();}

        msgREST_REQ_COMP_FeedItem objFeedItem = new msgREST_REQ_COMP_FeedItem();
        objFeedItem.body = strBody;                   //String body
        objFeedItem.internalRecordId = objProject.id;             //String projectId,
        objFeedItem.firstName = objUser.Firstname;         //String firstName
        objFeedItem.lastName = objUser.Lastname ;         //String lastName
        objFeedItem.alias = objUser.Alias;             //String alias
        objFeedItem.externalUserId = '0123456789' ;             //String externalUserId
        objFeedItem.isComment = blnComment ;               //Boolean isComment

        //objFeedItem.internalUserId = objUser.id;
        return objFeedItem;
    }

    /**********************************************************************************************************   
        Description     : Constructs a User Object
        Parameters	    : @param strExtId       The external User Id
                          @param strFirstname   FirstName
                          @param strLastname    Lastname
                          @param strAlias       Alias
                          @param strPostFix     The postfix (used for email and construction of Username)
                          @param blnCommit      Whether to commit the User to the DB or not
        Returns         : User     The User Object
    ***********************************************************************************************************/
    public static User createUser(String strExtId, String strFirstname, String strLastname, String strAlias, String strPostFix, Boolean blnCommit)
    {
        User objUser; 
        try 
        {
            String strProfile = (String) [SELECT id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1].id;
            System.assertNotEquals('', strProfile);
            
            objUser = new User(ProfileId = strProfile
                                    ,Firstname = strFirstname
                                    ,Lastname = strLastname
                                    ,Email = strFirstname + '.' + strLastname + strPostFix
                                    ,Alias = strAlias
                                    ,CommunityNickname = strAlias + '.Chatter.Free'
                                    ,LocaleSidKey = 'en_US'
                                    ,EmailEncodingKey = 'ISO-8859-1'
                                    ,LanguageLocaleKey = 'en_US'
                                    ,TimeZoneSidKey = 'GMT');

            //The ghost users have a Username made up of: GOLS.User.id + GOLS.User.Alias + strPostFix
            //This should be unique enough for this population of users
            objUser.Username = strExtId.toLowerCase() + strAlias.toLowerCase() + strPostFix;

            if (blnCommit) { insert objUser; }
        }
        catch (Exception ex) 
        {
            objUser = null;
        }
        return objUser;
    }

    /**********************************************************************************************************   
        Description     : Creates fake User. Usually, this would form part of the @testSetup, but we cannot use this
                          with SeeAllData
        Returns         : List<User>    List of Users
    ***********************************************************************************************************/
    public static List<User> createFakeUsers()
    {
        createUser('', 'Tony', 'Stark', 'TStark', '@UnitTestingIsGreat.com', true);
        createUser('', 'Pepper', 'Potts', 'PPotts', '@UnitTestingIsGreat.com', true);
        createUser('', 'Bruce', 'Banner', 'BBanner', '@UnitTestingIsGreat.com', true);
        createUser('', 'Nick', 'Fury', 'NFury','@UnitTestingIsGreat.com', true);
        createUser('', 'Original', 'Poster', 'OPoster', '@UnitTestingIsGreat.com', true);
        createUser('', 'Eric', 'Lehnsherr', 'ELehnshe', '@UnitTestingIsGreat.com', true);
        createUser('', 'Charles', 'Xavier', 'CXavier', '@UnitTestingIsGreat.com', true);
        createUser('', 'Eric', 'Bischoff', 'EBischo', '@UnitTestingIsGreat.com', true);
        createUser('', 'Hulk', 'Hogan', 'HHogan', '@UnitTestingIsGreat.com', true);
        createUser('', 'Ultimate', 'Warrior', 'UWarrio', '@UnitTestingIsGreat.com', true);
        return [SELECT name FROM User WHERE isActive = true];
    }

    /**********************************************************************************************************   
        Description     : Prepares the HTTP request details
        Parameters	    : @param strMethod   HTTP verbs
                          @param lstParams   List of parameters
                          @param strReqBody  The request body/payload
                          @param strURI      The URI to send the request to
        Returns         : RestRequest        A Request object
    ***********************************************************************************************************/
    public static RestRequest getRequest(String strMethod, List<String> lstParams, String strReqBody, String strURI) 	
	{
        // Set up a test request
        RestRequest request = new RestRequest();

        // Set request properties
        request.requestUri = strURI;
        request.httpMethod = strMethod;
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(strReqBody);

        // Set other properties, such as parameters
        for (String strParam :lstParams)
        {   
            //params are stored in the list as "value1|value2" (split on "|")
            request.params.put(strParam.split('\\|')[0], strParam.split('\\|')[1]);
        }

        // Finally, assign the request to RestContext (if used)
        RestContext.request = request;

        return request;
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

    @isTest static void updateFeed_Test_01() 	
	{
        Integer intCount = 1;
        Map<String, User> mapUsersKeyByName = new Map<String, User>();	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, false, 'NEW') ;

        //call test method
        msgREST_REQ_CrossOrgCollaboration response = wsREST_RES_CrossOrgCollaboration.updateFeed(msgCrossOrgCollab, mapUsersKeyByName);
    }
    @isTest static void updateFeed_Test_02() 	
	{
        Integer intCount = 1;
        Map<String, User> mapUsersKeyByName = new Map<String, User>();	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, true, 'NEW') ;

        //call test method
        msgREST_REQ_CrossOrgCollaboration response = wsREST_RES_CrossOrgCollaboration.updateFeed(msgCrossOrgCollab, mapUsersKeyByName);
    }

    @isTest static void updateFeed_Test_03() 	
	{
        Integer intCount = 1;
        Map<String, User> mapUsersKeyByName = new Map<String, User>();	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, true, 'EDIT') ;

        //call test method
        msgREST_REQ_CrossOrgCollaboration response = wsREST_RES_CrossOrgCollaboration.updateFeed(msgCrossOrgCollab, mapUsersKeyByName);
    }

    @isTest static void updateFeed_Test_04() 	
	{
        Integer intCount = 1;
        Map<String, User> mapUsersKeyByName = getUsersByNameUser();	
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = createCrossOrgCollabPost(intCount, true, 'EDIT') ;
        msgCrossOrgCollab.FeedItems.get(0).body = '@Ravi Raj was here';
        //call test method
        msgREST_REQ_CrossOrgCollaboration response = wsREST_RES_CrossOrgCollaboration.updateFeed(msgCrossOrgCollab, mapUsersKeyByName);
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

    public static Map<String, User> getUsersByNameUser()
    {
        Map<String, User> mapUser = new Map<String, User>(); 
        List<User> lstUser = [SELECT  id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name 
                             FROM     User 
                             WHERE    isActive = true];     
        for (User objUser : lstUser) 
        {
            mapUser.put(objUser.Name.toLowerCase(), objUser);
        }  
        return mapUser;
    }
}