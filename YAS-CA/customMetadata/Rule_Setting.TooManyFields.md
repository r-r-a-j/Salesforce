<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>TooManyFields</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.TooManyFieldsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Classes that have too many fields can become unwieldy and could be redesigned to have fewer fields, possibly through grouping related fields in new objects. For example, a class with individual city/state/zip fields could park them within a single Address field.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Person {
    // too many separate fields
    int birthYear;
    int birthMonth;
    int birthDate;
    float height;
    float weight;
}

public class Person {
    // this is more manageable
    Date birthDate;
    BodyMeasurements measurements;
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#toomanyfields</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Too many fields</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">design</value>
    </values>
</CustomMetadata>
