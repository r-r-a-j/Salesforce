<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>PropertyNamingConventions</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.codestyle.PropertyNamingConventionsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">This rule reports property declarations which do not match the regex that applies to their specific kind (e.g. static property, or instance property). Each regex can be configured through properties.

By default this rule uses the standard Apex naming convention (Camel case).</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public Integer instanceProperty { get; set; } // This is in camel case, so it&apos;s ok

    public Integer INSTANCE_PROPERTY { get; set; } // This will be reported unless you change the regex
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#propertynamingconventions</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Configurable naming conventions for property declarations.</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">codestyle</value>
    </values>
</CustomMetadata>
