/*
******************************************************************************************************************
Apex Class Name     : JSONUtils
Created Date        : February 9 2026
@description        : Invocable utility class for JSON.
@author             : Ravi Raj
Modification Log    :
Ver   Date         Author           Modification
1.0   09-02-2026   Ravi Raj         Initial Version
******************************************************************************************************************
*/
public with sharing class JSONUtils 
{
    public JSONUtils() {}

    /*
    *************************************************************************************************************
    @Method Name    : getExtractionFieldsFromJSON
    @author         : Ravi Raj
    @description    : Extracts specified fields from a JSON string.
    @param          : [strJSON]             - The JSON string to process
    @param          : [lstFieldsToExtract]  - The list of fields to extract
    @return         : [Map<String, String>] - A map containing the extracted fields and their values.
    *************************************************************************************************************
    */
    public static Map<String, String> getExtractionFieldsFromJSON(String strJSON, List<string> lstFieldsToExtract) 
    {
        try
        {
            //check if the JSON string is null or empty, return an empty map
            if (String.isBlank(strJSON))
            {
                return new Map<String, String>();
            }

            Map<String, String> mpExtractedFields = new Map<String, String>();

            // Deserialize root
            Object parsedJson = JSON.deserializeUntyped(strJSON);
            
            // Start processing the root element
            return processNode(parsedJson, lstFieldsToExtract, mpExtractedFields, false, '');   

        }
        catch (Exception e) 
        {
            return new Map<String, String>();
        }
    }

    /*
    *************************************************************************************************************
    @Method Name    : processNode
    @author         : Ravi Raj
    @description    : Helper method to extract specified fields from a JSON string.
    @param          : [node]                - Specific JSON node to process
    @param          : [lstFieldsToExtract]  - The list of fields to extract
    @param          : [mpExtractedFields]   - A map containing the extracted fields and their values.
    @param          : [blnExtractValue]     - A flag indicating whether to extract the value of the current node.
    @param          : [strKey]              - The key of the current node.
     @return        : [Map<String, String>] - A map containing the extracted fields and their values.
    *************************************************************************************************************
    */
    private static Map<String, String> processNode(Object node, List<string> lstFieldsToExtract, Map<String, String> mpExtractedFields, Boolean blnExtractValue, String strKey)
    {
        if (node instanceof Map<String, Object>) 
        {
            // Node is a JSON Object: Loop through all keys
            Map<String, Object> nodeMap = (Map<String, Object>)node;

            for (String key : nodeMap.keySet()) 
            {
                If(lstFieldsToExtract.contains(key))
                {
                    System.debug('👓 Entering Key: ' + key);
                    mpExtractedFields = processNode(nodeMap.get(key), lstFieldsToExtract, mpExtractedFields, true, key); 
                }
            }
        } 
        else if (node instanceof List<Object>)
        {
            // Node is a JSON Array: Loop through all elements
            List<Object> nodeList = (List<Object>)node;

            for (Object item : nodeList) 
            {
                mpExtractedFields = processNode(item, lstFieldsToExtract, mpExtractedFields, false, ''); 
            }
        } 
        else 
        {
            If (blnExtractValue)
            {
                
                // Node is a terminal primitive value (String, Integer, Boolean, null)
                System.debug('💎 Found Value: ' + node);
                mpExtractedFields.put(strKey, node.toString());
                //return mpExtractedFields;  
            }
        }
        return mpExtractedFields;
    }
}
