<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexSOQLInjection</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexSOQLInjectionRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Detects the usage of untrusted / unescaped variables in DML queries.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public void test1(String t1) {
        Database.query(&apos;SELECT Id FROM Account&apos; + t1);
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexsoqlinjection</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">SOQL injection detected</value>
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
