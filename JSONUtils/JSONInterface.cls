/*
******************************************************************************************************************
Apex Class Name     : JSONInterface
Created Date        : February 9 2026
@description        : Interface to be implemented by any class that needs to extract fields from a JSON response.
@author             : Ravi Raj
Modification Log    :
Ver   Date         Author           Modification
1.0   09-02-2026   Ravi Raj         Initial Version
******************************************************************************************************************
*/
public interface JSONInterface 
{
    /*
    *************************************************************************************************************
    @Method Name    : getExtractionFields
    @description    : Returns a list of [strings] that need to be extracted from the JSON payload response 
    @return         : [List<string>]      - List of extraction [Kestrings] that need to be extracted.
    *************************************************************************************************************
    */
    List<string> getExtractionFields();

    /*
    *************************************************************************************************************
    @Method Name    : saveExtractedFields
    @description    : Saves the extracted fields from a JSON payload response to an object.
    @param          : [lstKeyValuePairs]  - List of [KeyValuePair] objects containing extracted field values
    @param          : [obj]             - The object to save the extracted fields to
    *************************************************************************************************************
    */
    void saveExtractedFields(List<KeyValuePair> lstKeyValuePairs);
}