/**
The system saves the records that fired the before trigger after the trigger finishes execution. 
You can modify the records in the trigger without explicitly calling a DML insert or update operation. 
If you perform DML statements on those records, you get an error.
*/
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
