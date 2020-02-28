<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidDeeplyNestedIfStmts</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.AvoidDeeplyNestedIfStmtsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Avoid creating deeply nested if-then statements since they are harder to read and error-prone to maintain.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public void bar(Integer x, Integer y, Integer z) {
        if (x&gt;y) {
            if (y&gt;z) {
                if (z==x) {
                    // !! too deep
                }
            }
        }
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#avoiddeeplynestedifstmts</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">IF..THEN statements is too deep</value>
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
