<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ExcessiveParameterList</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.ExcessiveParameterListRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Methods with numerous parameters are a challenge to maintain, especially if most of them share the same datatype. These situations usually denote the need for new objects to wrap the numerous parameters.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">// too many arguments liable to be mixed up
public void addPerson(int birthYear, int birthMonth, int birthDate, int height, int weight, int ssn) {
    // ...
}
// preferred approach 
public void addPerson(Date birthdate, BodyMeasurements measurements, int ssn) {
    // ...
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#excessiveparameterlist</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Too many parameters</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">design</value>
    </values>
</CustomMetadata>
