/*
******************************************************************************************************************
Apex Class Name     : ObjectLevel1
Created Date        : February 9 2026
@description        : Test Object structure.
@author             : Ravi Raj
Modification Log    :
Ver   Date         Author           Modification
1.0   09-02-2026   Ravi Raj         Initial Version
******************************************************************************************************************
*/
public with sharing class ObjectLevel1 implements JSONInterface
{
    //public AF_DD_PaymentAdequacy_Reassessment previousReassessent;
    //public AF_DD_PaymentAdequacy_Reassessment currentReassessent;   
    public Decimal CurrentBalance = 0.00;
    public Decimal TotalEstimatedEnergyCost = 0.00;
    public Decimal NewDirectDebitAmount = 0.00;
    public Decimal OldDirectDebitAmount = 0.00;    
    public Date ChangeDate;
    public ObjectLevel1() {}

    /*
    *************************************************************************************************************
    @Method Name    : getExtractionFields
    @author         : Ravi Raj
    @description    : Returns a list of [string] that need to be extracted from the JSON payload response 
    @return         : [List<string>]      - List of extraction [string] that need to be extracted.
    *************************************************************************************************************
    */
    public List<string> getExtractionFields()
    {
        return new List<string>{'currentBalance', 'totalEstimatedEnergyCost', 'newAmount', 'previousAmount', 'changeDate'}; 
    }


    /*
    *************************************************************************************************************
    @Method Name    : contains
    @author         : Ravi Raj
    @description    : Checks to see if a list of [lstKeyValuePairs] contains a specific [strField]].
    @param          : [lstKeyValuePairs]- List of [KeyValuePair] objects
    @param          : [strField]        - The field name to check for in the list
    @return         : [Boolean]         - True if the field is found, false otherwise
    *************************************************************************************************************
    */
    public void saveExtractedFields(List<KeyValuePair> lstKeyValuePairs) 
    {

        for (KeyValuePair kvp : lstKeyValuePairs) 
        {
            switch on kvp.Key 
            {
                when 'currentBalance'           { CurrentBalance            = Decimal.valueOf(kvp.Value);}	
                when 'totalEstimatedEnergyCost' { TotalEstimatedEnergyCost  = Decimal.valueOf(kvp.Value);}
                when 'newAmount'                { NewDirectDebitAmount      = Decimal.valueOf(kvp.Value);}
                when 'previousAmount'           { OldDirectDebitAmount      = Decimal.valueOf(kvp.Value);}	
                when 'changeDate'               { ChangeDate                = Date.valueOf(kvp.Value);   }
                when else {}
            }
        }
    }
}