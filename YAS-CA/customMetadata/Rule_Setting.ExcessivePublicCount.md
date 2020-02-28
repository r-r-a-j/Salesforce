<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ExcessivePublicCount</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.ExcessivePublicCountRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Classes with large numbers of public methods and attributes require disproportionate testing efforts since combinational side effects grow rapidly and increase risk. Refactoring these classes into smaller ones not only increases testability and reliability but also allows new variations to be developed easily.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public String value;
    public Bar something;
    public Variable var;
    // [... more more public attributes ...]

    public void doWork() {}
    public void doMoreWork() {}
    public void doWorkAgain() {}
    // [... more more public methods ...]
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#excessivepubliccount</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Too many variables and/or methods declared as Public</value>
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
