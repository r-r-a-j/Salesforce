<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexSuggestUsingNamedCred</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexSuggestUsingNamedCredRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Detects hardcoded credentials used in requests to an endpoint.

You should refrain from hardcoding credentials:

They are hard to mantain by being mixed in application code
Particularly hard to update them when used from different classes
Granting a developer access to the codebase means granting knowledge of credentials, keeping a two-level access is not possible.
Using different credentials for different environments is troublesome and error-prone.
Instead, you should use Named Credentials and a callout endpoint</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexSuggestUsingNamedCredRule</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexsuggestusingnamedcred</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Hard coded credentials used</value>
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
