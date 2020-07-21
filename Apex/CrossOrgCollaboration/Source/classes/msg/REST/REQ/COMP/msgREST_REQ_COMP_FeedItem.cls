public class msgREST_REQ_COMP_FeedItem 
{   
    //OLD - Keep
    public String body;
    public String firstName;
    public String lastName;
    public String alias;
    public Boolean isComment = false;
    public String externalFeedItemId;
    public Boolean success = false;
    public String errorMessage;
    public String errorCode;
    public List<String> errorFields;
    public String externalUserId;
    public String internalUserId;

    //NEW
    public String event;
    public String internalFeedItemId;
    public String internalRecordId;
    public String externalRecordId;
    
    //DELETE
    //public String projectId;
    //public String FeedItemId;
   // public String commentId;
   // public String parentId;

    public msgREST_REQ_COMP_FeedItem() 
    {
    }
    /**
     *     public msgREST_REQ_COMP_FeedItem(String body, String projectId, String firstName, String lastName, String alias, 
                                String externalUserId, Boolean isComment, String commentId, String parentId) 
     */
}