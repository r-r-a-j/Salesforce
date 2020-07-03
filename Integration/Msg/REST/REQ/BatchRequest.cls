public class BatchRequest 
{
    public List<GenericRequest> batchRequests = new List<GenericRequest>();
    
    public BatchRequest(List<Object> lstGeneric, String strMethod, String strURL)
    {
        //for each element in the list, create a GenericRequest object
        for(Object objGeneric : lstGeneric)
        {
            GenericRequest objGenricReq = new GenericRequest(objGeneric, strMethod, strURL);
            batchRequests.add(objGenricReq);    
        }
    }
}
