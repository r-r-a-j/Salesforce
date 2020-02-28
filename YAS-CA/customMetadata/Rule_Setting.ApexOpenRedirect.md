<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexOpenRedirect</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexOpenRedirectRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Checks against redirects to user-controlled locations. This prevents attackers from redirecting users to phishing sites.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public without sharing class Foo {
    String unsafeLocation = ApexPage.getCurrentPage().getParameters.get(&apos;url_param&apos;);
    PageReference page() {
       return new PageReference(unsafeLocation);
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexopenredirect</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Insecure redirect detected</value>
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
