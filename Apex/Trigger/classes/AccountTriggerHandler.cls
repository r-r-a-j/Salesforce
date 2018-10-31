public class AccountTriggerHandler
{
    /**
     * Method that accepts a list of Accounts, and before saving, ensures [ShippingState] 
     * is the same as [BillingState]
     */
    public static void CreateAccounts(List<Account> lstAccount)
    {   
        //List<Account> lstAccountsToUpdate = new List<Account>();
        
        For (Account acc : lstAccount)
        {
            acc.ShippingState = acc.billingState;
            //lstAccountsToUpdate.add(new Account(id=acc.id, ShippingState = acc.billingState));
        }      
        
        /*if (lstAccountsToUpdate.size() >0)
        {
        	insert lstAccountsToUpdate;
        }
*/
    }
}