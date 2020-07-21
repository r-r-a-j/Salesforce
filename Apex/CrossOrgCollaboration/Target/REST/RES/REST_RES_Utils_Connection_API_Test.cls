/**********************************************************************************************************  
NAME			:	REST_RES_UtilsConnectAPITest 
DESCRIPTION 	:	Test Class.
                    ConnectAPI requires the test class that uses it:
                        i)  has the annotation (SeeAllData=true)
                        ii) does NOT use the @TestSetup annotation
                    For these reasons, it has been necessary to move the testing of the method REST_RES_Utils.updateFeed()
                    to this class
DATE			:	July 2020
AUTHOUR			:	Ravi Raj, Salesforce Snr Program Architect

HISTORY

VERSION  	AUTHOR   	DATE  		DESCRIPTIOM    
1.0    		Ravi Raj  	May 2020	Initial Release
***********************************************************************************************************/
@isTest(SeeAllData=true)

public class REST_RES_Utils_Connection_API_Test 
{ 
    public static void setup()
    { 
        //set up Users
        //get a known Profile that exists in the DB
        List<Profile> lstProfile = [SELECT id FROM Profile WHERE Name = 'Read Only'];
    
        List<User> lstUser = new List<User>();

        //add some more specific users
        lstUser.add(REST_RES_Utils_Test.createUser('Tony', 'Stark', 'TStark', '@xorgcollabmethions.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Pepper', 'Potts', 'PPotts', '@xorgcollabmethions.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Bruce', 'Banner', 'BBanner', '@xorgcollabmethions.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Nick', 'Fury', 'NFury', '@xorgcollabmethions.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Original', 'Poster', 'OPoster', '@originalposter.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Scott', 'Summers', 'SSummers', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Eric', 'Lehnsherr', 'ELehnshe', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('Charles', 'Xavier', 'CXavier', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));

        lstUser.add(REST_RES_Utils_Test.createUser('zScott', 'Summers', 'SSummerz', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('zEric', 'Lehnsherr', 'ELehnshz', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('zCharles', 'Xavier', 'CXaviez', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));

        lstUser.add(REST_RES_Utils_Test.createUser('xScott', 'Summers', 'SSummerx', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('xEric', 'Lehnsherr', 'ELehnshx', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));
        lstUser.add(REST_RES_Utils_Test.createUser('xCharles', 'Xavier', 'CXaviex', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));

        lstUser.add(REST_RES_Utils_Test.createUser('yScott', 'Summers', 'SSummery', '@updateusertest.com', String.valueOf(lstProfile.get(0).id)));

        insert lstUser;
    }

    /**********************************************************************************************************   
    Description     : Creates 10 x new Feed Post against 10 x discrete Projects
    ***********************************************************************************************************/
    public static void  helperUpdateFeed(Integer intCount, Boolean blnComment) 	
	{
        String strFeed;
        String strUniqueChar;
        List<String> lstMentions;
        List<String> lstPieces;
        
        //set up Users
        setup();
                                                                                                                //(Integer intCount, String strUserNamePostFix, Boolean blnComment, Boolean blnEmptyExternalNumbers)
        msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab = REST_RES_Utils_Test.getCrossOrgCollabAgainstGhostUsers(intCount, '%@updateusertest.com', blnComment, true);

        System.assertNotEquals(0, msgCrossOrgCollab.FeedItems.size());
        
        Integer x = 1;
        for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
        {
            switch on x
            {
                when 1
                {
                    //1 x @mention
                    strFeed = 'Hey @Scott Summers, this is Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?';
                    lstMentions = new List<String>{'Scott Summers'};
                    lstPieces =  new List<String>{'Hey ', ', this is Hank McCoy! from London. Did you manage to talk to Sally Gunnal>>>????? yet?'};
                }
                when 2
                {
                    //2 x @mention
                    strFeed = 'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to Sally Gunnal>>>????? yet?';
                    lstMentions = new List<String>{'Scott Summers', 'Eric Lehnsherr'};
                    lstPieces =  new List<String>{'Hey ', ', this is ','! from London. Did you manage to talk to Sally Gunnal>>>????? yet?'};
                }
                when 3
                {
                    //3 x @mention
                    strFeed = 'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to @Charles Xavier>>>????? yet?';
                    lstMentions = new List<String>{'Scott Summers', 'Eric Lehnsherr', 'Charles Xavier'};
                    lstPieces =  new List<String>{'Hey ', ', this is ','! from London. Did you manage to talk ', '>>>????? yet?'};
                }
                when 4
                {
                    //3 x @mention, but only 1 x @mentions are mentioned in the list
                    strFeed = 'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to @Charles Xavier>>>????? yet?';
                    lstMentions = new List<String>{'Charles Xavier'};
                    lstPieces =  new List<String>{'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to ', '>>>????? yet?'};
                }
                when 5
                {
                    //3 x @mention, but only 2 x @mentions are mentioned in the list
                    strFeed = 'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to @Charles Xavier>>>????? yet?';
                    lstMentions = new List<String>{'Charles Xavier', 'Eric Lehnsherr'};
                    lstPieces =  new List<String>{'Hey @Scott Summers, this is ', '! from London. Did you manage to talk to ', '>>>????? yet?'};
                }
                when 6
                {
                    //3 x @mention, but only 2 x @mentions are mentioned in the list (different positions)
                    strFeed = 'Hey @Scott Summers, this is @Eric Lehnsherr! from London. Did you manage to talk to @Charles Xavier>>>????? yet?';
                    lstMentions = new List<String>{'Charles Xavier', 'Scott Summers'};
                    lstPieces =  new List<String>{'Hey ', ', this is @Eric Lehnsherr! from London. Did you manage to talk to ', '>>>????? yet?'};
                }  
                when 7
                {
                    //3 x @mention at the beginning of the post, with 3 x @mentions are mentioned in the list
                    strFeed = '@Scott Summers @Eric Lehnsherr @Charles Xavier Testing beginning?';
                    lstMentions = new List<String>{'Scott Summers', 'Eric Lehnsherr', 'Charles Xavier'};
                    lstPieces =  new List<String>{' ', ' ', ' ', ' Testing beginning?'};
                }   
                when 8
                {
                    //3 x @mention at the beginning of the post, with 2 x @mentions are mentioned in the list
                    strFeed = '@Scott Summers @Eric Lehnsherr @Charles Xavier Testing beginning?';
                    lstMentions = new List<String>{'Scott Summers', 'Charles Xavier'};
                    lstPieces =  new List<String>{' ', ' @Eric Lehnsherr ', ' Testing beginning?'};
                }     
                when 9
                {
                    //3 x @mention at the beginning of the post, with 2 x @mentions are mentioned in the list (different positions)
                    strFeed = '@Scott Summers @Eric Lehnsherr @Charles Xavier Testing beginning?';
                    lstMentions = new List<String>{'Eric Lehnsherr', 'Charles Xavier'};
                    lstPieces =  new List<String>{'@Scott Summers ', ' ', ' Testing beginning?'};
                } 
                when 10
                {
                    //3 x @mention at the beginning of the post, with 2 x @mentions are mentioned in the list (different positions)
                    strFeed = '@Scott Summers @Eric Lehnsherr @Charles Xavier Testing beginning?';
                    lstMentions = new List<String>{'Eric Lehnsherr', 'Scott Summers'};
                    lstPieces =  new List<String>{' ', ' ', ' @Charles Xavier Testing beginning?'};
                }  
                when else
                {
                    System.assert(false); 
                }
            }
            helperUpdateFeed(lstMentions, lstPieces, strFeed, msgFeedItem, blnComment);
            x++;
        }  
    }

    public static void helperUpdateFeed(List<String> lstMentions, List<String> lstPieces, String strFeed, msgREST_REQ_COMP_FeedItem msgFeedItem, Boolean blnComment) 	
	{
        Map<String, User> mapUsersKeyByUsername = new Map<String, User>();
        String strProfile = [SELECT id FROM Profile WHERE Name = 'Read Only' LIMIT 1].id;       System.assertNotEquals('', strProfile);

        //create project
        Project__c objProject = new Project__c();
        insert objProject;

        //get original Poster
        User objUser = [SELECT id, name FROM User WHERE name = 'Original Poster' limit 1];      System.assertNotEquals(null, objUser);

        //create original FeedItem
        FeedItem objFeedItem = new FeedItem();
        objFeedItem.ParentId = String.valueOf(objProject.id);
        objFeedItem.CreatedById = String.valueOf(objUser.id);
        objFeedItem.Body = strFeed;
        insert objFeedItem;

        if (blnComment)
        {
            //create a sub Comment
            FeedComment objComment = new FeedComment();
            objComment.CommentBody = strFeed;
            objComment.FeedItemId = String.valueOf(objFeedItem.id);
            objComment.CreatedById = String.valueOf(objUser.id);
            insert objComment;                                                                  System.assertNotEquals(null, objComment);

            //update the payload
            msgFeedItem.internalRecordId = '';
            msgFeedItem.externalFeedItemId = String.valueOf(objComment.id);
            msgFeedItem.isComment = true;
        }
        else
        {
            //update the payload
            msgFeedItem.internalRecordId = String.valueOf(objProject.id);
            msgFeedItem.externalFeedItemId = String.valueOf(objFeedItem.id);
            msgFeedItem.isComment = false;
        }
        //update common parts of the payload
        msgFeedItem.internalUserId = String.valueOf(objUser.id);
        msgFeedItem.body = strFeed + 'Updated';

        Integer x = 0;

        for (String strName: lstMentions)
        {
            //get user
            objUser = [SELECT id, name FROM User WHERE name = :strName limit 1];                System.assertNotEquals(null, objUser);

            //add User to Map
            mapUsersKeyByUsername.put(objUser.Name.toLowerCase(), objUser);
        }

        System.assertNotEquals(0, mapUsersKeyByUsername.size());

        msgREST_REQ_COMP_FeedItem msgFeedItemRet = REST_RES_Utils.updateFeed(lstMentions, msgFeedItem, lstPieces, mapUsersKeyByUsername);

        //System.assertNotEquals(null, msgFeedItemRet);

        System.assertEquals(strFeed + 'Updated', msgFeedItem.body); 

        System.assertEquals(null,  msgFeedItem.errorMessage);
        System.assertEquals(null, msgFeedItem.errorCode);
        System.assertEquals(true, msgFeedItem.success); 
        System.assertEquals(null, msgFeedItem.errorCode); 
    }

    @isTest 
    static void updateFeedPostTest1() 	
	{
        helperUpdateFeed(1, false);
    }

    @isTest 
    static void updateFeedPostTest2() 	
	{
        helperUpdateFeed(2, false);
    }

    @isTest 
    static void updateFeedPostTest3() 	
	{
        helperUpdateFeed(3, false);
    }

    @isTest 
    static void updateFeedPostTest4() 	
	{
        helperUpdateFeed(4, false);
    }

    @isTest 
    static void updateFeedPostTest5() 	
	{
        helperUpdateFeed(5, false);
    }

    @isTest 
    static void updateFeedPostTest6() 	
	{
        helperUpdateFeed(6, false);
    }

    @isTest 
    static void updateFeedPostTest7() 	
	{
        helperUpdateFeed(7, false);
    }

    @isTest 
    static void updateFeedPostTest8() 	
	{
        helperUpdateFeed(8, false);
    }

    @isTest 
    static void updateFeedPostTest9() 	
	{
        helperUpdateFeed(9, false);
    }
   
    @isTest 
    static void updateFeedPostTest10() 	
	{
        helperUpdateFeed(10, false);
    }
    
    @isTest 
    static void updateFeedCommentTest1() 	
	{
        helperUpdateFeed(1, true);
    }

    @isTest 
    static void updateFeedCommentTest2() 	
	{
        helperUpdateFeed(2, true);
    }

    @isTest 
    static void updateFeedCommentTest3() 	
	{
        helperUpdateFeed(3, true);
    }

    @isTest 
    static void updateFeedCommentTest4() 	
	{
        helperUpdateFeed(4, true);
    }

    @isTest 
    static void updateFeedCommentTest5() 	
	{
        helperUpdateFeed(5, true);
    }

    @isTest 
    static void updateFeedCommentTest6() 	
	{
        helperUpdateFeed(6, true);
    }

    @isTest 
    static void updateFeedCommentTest7() 	
	{
        helperUpdateFeed(7, true);
    }

    @isTest 
    static void updateFeedCommentTest8() 	
	{
        helperUpdateFeed(8, true);
    }

    @isTest 
    static void updateFeedCommentTest9() 	
	{
        helperUpdateFeed(9, true);
    }

    @isTest 
    static void updateFeedCommentTest10() 	
	{
        helperUpdateFeed(10, true);
    }
} 
