trigger FeedCommentTrigger on FeedComment (after insert, after update) 
{
    if(!Test.isRunningTest())
    {
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration(); 
        if (Trigger.isAfter && Trigger.isInsert) 
        {
            objCrossOrgCollab.processFeed(Trigger.New, true, 'GOLS', 'NEW');        
        }
        else if (Trigger.isAfter && Trigger.isUpdate) 
        {
            objCrossOrgCollab.updateFeed(Trigger.New, true, 'GOLS', 'EDIT');  
        }
    }
}