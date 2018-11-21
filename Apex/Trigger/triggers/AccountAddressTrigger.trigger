trigger AccountAddressTrigger on Account (before insert, before update) 
{
    //Trigger.New is a collection of all the (bukified) sObjects that caused *this* Trigger to fire
    //There is also a Trigger.Old
    //You can index the Collection: Trigger.New[1]
    for(Account a : Trigger.New) 
    {
        if (a.BillingPostalCode != null && a.Match_Billing_Address__c)
        {
            a.ShippingPostalCode = a.BillingPostalCode;
        }
    }  
}