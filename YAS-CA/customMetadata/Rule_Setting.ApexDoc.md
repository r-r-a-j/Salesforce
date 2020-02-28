<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexDoc</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.documentation.ApexDocRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">This rule validates that:

ApexDoc comments are present for classes, methods, and properties that are public or global, excluding overrides and test classes (as well as the contents of test classes).
ApexDoc comments should contain @description.
ApexDoc comments on non-void, non-constructor methods should contain @return.
ApexDoc comments on void or constructor methods should not contain @return.
ApexDoc comments on methods with parameters should contain @param for each parameter, in the same order as the method signature.
Method overrides and tests are both exempted from having ApexDoc.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">/**
 * @description Hello World
 */
public class HelloWorld {
    /**
     * @description Bar
     * @return Bar
     */
    public Object bar() { return null; }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_documentation.html#apexdoc</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Improper commenting of Class and/or method</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">Documentation</value>
    </values>
</CustomMetadata>
