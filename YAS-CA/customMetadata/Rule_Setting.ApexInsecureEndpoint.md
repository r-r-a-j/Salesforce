<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexInsecureEndpoint</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexInsecureEndpointRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Checks against accessing endpoints under plain http. You should always use https for security.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public without sharing class Foo {
    void foo() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(&apos;http://localhost:com&apos;);
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexinsecureendpoint</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Insecure endpoint access</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">security</value>
    </values>
</CustomMetadata>
