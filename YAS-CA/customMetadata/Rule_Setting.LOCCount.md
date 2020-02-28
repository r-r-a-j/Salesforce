<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>LOCCount</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.NcssTypeCountRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">This rule uses the NCSS (Non-Commenting Source Statements) algorithm to determine the number of lines of code for a given type. NCSS ignores comments, and counts actual statements. Using this algorithm, lines of code that are split are counted as one.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">//this class only has 6 NCSS lines
public class Foo extends Bar {
    public Foo() {
        super();





        super.foo();
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#ncsstypecount</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Class has too many non-commented lines of  code</value>
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
