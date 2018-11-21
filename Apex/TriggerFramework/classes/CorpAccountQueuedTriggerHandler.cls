/*
 * 
*/
public class CorpAccountQueuedTriggerHandler extends TriggerHandler 
{

    public CorpAccountQueuedTriggerHandler(List<SObject> newList, List<SObject> oldList, Map<Id,SObject> newmap, Map<Id,SObject> OldMap, 
                          Boolean before, Boolean after, Boolean isInsert, Boolean isUpdate, 
                          Boolean isDelete, Boolean isUnDelete) 
    {        
    }
    
	public override void commonQueued(Trig trigVar)
    {
		System.debug('=== commonQueued: Trigger Values: ' + trigVar);       
    }
}