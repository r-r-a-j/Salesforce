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
    @Method Name    : getExternalCall
    @author         : Ravi Raj
    @description    : Simulates a call to an external end point and returns a JSON payload response.
    @param          : [inLst]           - Contains an ID
    @return         : [List<output>]    - Contains the JSON payload response from the aimulated call.
    Example calling code:

        List<JSONUtils.input> lstIn = new List<JSONUtils.input>();
        JSONUtils.input objIn = new JSONUtils.input();
        objIn.Id = '123456789'; 
        lstIn.add(objIn);

        List<JSONUtils.output> lstOut = JSONUtils.getExternalCall(lstIn);

        System.debug('>>>>>>>>>>> JSON = ' + lstOut[0].strJSON);
    *************************************************************************************************************
    */
    @InvocableMethod(label = 'Simulated external Call' description='External call to get JSON payload')

    public static List<output> getExternalCall(List<input> inLst) 
    {
        output retOut = new output();

        try 
        {
            string strField = '';
            
        // Call the API and get the response
        //string strID = inLst[0].Id;
        
        /*
        Examples JSON payload:

            {
            "previousReassessment": {
                "reassessmentDate": "2025-02-07T17:32:15.04",
                "estimatedEnergyCost": 542.04,
                "commodityDetails": [
                {
                    "commodity": "E",
                    "consumption": 0,
                    "cost": 0
                },
                {
                    "commodity": "G",
                    "consumption": 6901.93,
                    "cost": 542.09
                },
                {
                    "commodity": null,
                    "consumption": 0,
                    "cost": 0
                }
                ],
                "reason": "Ad-hoc"
            },
            "currentReassessment": {
                "reassessmentDate": "2025-12-06T17:48:09.287",
                "estimatedEnergyCost": 531.48,
                "commodityDetails": [
                {
                    "commodity": "G",
                    "consumption": 7636,
                    "cost": 531.53
                }
                ],
                "reason": "Change of Tariff"
            },
            "currentBalance": -91.36,
            "totalEstimatedEnergyCost": 440.12,
            "newAmount": 36.68,
            "previousAmount": 15,
            "changeDate": "2026-01-15T00:00:00",
            "lastChangeOutsideReview": {
                "changedDate": "2025-12-06T17:48:09.847"
            },
            "paymentAdequacyChangeReasons": [
                {
                "type": "Consumption",
                "consumptionChanges": [
                    {
                    "fuel": "G",
                    "oldConsumption": 6901.93,
                    "newConsumption": 7636,
                    "totalDifference": 734.07,
                    "percentageDifference": 10
                    }
                ]
                },
                {
                "type": "Price",
                "priceChanges": [
                    {
                    "chargeableComponent": {
                        "chargeableComponentUid": "GAS",
                        "chargeableComponentName": "Gas Consumption",
                        "chargeableComponentDescription": "Gas Consumption",
                        "commodityUid": "G"
                    },
                    "chargeableComponentUid": "GAS",
                    "segmentUid": "_B",
                    "oldRate": 6.526,
                    "newRate": 5.149,
                    "totalDifference": -1.377,
                    "percentageDifference": -21.1,
                    "dateOfChange": "2025-11-24T00:00:00"
                    },
                    {
                    "chargeableComponent": {
                        "chargeableComponentUid": "GASSTANDINGCHARGE",
                        "chargeableComponentName": "Gas Standing Charge",
                        "chargeableComponentDescription": "Gas Standing Charge",
                        "commodityUid": "G"
                    },
                    "chargeableComponentUid": "GASSTANDINGCHARGE",
                    "segmentUid": "_B",
                    "oldRate": 30.969,
                    "newRate": 30.971,
                    "totalDifference": 0.002,
                    "percentageDifference": 0,
                    "dateOfChange": "2025-11-24T00:00:00"
                    }
                ]
                },
                {
                "type": "Product",
                "oldProductName": "Standard Variable Tariff",
                "newProductName": "Standard Variable Tariff",
                "changeDate": "2025-10-01T00:00:00"
                }
            ]
            }
        **/
        string strJSON = '{"previousReassessment": {"reassessmentDate": "2025-02-07T17:32:15.04","estimatedEnergyCost": 542.04,"commodityDetails": [{"commodity": "E","consumption": 0,"cost": 0},{"commodity": "G","consumption": 6901.93,"cost": 542.09},{"commodity": null,"consumption": 0,"cost": 0}],"reason": "Ad-hoc"},"currentReassessment": {"reassessmentDate": "2025-12-06T17:48:09.287","estimatedEnergyCost": 531.48,"commodityDetails": [{"commodity": "G","consumption": 7636,"cost": 531.53}],"reason": "Change of Tariff"},"currentBalance": -91.36,"totalEstimatedEnergyCost": 440.12,"newAmount": 36.68,"previousAmount": 15,"changeDate": "2026-01-15T00:00:00","lastChangeOutsideReview": {"changedDate": "2025-12-06T17:48:09.847"},"paymentAdequacyChangeReasons": [{"type": "Consumption","consumptionChanges": [{"fuel": "G","oldConsumption": 6901.93,"newConsumption": 7636,"totalDifference": 734.07,"percentageDifference": 10}]},{"type": "Price","priceChanges": [{"chargeableComponent": {"chargeableComponentUid": "GAS","chargeableComponentName": "Gas Consumption","chargeableComponentDescription": "Gas Consumption","commodityUid": "G"},"chargeableComponentUid": "GAS","segmentUid": "_B","oldRate": 6.526,"newRate": 5.149,"totalDifference": -1.377,"percentageDifference": -21.1,"dateOfChange": "2025-11-24T00:00:00"},{"chargeableComponent": {"chargeableComponentUid": "GASSTANDINGCHARGE","chargeableComponentName": "Gas Standing Charge","chargeableComponentDescription": "Gas Standing Charge","commodityUid": "G"},"chargeableComponentUid": "GASSTANDINGCHARGE","segmentUid": "_B","oldRate": 30.969,"newRate": 30.971,"totalDifference": 0.002,"percentageDifference": 0,"dateOfChange": "2025-11-24T00:00:00"}]},{"type": "Product","oldProductName": "Standard Variable Tariff","newProductName": "Standard Variable Tariff","changeDate": "2025-10-01T00:00:00"}]}';
        JSONParser parser = JSON.createParser(strJSON);

        //create Object structure to hold the extracted values from the API response
        ObjectLevel1 objLevel1 = new ObjectLevel1();
        
        //get the Object structure's fields that need to be extracted from the API response
        List<string> lstFieldsToExtract = objLevel1.getExtractionFields();

        //Holds the extracted values from the JSON payload response based on the Object structure's field list
        List<KeyValuePair> lstExtractedFields = new List<KeyValuePair>();

        //loop through the response and extract the necessary fields based on the Object structure's field list
        while (parser.nextToken() != null) 
        {            
            //Only proceed if the current token is a field name
            If (parser.getCurrentToken() == JSONToken.FIELD_NAME)
            {
                strField = parser.getText();

                //Only proceed if the current field is part of the Object structure's field list
                If(lstFieldsToExtract.contains(strField))
                {
                    //create an object to hold the field name and its corresponding value from the JSON payload response and add it to the list of extracted fields
                    KeyValuePair kvp = new KeyValuePair();
                    kvp.Key = strField;
                    kvp.Value = String.valueOf(parser.nextToken());
                    lstExtractedFields.add(kvp);
                }
            }
        }      

        //now save the extracted values from the JSON payload response to the Object structure based on the field names
        objLevel1.saveExtractedFields(lstExtractedFields);

        //return serialized JSON payload response based on the Object structure        
        retOut.strJSON = JSON.serialize(objLevel1);
        return new List<output>{retOut};
        } 
        catch (Exception e) 
        {
            //handle exception
            retOut.strJSON = 'Error: ' + e.getMessage();
            return new List<output>{retOut};
        }
    }

    public class output
    {       
        @InvocableVariable(label = 'Return JSON payload')
        public string strJSON;
    }

    public class input
    {       
        @InvocableVariable(label = 'Input some ID')
        public string Id;
    }
}
