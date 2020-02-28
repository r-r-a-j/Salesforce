<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>OneDeclarationPerLine</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.ApexXPathRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Apex allows the use of several variables declaration of the same type on one line. However, it can lead to quite messy code. This rule looks for several declarations on the same line.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">Integer a, b;   // not recommended

Integer a,
        b;      // ok by default, can be flagged setting the strictMode property

Integer a;      // preferred approach
Integer b;</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#onedeclarationperline</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Use 1 line per variable declaration!</value>
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
