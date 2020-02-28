<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidDirectAccessTriggerMap</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.ApexXPathRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Avoid directly accessing Trigger.old and Trigger.new as it can lead to a bug. Triggers should be bulkified and iterate through the map to handle the actions for each item separately.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">trigger AccountTrigger on Account (before insert, before update) {
   Account a = Trigger.new[0]; //Bad: Accessing the trigger array directly is not recommended.
   
   foreach ( Account a : Trigger.new ){   
        //Good: Iterate through the trigger.new array instead.
   }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#avoiddirectaccesstriggermap</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Improper object access in Trigger&quot; class=&quot;net.sourceforge.pmd.lang.apex.rule.ApexXPathRule</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">errorprone</value>
    </values>
</CustomMetadata>
