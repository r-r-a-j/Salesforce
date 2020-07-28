trigger CodeAnalysisTrigger on Code_Analysis__c (after insert) 
{
    List<Rule_Set__c> lstObjRuleSet = new List<Rule_Set__c>();
    List<Rule__c> lstObjRule = new List<Rule__c>();
    List<Property__c> lstObjProperty = new List<Property__c>();
    /** 
        On New, copy data held in MDT
    */   
    try 
    {
        For(Code_Analysis__c objCodeAnalysis: Trigger.New)
        {
            /** 
                initialise the process by copying from MDT 
            */         
                    
            //get all Rulesets 
            List<Rule_Set_Setting__mdt> lstMDTRuleSet = [SELECT 	id
                                                                    ,Label
                                                        FROM 		Rule_Set_Setting__mdt];
            
            For (Rule_Set_Setting__mdt objMDTRuleSet :lstMDTRuleSet)
            {
                //Create a [Rule_Set__c] object
                Rule_Set__c objRuleSet = new Rule_Set__c();
                objRuleSet.Name = objMDTRuleSet.Label;
                objRuleSet.Code_Analysis__c = objCodeAnalysis.id;

                //generally, an insertion within a For loop is discouraged, but there is likely to be a small number, so this should be ok
                //Also, we need to retrieve the ID of the object for linking, so this is necessary.
                insert objRuleSet;

                //get all Rules 
                List<Rule_Setting__mdt> lstMDTRule = [SELECT 	id
                                                                ,Label
                                                                ,Active__c
                                                                ,Class__c
                                                                ,Description__c
                                                                ,Example__c
                                                                ,External_Info_URL__c
                                                                ,Message__c
                                                                ,Priority__c
                                                    FROM 		Rule_Setting__mdt
                                                    WHERE       Rule_Set__c =:objMDTRuleSet.id];
                
                For (Rule_Setting__mdt objMDTRule :lstMDTRule)
                {
                    //Create a [Rule__c] object
                    Rule__c objRule = new Rule__c();
                    objRule.Name = objMDTRule.Label;
                    objRule.Active__c	 = objMDTRule.Active__c;
                    objRule.Class__c = objMDTRule.Class__c;
                    objRule.Description__c = objMDTRule.Description__c;
                    objRule.Example__c = objMDTRule.Example__c;
                    objRule.External_Info_URL__c = objMDTRule.External_Info_URL__c;
                    objRule.Message__c = objMDTRule.Message__c;
                    objRule.Priority__c = objMDTRule.Priority__c;
                    objRule.Rule_Set__c = objRuleSet.id;
                
                    //get all Properties 
                    List<Property_Setting__mdt> lstMDTProperty = [SELECT 	id
                                                                            ,Label
                                                                            ,Description__c
                                                                            ,Value__c
                                                                  FROM 		Property_Setting__mdt
                                                                  WHERE     Rule__c =:objMDTRule.id];
                    if (lstMDTProperty.size() == 0)
                    {
                        //no properties exist for this Rule, so safe to bulkify
                        lstObjRule.add(objRule);
                    }
                    else 
                    {
                        //generally, an insertion within a For loop is discouraged, but there is likely to be a small number, so this should be ok
                        //Also, we need to retrieve the ID of the object for linking, so this is necessary.
                        insert objRule;
                
                        For (Property_Setting__mdt objMDTProperty :lstMDTProperty)
                        {
                            //Create a [Property__c] object
                            Property__c objProperty = new Property__c();
                            objProperty.Name = objMDTProperty.Label;
                            objProperty.Value__c = objMDTProperty.Value__c;
                            objProperty.Description__c	 = objMDTProperty.Description__c;
                            objProperty.Rule__c = objRule.id;
                            lstObjProperty.add(objProperty);
                        }
                    }
                }
            }
        }
        insert lstObjRule; 
        insert lstObjProperty; 
    } 
    catch (Exception ex) 
    {
       System.debug('Error in [CodeAnalysisTrigger()]'); 
    } 
}