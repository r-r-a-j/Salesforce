trigger FeedItemTrigger on FeedItem (after insert, after update) 
{
    if(!Test.isRunningTest())
    {
        CrossOrgCollaboration objCrossOrgCollab = new CrossOrgCollaboration();  
        if (Trigger.isAfter && Trigger.isInsert) 
        {
            objCrossOrgCollab.processFeed(Trigger.New, false, 'GOLS', 'NEW');        
        }
        else if (Trigger.isAfter && Trigger.isUpdate) 
        {
            objCrossOrgCollab.updateFeed(Trigger.New, false, 'GOLS', 'EDIT');  
        }
    }
}