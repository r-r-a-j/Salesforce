@IsTest
public class TriggerHandlerTest 
{
   public static TestMethod void testTriggerHandler()
    {			
        try
        {
            Account acct = new Account(Name='NEWEUACCT',Type='Owner',BillingStreet='456 Main St.',BillingCity='Chicago',
                                         BillingState='IL',BillingPostalCode='55555',BillingCountry='USA',
                                         ShippingStreet='456 Main St.',ShippingCity='Chicago',
                                         ShippingState='IL',ShippingPostalCode='55555',ShippingCountry='USA');
			insert acct;

            acct.BillingStreet = 'new street';
            update acct;

            delete acct;

			undelete acct;
            
            System.assert(acct.BillingStreet.contains('new'));
        }
        catch (Exception e)
        {
            System.debug('====== testTriggerHandler ERROR MSG ======' + e.getMessage());
            System.debug('====== testTriggerHandler ERROR STACK ======' + e.getStackTraceString());            
        }
    }
}