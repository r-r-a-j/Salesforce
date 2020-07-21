public class msgREST_REQ_COMP_FeedItem 
{
    public String event;
    public Boolean isComment = false;

    public String body;
    public String firstName;
    public String lastName;
    public String alias;

    public String internalFeedItemId;
    public String internalRecordId;
    public String internalUserId;

    public String externalFeedItemId;
    public String externalRecordId;
    public String externalUserId;

    public Boolean success = false;
    public String errorMessage;
    public String errorCode;
    public List<String> errorFields;

    public msgREST_REQ_COMP_FeedItem() 
    {
    }
}
