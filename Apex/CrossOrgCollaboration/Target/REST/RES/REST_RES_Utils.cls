public class REST_RES_Utils 
{
    public static final String strMENTION_REGEX = '@\\b[a-zA-Z]*\\s\\b[a-zA-Z]*'; 
    public static final String strSPLIT_TERM = 'xOrgCollab';
    public static final String strSPLIT_TERM_REGEX = '\\|\\b[' + REST_RES_Utils.strSPLIT_TERM +']*\\|';

    /**********************************************************************************************************     
        Purpose		: Gets the Profile ID of the Chatter Free Profile
        Parameters	: @param mapUser            Map of Users in the format of: [<Username>, <User>]
                    @param strUsernamePostfix The UserName post fix to match on for a specific user
        Returns		: String            The Profile ID of the Chatter Free Profile
        Throws 		: n/a
    ***********************************************************************************************************/
    public static String getChatterFreeProfileId(Map<String, User> mapUser, String strUsernamePostfix)
    {
        String strChatterFreeProfile = '';

        try 
        {
            if(mapUser.size() == 0)
            {
                //if map is empty, it means that no users exist that match the pattern.
                //Pull the Profile of the [Chatter Free User] for when creating new Users
                List<Profile> lstProfiles = [SELECT id FROM Profile WHERE Name = 'Chatter Free User'];

                if (lstProfiles.size() == 0) 
                { 
                    NoDataFoundException e = new NoDataFoundException();
                    e.setMessage('>>>> ERROR! Unable to find [Chatter Free User] Profile');
                    throw e;
                }
                strChatterFreeProfile = lstProfiles.get(0).id;
            }
            else
            {
                //get the first User's Profile ID that matches a specific pattern
                for (String strUserKey: mapUser.keySet())
                {
                    If(strUserKey.endsWithIgnoreCase(strUsernamePostfix))
                    {
                        strChatterFreeProfile = mapUser.get(strUserKey).ProfileId;
                        break;
                    }
                }
            }
        } 
        catch (Exception ex) 
        {
            strChatterFreeProfile = '';
            System.debug('>>>>>>>>>> ' + ex.getMessage());
        }
        return strChatterFreeProfile;
    }

    /**********************************************************************************************************     
        Purpose		: Returns a Map of active Users 
        Parameters	: @param mapUsersKeyByName  Passed by reference. 
                                                Map of Users in the format of: [<Username>, <User>]
                    @param strUsernamePostfix The UserName post fix to match on for a specific user
        Returns		: Map<String, User>         A map of Users, where the Map's key is the Users' Username
        Throws 		: n/a
    ***********************************************************************************************************/
    public static  Map<String, User> getUserMap(Map<String, User> mapUsersKeyByName, String strUserNamePostFix)
    {
        Map<String, User> mapUsersKeyByUsername = new Map<String, User>();

        try 
        {
            //Get all active Users 
            List<User> lstUsers = [SELECT   id, ProfileId, Firstname, Lastname, Username, Email, Alias, CommunityNickname, Name 
                                   FROM     User 
                                   WHERE    isActive = true
                                   ORDER BY createddate desc];

            for (User objUser : lstUsers)
            {
                if(objUser.Username.endsWithIgnoreCase(strUserNamePostFix))
                {
                    mapUsersKeyByUsername.put(objUser.Username, objUser);
                }
                else 
                {
                    mapUsersKeyByName.put(objUser.Name.toLowerCase(), objUser);
                } 
            }
        } 
        catch (Exception ex) 
        {
            System.debug('>>>>>>>>>> ' + ex.getMessage());
        }
        return mapUsersKeyByUsername;
    }

    /**********************************************************************************************************     
        Purpose		: Sets the correct Chatter Free/Ghost Users on each [msgREST_REQ_COMP_FeedItem]. 
                      Creates a Chatter Free User if doesn't exist.
        Parameters	: @param msgCrossOrgCollab      The Payload
                      @param strPostFix             Username postfix of all Chatter Free/Ghost Users 
                      @param strChatterFreeProfile  Chatter Free Profile ID
                      @param mapUsersKeyByUsername  Map of all existing Chatter Free/Ghost Users 
    ***********************************************************************************************************/
    public static String setFeedUsers(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab, String strPostFix, String strChatterFreeProfile, Map<String, User> mapUsersKeyByUsername)
    {
        String strRet = '';
        try 
        {
            System.debug('>>>>>>>>>>>> setFeedUsers - 001'); 
           //loop incoming FeedItem list
           for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
           {
                
               //The ghost users have a Username made up of: GOLS.User.id + GOLS.User.Alias + strPostFix
               //This should be unique enough for this population of users
               String strKey = msgFeedItem.internalUserId + msgFeedItem.alias + strPostFix;
               User objUser;

               System.debug('>>>>>>>>>>>> setFeedUsers - 002 :' + msgFeedItem.body + ' | strKey = ' + strKey); 
               If (mapUsersKeyByUsername.containsKey(strKey.toLowerCase()))
               {
                    System.debug('>>>>>>>>>>>> setFeedUsers - 003'); 
                   //User exists
                   objUser = mapUsersKeyByUsername.get(strKey.toLowerCase());
                   msgFeedItem.externalUserId = objUser.Id;
                   System.debug('>>>>>>>>>>>> setFeedUsers - 003a | msgFeedItem.externalUserId = ' + msgFeedItem.externalUserId);
               }
               else 
               {
                    System.debug('>>>>>>>>>>>> setFeedUsers - 004');
                   //User does not exists - create new (Chatter Free) user
                   //createUserChatterFree(String strFirstName, String strLastName, String strEmail, String strUserName,  String strProfileId)
                   objUser = REST_RES_Utils.createUserChatterFree(msgFeedItem.firstName
                                                                 ,msgFeedItem.lastName
                                                                 ,msgFeedItem.firstName + '.' + msgFeedItem.lastName + strPostFix
                                                                 ,strKey
                                                                 ,strChatterFreeProfile);
                    System.debug('>>>>>>>>>>>> setFeedUsers - 005 | objUser = ' + objUser);
                    if (objUser == null) {throw new NullPointerException();}

                   //add newly created User to Map list
                   mapUsersKeyByUsername.put(strKey.toLowerCase() ,objUser);
                   msgFeedItem.externalUserId = objUser.Id;
                   System.debug('>>>>>>>>>>>> setFeedUsers - 006 | msgFeedItem.externalUserId = ' + msgFeedItem.externalUserId);
               }  
               //store ID for return
               strRet += String.valueOf(objUser.Id) + '|';
           }
        } 
        catch (Exception ex) 
        {
            System.debug('>>>>>>>>>> ' + ex.getMessage());
            strRet = 'ERROR:' + ex.getMessage();
        }
        return strRet;
    }

    /**********************************************************************************************************     
        Purpose		: Creates a Chatter Free User
        Parameters	: @param strFirstName   First name of the User to be created
                      @param strLastName    Last  name of the User to be created
                      @param strEmail       Email of the User to be created
                      @param strUserName    Username of the User to be created
                      @param strProfileId   Profile ID of the User to be created
        Returns		: User  - The newly created user
        Throws 		: n/a
    ***********************************************************************************************************/
    public static User createUserChatterFree(String strFirstName, String strLastName, String strEmail, String strUserName,  String strProfileId)
    {
        User objUser = new User();

        try 
        {
            objUser.Firstname = strFirstName;
            objUser.Lastname = strLastName;
            objUser.Email = strEmail;
            objUser.Username = strUserName;
            //e.g.: "rraj" ; "nshah" ; "cdrye"
            String strName = strFirstName.left(1) + strLastName.left(4);
            objUser.Alias = strName;
            objUser.CommunityNickname = strFirstName + strLastName + '.Chatter.Free';
            objUser.ProfileId = strProfileId; 
            objUser.LocaleSidKey = 'en_US';
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'GMT';
            objUser.Title = 'GOLS User';
            insert objUser;      
        } 
        catch (Exception ex) 
        {
            System.debug('>>>>>>>>>> ' + ex.getMessage());
            objUser = null;
            DmlException e = new DmlException();
            e.setMessage('Trying to insert User: ' + strFirstName + ' , ' + strLastName + ' | ' + ex.getMessage());
            throw e;
        }

        return objUser;
    }

    /**********************************************************************************************************     
        Purpose		: Creates Chatter Feed Item(s)
        Parameters	: @param msgCrossOrgCollab  The entire payload from external system
        Returns		: msgREST_REQ_CrossOrgCollaboration
        Throws 		: n/a
    ***********************************************************************************************************/
    public static msgREST_REQ_CrossOrgCollaboration createChatterPost(msgREST_REQ_CrossOrgCollaboration msgCrossOrgCollab)
    {
        List<sObject> lstObjects = new List<sObject>();

        try 
        {
            //foreach incoming FeedItem message, create a corresponding FeedItem object (but don't commit to DB yet)
            for (msgREST_REQ_COMP_FeedItem msgFeedItem : msgCrossOrgCollab.FeedItems) 
            {
                //valid values before attempting to insert them
                if(checkValuesFormatting(msgFeedItem))
                {
                    try
                    {
                        //Comment or New Post
                        if(msgFeedItem.isComment)
                        {
                            FeedComment comment = new FeedComment();
                            comment.CommentBody = msgFeedItem.body;
                            comment.FeedItemId = msgFeedItem.externalRecordId;
                            comment.CreatedById = msgFeedItem.externalUserId; 
                            comment.IsRichText = true;
                            lstObjects.add(comment);
                        }
                        else
                        {                
                            FeedItem post = new FeedItem();
                            //set the [externalRecordId]. If this is populated, then the method will simply return the same value.
                            //If empty, it will fetch the corresponding value using [internalRecordId].
                            //Either way, it will populate the [externalRecordId] 
                            msgFeedItem.externalRecordId = getExternalRecordID(msgFeedItem.externalRecordId, msgFeedItem.internalRecordId);
                            post.ParentId = msgFeedItem.externalRecordId;
                            post.CreatedById = msgFeedItem.externalUserId;
                            post.Body = msgFeedItem.body;
                            post.IsRichText = true;
                            lstObjects.add(post);
                        }
                    }
                    catch(Exception ex)
                    {
                        //msgFeedItem.errorFields = lstFeilds;
                        msgFeedItem.errorMessage = ex.getMessage();
                        msgFeedItem.errorCode = 'GENERAL_EXCEPTION';
                        msgFeedItem.success = false;
                    }
                }
            }

            //if nothing to commit, exit grancefully
            If (lstObjects.size() > 0)
            {
                //attept to commit entire FeedItems to DB
                DataBase.SaveResult[] lstResults = Database.insert(lstObjects, false);

                Integer intCount = 0;

                //loop the commit attempt 
                for (DataBase.SaveResult sr : lstResults) 
                {
                    //Advance to the next FeedItem count that does NOT have its ErrorMessage value set
                    for (Integer x = intCount; x < msgCrossOrgCollab.FeedItems.size(); x++) 
                    {
                        If ((msgCrossOrgCollab.FeedItems.get(x).errorMessage == null) || (msgCrossOrgCollab.FeedItems.get(x).errorMessage == '')) 
                            { break; } 
                        else{ intCount++; }
                    }

                    if(sr.isSuccess())
                    {
                        //success, so store the results
                        msgCrossOrgCollab.FeedItems.get(intCount).externalFeedItemId = sr.getId();
                        msgCrossOrgCollab.FeedItems.get(intCount).success = true;
                    }
                    else 
                    {
                        //error, so obtain the errors statuses abd store
                        for (Database.Error err : sr.getErrors()) 
                        {
                            msgCrossOrgCollab.FeedItems.get(intCount).errorMessage += err.getMessage();
                            msgCrossOrgCollab.FeedItems.get(intCount).errorCode = String.valueOf(err.getStatusCode());
                            msgCrossOrgCollab.FeedItems.get(intCount).errorFields = err.getFields();
                        }
                    }
                    intCount++;
                }
            }
        } 
        catch (Exception ex) 
        {
            System.debug('>>>>>>>>>>> ERROR! ');
            msgCrossOrgCollab.FeedItems.get(0).errorCode += ' | Exception Thrown = ' + ex.getMessage();
        }
        return msgCrossOrgCollab;
    }

    /**********************************************************************************************************     
        Purpose		: In order to create a Feed Element, the msgREST_REQ_COMP_FeedItem.externalRecordId is needed.
                      If this is empty, then we must attempt to look this up using the msgREST_REQ_COMP_FeedItem.internalRecordId.
                      If neither exist, throw an exception.
        Parameters	: @param strPassedInExtRecordId     The value in msgREST_REQ_COMP_FeedItem.externalRecordId
                      @param strInternalRecordId        The value in msgREST_REQ_COMP_FeedItem.internalRecordId
        Returns		: String
        Throws 		: NoDataFoundException
    ***********************************************************************************************************/
    public static String getExternalRecordID(String strPassedInExtRecordId, String strInternalRecordId)
    {
        String strRet = strPassedInExtRecordId;

        if (String.isBlank(strRet))
        {
            //[externalRecordId] is empty so attempt to look it up from the [internalRecordId]
            strRet = [SELECT id FROM Project__c WHERE GOLS_Id__c = :strInternalRecordId LIMIT 1].id;
            
            //check the value again. If it's still blank, then explicitly throw an exception which will be caught
            //by the calling method 
            if (String.isBlank(strRet))
            {
                NoDataFoundException e = new NoDataFoundException();
                e.setMessage('>>>> ERROR! Unable to find External Record ID to attach to [getExternalRecordID()] - ' +
                             '[strInternalRecordId] = ' + strInternalRecordId);
                throw e;
            }
        }
        return strRet;
    }

    /**********************************************************************************************************     
        Purpose		: Check certain values to see if they meet certain formatting criteria. This is needed as
                    invalid values can not be added to sObjects (even before DML operations) - it'll thow Exceptions!
        Parameters	: @param msgFeedItem  The FeedItem from external system
        Returns		: Boolean
        Throws 		: StringException()
    ***********************************************************************************************************/
    public static Boolean checkValuesFormatting(msgREST_REQ_COMP_FeedItem msgFeedItem)
    {
        Boolean blnSuccess = false;
        String strValue = '';
        List<String> lstFeilds = new List<String>();

        try 
        {
            String strErrorMsg = '';

            if(msgFeedItem.isComment)
            {
                //Look for Comment specific values
                if ((String.isBlank(msgFeedItem.externalRecordId)) || (msgFeedItem.externalRecordId.length() != 18))
                {
                    strValue = msgFeedItem.externalRecordId;
                    lstFeilds.add('externalRecordId = ' + msgFeedItem.externalRecordId);
                    throw new StringException('Field [externalRecordId] is not a valid ID (18 chars long)');
                }
            }
            else
            {
                //Look for Post specific values
                if ((String.isBlank(msgFeedItem.externalRecordId)) || (msgFeedItem.externalRecordId.length() != 18))
                {
                    //if [externalRecordId] is empty, it might mean that the values need to be pulled from [internalRecordId].
                    //check this value too to see if this contains a value and throw an exception if not
                    if (String.isBlank(msgFeedItem.internalRecordId) || msgFeedItem.internalRecordId.length() != 18)
                    {
                        strValue = msgFeedItem.externalRecordId;
                        lstFeilds.add('externalRecordId = ' + msgFeedItem.externalRecordId);
                        lstFeilds.add('internalRecordId = ' + msgFeedItem.internalRecordId);
                        throw new StringException('Fields [externalRecordId] and [internalRecordId] are not a valid ID (18 chars long)');
                    }
                }
            }

            //Is there a valid External User ID (aka Local Id)?
            if (String.isBlank(msgFeedItem.externalUserId) || msgFeedItem.externalUserId.length() != 18)
            {
                strValue = msgFeedItem.externalUserId;
                lstFeilds.add('externalUserId = ' + msgFeedItem.externalUserId);
                throw new StringException('Field [externalUserId] is not a valid ID (18 chars long)');
            }

            blnSuccess = true; 
        } 
        catch (StringException ex) 
        {
            msgFeedItem.errorFields = lstFeilds;
            msgFeedItem.errorMessage = ex.getMessage();
            msgFeedItem.errorCode = 'STRING_EXCEPTION';
            msgFeedItem.success = false;

            blnSuccess = false;
        }
        return blnSuccess;
    }

    /**********************************************************************************************************     
        Purpose		: Updates a FeedItem/FeedComment with @mentions.  
        Workaround  : For @mentions to work, we need to utilise the ConnectAPI class.
                      However, the static methods don't allow the assignment of the 'CreatedById' User, meaning that
                      FeedItems/FeedComments will be associated with running user of the process. In order to get around
                      this limitation, it is necessary to insert a raw FeedItem/FeedComment (which does NOT support @mentions)
                      and then simply update this using the ConnectAPI static methods. 
                      Replace if this functionality becomes available.
        Para meters	: @param lstMentions        List of Names (<FirstName> <LastName>) that concreate users AND @mentioned in the body
                      @param msgFeedItem        The entire Feed Item
                      @param lstPieces          List of body pieces, broken up by the valid @mentions
                      @param mapUsersKeyByName  Map of concreate Users
        Returns		: msgREST_REQ_COMP_FeedItem
        Throws 		: n/a
    ***********************************************************************************************************/    
    public static msgREST_REQ_COMP_FeedItem updateFeed(List<String> lstMentions
                                                      ,msgREST_REQ_COMP_FeedItem msgFeedItem
                                                      ,List<String> lstPieces
                                                      ,Map<String, User> mapUsersKeyByName)
    {      
        ConnectApi.MessageBodyInput inputMsgBody = new ConnectApi.MessageBodyInput();
        inputMsgBody.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        Integer i = 0;
        
        try 
        {
            //loop the individual body pieces
            for (String strPiece : lstPieces) 
            {
                //first add a piece of Text
                ConnectApi.TextSegmentInput inputTxtSeg = new ConnectApi.TextSegmentInput();
                inputTxtSeg.text = strPiece;
                inputMsgBody.messageSegments.add(inputTxtSeg);

                if( (i < (lstPieces.size() -1)) && (mapUsersKeyByName.containsKey(lstMentions.get(i).toLowerCase())))
                {
                    //next, add in the @mentions
                    ConnectApi.MentionSegmentInput inputMention = new ConnectApi.MentionSegmentInput();
                    inputMention.id = mapUsersKeyByName.get(lstMentions.get(i).toLowerCase()).id;
                    inputMsgBody.messageSegments.add(inputMention);
                } 
                i++;
            }

            if (inputMsgBody.messageSegments.size() != 0) 
            {
                //now committ
                If (msgFeedItem.isComment)
                {
                    try
                    {
                        ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
                        commentInput.body = inputMsgBody;
                        ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.updateComment(null, msgFeedItem.externalFeedItemId, commentInput);
                    }
                    catch(Exception ex) 
                    {
                        msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segments = ' + inputMsgBody.messageSegments
                                                                   + ' | FeedItemId = ' + msgFeedItem.externalFeedItemId;
                        msgFeedItem.errorCode = 'COMMENT_EXCEPTION';
                        msgFeedItem.success = false;
                    }
                }
                else
                {
                    try
                    {
                        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                        feedItemInput.body = inputMsgBody;
                        ConnectApi.ChatterFeeds.updateFeedElement(null, msgFeedItem.externalFeedItemId, feedItemInput);
                    }
                    catch(Exception ex) 
                    {
                        msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segments = ' + inputMsgBody.messageSegments
                                                                   + ' | FeedItemId = ' + msgFeedItem.externalFeedItemId;
                        msgFeedItem.errorCode = 'POST_EXCEPTION';
                        msgFeedItem.success = false;
                    }
                } 
                If (msgFeedItem.errorMessage == null)
                {
                    msgFeedItem.success = true;             
                }
            } 
        } 
        catch (Exception ex) 
        {
            msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segment Size = ' + inputMsgBody.messageSegments.size() + ' | i = ' + i
                                        + ' | lstPieces = ' + lstPieces
                                        + ' | mapUsersKeyByName = ' +  mapUsersKeyByName;
            msgFeedItem.errorCode = 'MENTION_EXCEPTION';
            msgFeedItem.success = false;
        }
        return msgFeedItem; 
    }

    public static msgREST_REQ_COMP_FeedItem updateFeed(msgREST_REQ_COMP_FeedItem msgFeedItem)
    {      
        ConnectApi.MessageBodyInput inputMsgBody = new ConnectApi.MessageBodyInput();
        inputMsgBody.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        try 
        {
            //first add a piece of Text
            ConnectApi.TextSegmentInput inputTxtSeg = new ConnectApi.TextSegmentInput();
            inputTxtSeg.text = msgFeedItem.body;
            inputMsgBody.messageSegments.add(inputTxtSeg);

            //now committ
            If (msgFeedItem.isComment)
            {
                try
                {
                    ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
                    commentInput.body = inputMsgBody;
                    ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.updateComment(null, msgFeedItem.externalFeedItemId, commentInput);
                }
                catch(Exception ex) 
                {
                    msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segments = ' + inputMsgBody.messageSegments
                                                                + ' | FeedItemId = ' + msgFeedItem.externalFeedItemId;
                    msgFeedItem.errorCode = 'COMMENT_EXCEPTION';
                    msgFeedItem.success = false;
                }
            }
            else
            {
                try
                {
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    feedItemInput.body = inputMsgBody;
                    ConnectApi.ChatterFeeds.updateFeedElement(null, msgFeedItem.externalFeedItemId, feedItemInput);
                }
                catch(Exception ex) 
                {
                    msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segments = ' + inputMsgBody.messageSegments
                                                                + ' | FeedItemId = ' + msgFeedItem.externalFeedItemId;
                    msgFeedItem.errorCode = 'POST_EXCEPTION';
                    msgFeedItem.success = false;
                }
            } 
            If (msgFeedItem.errorMessage == null)
            {
                msgFeedItem.success = true;             
            }
        } 
        catch (Exception ex) 
        {
            msgFeedItem.errorMessage = ex.getMessage() + ' | Msg Segment Size = ' + inputMsgBody.messageSegments.size();
            msgFeedItem.errorCode = 'MENTION_EXCEPTION';
            msgFeedItem.success = false;
        }
        return msgFeedItem; 
    }


    /**********************************************************************************************************     
        Purpose		: Splits an incoming String (strPost) by the various names contained in theList<String> (lstMentions)
        Parameters	: @param lstMentions    List of names in the format: "<FirstName> <LastName>" 
                    @param strPost        The string containing N x @mentions
        Returns		: @return List<String>  A list containing the pieces of the incoming String, split by the various 
                                            @mentions
        Throws 		: n/a
    ***********************************************************************************************************/
    public static List<String> splitByMentions(List<String> lstMentions, String strPost)
    {
        List<String> lstPieces = new List<String>(); 
        String strReplaced = '';
        String strSplitTerm = '|' + REST_RES_Utils.strSPLIT_TERM + '|';

        try
        {
            //if empty, simply return
            if (lstMentions.size() ==0) {return lstPieces;}

            //if the post starts with a "@", insert an artifical empty space
            if (strPost.startsWith('@')) {strPost = ' ' + strPost;}

            //loop through Mentions
            For(String strMention: lstMentions)
            {
                //replace found Mention with some unique identifier. Include "@" so this is also replaced
                strReplaced = strPost.replace('@' + strMention, strSplitTerm);
                //store back to the original string so we don't lose any unique identifier we just added 
                strPost = strReplaced;
            }
            
            //account for @mentions next to each other WITHOUT a single space. For these situations, add in an articial space
            strReplaced = strReplaced.replace(strSplitTerm + strSplitTerm, strSplitTerm + ' ' + strSplitTerm);

            //now we have a replaced string containing the unique identifer, split by these unique identifer to obtain the pieces
            For(String strSplit: strReplaced.split(REST_RES_Utils.strSPLIT_TERM_REGEX))
            {
                lstPieces.add(strSplit);
            }
        }
        catch (Exception ex)
        {
            lstPieces = null;
        }
        
        return lstPieces;
    }

    /**********************************************************************************************************     
        Purpose		: Parses a string and extracts all @mentions the match the pattern: @<string> <string>
                    AND are users are in the given Map of Users
        Parameters	: @param strPost            The string to parse for @mentions
                    @param mapUsersKeyByName  Map of Users to match against
        Returns		: @return List<String>  A list containing the "<FirstName> <LastName>" of @mentions that are mentioned
                                            in the string argument.
        Throws 		: n/a
    ***********************************************************************************************************/
   public static List<String> getUserNameMentions(String strPost, Map<String, User> mapUsersKeyByName)
   {
        List<String> lstMentions = new List<String>(); 

        try
        {
            Pattern pat = Pattern.compile(REST_RES_Utils.strMENTION_REGEX);
            Matcher matcher = pat.matcher(strPost);
            
            //loop matches
            while(matcher.find()) 
            {
                //remove the beginning "@"
                String strName = matcher.group().removeStart('@');

                if(mapUsersKeyByName.containsKey(strName.toLowerCase()))
                {
                    lstMentions.add(strName);
                }  
            }
        }
        catch (Exception ex)
        {
            lstMentions = null;
        }
        
        return lstMentions;
    }
}