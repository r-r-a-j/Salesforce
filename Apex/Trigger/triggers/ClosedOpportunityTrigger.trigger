/**
 * Trigger to add a task to any opportunity inserted or updated with the stage of 'Closed Won'. 
 * The task's subject must be 'Follow Up Test Task'.
 */
trigger ClosedOpportunityTrigger on Opportunity (after insert, after update)  
{
    List<Task> lstTasks = new List<Task>();
    
	for(Opportunity opp : Trigger.New) 
    {
        If(opp.StageName == 'Closed Won')
        {
          lstTasks.add(new Task(subject = 'Follow Up Test Task', WhatId = opp.Id));  
        }
    }
    
    if (lstTasks.size() > 0)
    {
        insert lstTasks;
    }
}