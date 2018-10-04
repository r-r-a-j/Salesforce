/*
 *	DESCRIP		:	Asynchoronous Apex: Schedulable Processing
 *
 **/
global class DailyLeadProcessor implements Schedulable
{
    global void execute(SchedulableContext ctx) 
    {
        List<Lead> lstLeads = [SELECT 	Id, Name
                                FROM 	Lead 
                                WHERE 	LeadSource = ''
                                LIMIT	200];
        
        // Create a task for each opportunity in the list
        for(Lead objLead : lstLeads)
        {
            objLead.LeadSource = 'Dreamforce';            
        }
        update lstLeads;
    }
    
}