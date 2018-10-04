@isTest
private class LeadProcessorTest 
{
    @testSetup 
    static void setup() 
    {
        List<Lead> leads = new List<Lead>();
        List<Contact> contacts = new List<Contact>();
        
        // insert 10 accounts
        for (Integer i=0; i<200; i++) 
        {
            leads.add(new Lead(firstname = 'LeadFirstName ' +i 
                               ,Lastname = 'LeadLastName ' +i 
                               ,Company = 'Company ' +1
                               ,leadsource = 'Not Dreamforce'));
        }
        insert leads;
    }
    
    static testmethod void test() 
    {        
        Test.startTest();
        LeadProcessor Leadtest = new LeadProcessor();
        Id batchId = Database.executeBatch(Leadtest);
        Test.stopTest();
        
        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [SELECT count() FROM Lead where leadsource = 'Dreamforce']);
    }

}