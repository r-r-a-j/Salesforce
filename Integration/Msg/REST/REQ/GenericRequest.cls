public class GenericRequest 
{
    public String method;
    public String url;
    public RichInput richInput;
    
    public GenericRequest(Object objGeneric, String method, String url)
    {
        String strClass = Utils.getObjectName(objGeneric);

        if(strClass == 'Cross_Org_Collaboration__c')
        {
            Cross_Org_Collaboration__c objCollab = new Cross_Org_Collaboration__c();
            objCollab = (Cross_Org_Collaboration__c)objGeneric;
            this.method = method;
            this.url = url;
           //this.richInput = new RichInput(objGeneric.Body, 'TextPost', 'a066E000006Ijt9QAC');
           //'[From: ' + objCollab.First_Name__c + ' ' + objCollab.Last_Name__c + ']'
            this.richInput = new RichInput(objCollab.Body__c, 'TextPost', objCollab.OneForce_Project_Id__c);
        }
    }
}
