<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexXSSFromEscapeFalse</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexXSSFromEscapeFalseRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Reports on calls to addError with disabled escaping. The message passed to addError will be displayed directly to the user in the UI, making it prime ground for XSS attacks if unescaped.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public without sharing class Foo {
    Trigger.new[0].addError(vulnerableHTMLGoesHere, false);
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexxssfromescapefalse</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">XSS vulnerability detected - unescaped characters passed to [addError]</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">1.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">security</value>
    </values>
</CustomMetadata>
