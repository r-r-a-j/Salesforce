/*
 *	DESCRIP		:	Asynchoronous Apex: Batch Processing
 *
 **/
global class LeadProcessor implements Database.Batchable<sObject>
{    
    // instance member to retain state across transactions
    //global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(
            'SELECT ID ' +
            'FROM Lead'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope)
    {
        // process each batch of records
        List<Lead> leads = new List<Lead>();
        
        for (Lead lead : scope) 
        {
            lead.leadsource = 'Dreamforce';
            leads.add(lead);
        }
        update leads;
    }    
    global void finish(Database.BatchableContext bc)
    {
       //
    }    
}