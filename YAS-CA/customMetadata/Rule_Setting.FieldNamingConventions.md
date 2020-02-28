<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>FieldNamingConventions</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.codestyle.FieldNamingConventionsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Configurable naming conventions for field declarations. This rule reports variable declarations which do not match the regex that applies to their specific kind &amp;#x2014;e.g. constants (static final), static field, final field. Each regex can be configured through properties.

By default this rule uses the standard Apex naming convention (Camel case).</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    Integer intNumber; // OK
    String strField; // OK
    Boolean blnActive; // OK
    CusAccount objAccount; // OK
    List&lt;Account&gt; lstAccount; // OK
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#fieldnamingconventions</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Fields should begin with 3 lower case chars that denote what data type the variable is (int; str; bln; obj; lst; arr...etc).</value>
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
