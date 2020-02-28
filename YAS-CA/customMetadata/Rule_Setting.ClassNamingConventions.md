<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ClassNamingConventions</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.codestyle.ClassNamingConventionsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Configurable naming conventions for type declarations. This rule reports type declarations which do not match the regex that applies to their specific kind (e.g. enum or interface). Each regex can be configured through properties.

By default this rule uses the standard Apex naming convention (Pascal case).</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class FooClass { } // This is in pascal case, so it&apos;s ok

public class fooClass { } // This will be reported unless you change the regex</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#classnamingconventions</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Class names should begin with an uppercase character</value>
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
