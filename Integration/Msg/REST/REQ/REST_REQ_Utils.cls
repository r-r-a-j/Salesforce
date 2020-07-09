/******************************************************************** **  
                            *******************
                            **** DISCAIMER ****
                            *******************

    The code below is for illustrative purposes only. It is not intended
    to be production quality, merely an example of how things can be 
    accomplished. The author takes no responsibilty for the inner workings
    and/or any defects that may occur as a result of using it. Please
    see the Salesforce Master Contract for more details.

********************************************************************* **/ 

/********************************************************************************************************** 
NAME			:	RESTMessage  
DESCRIPTION 	:	TODO
DATE			:	May 2020
AUTHOUR			:	Ravi Raj (Salesforce Snr Program Architect)

HISTORY         :
VERSION  	AUTHOR   	        DATE  		    DESCRIPTIOM    
1.0    		Ravi Raj  	        May 2020	    Initial Release
***********************************************************************************************************/
public class REST_REQ_Utils 
{
    private final String strBATCH = 'batchRequests';
    private final String strFEED_ITEM = 'FeedItem';
    private string strRet = '';

    /**********************************************************************************************************     
    Purpose		: Given a JSON string response from the REST API, create concrete objects and return them in a 
                  generic List of Objects 
    Parameters	: [jsonStr]         A JSON String response (from the standarc SF REST API), unserialised
    Returns		: [List<Object>]    A List of Objects containing concrete objects from yhr JSON String provided
    Throws 		: n/a
    ***********************************************************************************************************/
    public List<Object> getJSONResponse(String jsonStr)
    {
        List<Object> lstReturn = new List<Object>();

        try 
        {
            Map<String, Object> mapJSON = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
            
            //get the main Results list payload
            List<Object> lstResults = (List<Object>) mapJSON.get('results');
            
            //loop through each element in Results list
            for (Object obj : lstResults)
            {
                Map<String, Object> mapResult = (Map<String, Object>) obj;
                Integer intSucess = (Integer) mapResult.get('statusCode');
            
                If (intSucess == 201)
                {
                    //success
                    //parse the 'result' into a concreate object [msgREST_RES_COMP_Detail]
                    Map<String, Object> mapDetails = (Map<String, Object>) mapResult.get('result');
            
                    msgREST_RES_COMP_Detail msgDetail = new msgREST_RES_COMP_Detail((String) mapDetails.get('id')
                                                                                   ,(Boolean) mapDetails.get('success')
                                                                                   ,(List<Object>) mapDetails.get('errors'));
                    lstReturn.add(msgDetail);
                }
                else 
                {
                    //fail
                    //the REST API returns the result payload as a list of string, so unmarshall accordingly
                    List<Object> lstErrors = (List<Object>) mapResult.get('result');    
            
                    for (Object objError : lstErrors) 
                    {
                        //parse the 'error' into a concreate object [msgREST_RES_COMP_Error]
                        Map<String, Object> mapError = (Map<String, Object>) objError;
            
                        msgREST_RES_COMP_Error msgError = new msgREST_RES_COMP_Error((String)mapError.get('errorCode')
                                                                                    ,(String)mapError.get('message'));
                        lstReturn.add(msgError);
                    }
                }
            } 
        } 
        catch (Exception ex) 
        {
            //strRet = ex.getMessage();
        }
        return lstReturn;
    }

    /**********************************************************************************************************     
    Purpose		: Converts a List of Objects into a JSON friendly version
    Parameters	: [strType]     : Type of JSON string to return
                  [lstGeneric]  : The list of Objects to return in JSON friendly format
                  [method]      : HTTP verb
                  [url]         : The URI endpoint
    Returns		: String (JSON friendly)
    Throws 		: n/a
    ***********************************************************************************************************/
    public String getJSON(String strType, List<Object> lstGeneric, String method, String url)
    {
        String strRet = '';
        Object objGeneric;

        try 
        {
            if (lstGeneric.size() == 0)
            {
                throw new ListException('List is empty: [lstGeneric]');    
            }

            if(strType == strBATCH) 
            {
                objGeneric = new BatchRequest(lstGeneric, method, url);
            }
            else 
            {
                throw new IllegalArgumentException('Unrecognised argument: [' + strType + ']');
            }
            //serialise the raw list
            strRet = JSON.serialize(objGeneric);        
        } 
        catch (Exception ex) 
        {
            strRet = ex.getMessage();
        }
        return strRet;
    }
    /*
        public List<Object> getJSONResponseDEPRECIATED(String strRes, String strType)
    {
        List<Object> lstObjects = new List<Object>();

        try 
        {
            JSONParser parser = JSON.createParser(strRes);

            if (strType == strBATCH) 
            {
                while (parser.nextToken() != null) 
                {
                    // Start at the array of 'batchRequests'.
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
                    {
                        while (parser.nextToken() != null) 
                        {
                            // inner loop
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
                            {
                                // Read entire invoice object, including its array of line items.
                                /*Invoice inv = (Invoice)parser.readValueAs(Invoice.class);
                                system.debug('Invoice number: ' + inv.invoiceNumber);
                                system.debug('Size of list items: ' + inv.lineItems.size());
                                // For debugging purposes, serialize again to verify what was parsed.
                                String s = JSON.serialize(inv);
                                system.debug('Serialized invoice: ' + s);
            
                                // Skip the child start array and start object markers.
                                parser.skipChildren();*/
                         /*   }
                        }
                    }
                }              
            }
            else
            {

            }
            //strRet = JSON.serialize(objGeneric);        
        } 
        catch (Exception ex) 
        {
            //strRet = ex.getMessage();
        }
        return lstObjects;
    }
    */
}
