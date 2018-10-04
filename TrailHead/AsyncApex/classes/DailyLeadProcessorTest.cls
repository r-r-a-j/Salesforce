@isTest
private class DailyLeadProcessorTest 
{
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testScheduledJob() 
    {
        // Create some out of date Opportunity records
        List<Lead> lstLeads = new List<Lead>();
        
        //Date closeDate = Date.today().addDays(-7);
        
        for (Integer i=0; i<200; i++) 
        {
            Lead objLead = new Lead(firstname = 'LeadFirstName ' +i 
                                   ,Lastname = 'LeadLastName ' +i 
                                   ,Company = 'Company ' +i);
            lstLeads.add(objLead);
        }
        insert lstLeads;
        
        // Get the IDs of the opportunities we just inserted
        //Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>(opptys);
        //List<Id> opptyIds = new List<Id>(opptyMap.keySet());
        
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());  

        Test.stopTest();
        
        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}