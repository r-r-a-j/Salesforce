<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidLogicInTrigger</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.bestpractices.AvoidLogicInTriggerRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">As triggers do not allow methods like regular classes they are less flexible and suited to apply good encapsulation style.
Therefore delegate the triggers work to a regular class (often called Trigger handler class).
See more here: https://developer.salesforce.com/page/Trigger_Frameworks_and_Apex_Trigger_Best_Practices</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">trigger Accounts on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	for(Account acc : Trigger.new) {           
		if(Trigger.isInsert) {
			...
		}
		
		...
		
		if(Trigger.isDelete) {
			...
		}
	}
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#avoidlogicintrigger</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Avoid logic in triggers</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">bestpractices</value>
    </values>
</CustomMetadata>
