trigger PMDOutputTrigger on PMD_Output__c (before insert, before update) 
{
    /** 
        Update the Class__c by removing the entire dir path
    */
    for (PMD_Output__c objPMD: Trigger.new)
    {
         //Remove entire dir path
        objPMD.Class__c = Utils.trimDir(objPMD.Class__c);

        /**
            Priority__c
            Update the priority number with Text 
         */
         switch on objPMD.Priority__c 
         {
            when '1'  { objPMD.Priority__c = 'INFO';}	
            when '2'  { objPMD.Priority__c = 'LOW';}	
            when '3'  { objPMD.Priority__c = 'MEDIUM';}	
            when '4'  { objPMD.Priority__c = 'HIGH';}	
            when '5'  { objPMD.Priority__c = 'SEVERE';}	
            when else { objPMD.Priority__c = 'MEDIUM';}
        }
    }
}