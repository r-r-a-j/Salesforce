<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>MethodWithSameNameAsEnclosingClass</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.errorprone.MethodWithSameNameAsEnclosingClassRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Non-constructor methods should not have the same name as the enclosing class.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class MyClass {
    // this is OK because it is a constructor
    public MyClass() {}
    // this is bad because it is a method
    public void MyClass() {}
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#methodwithsamenameasenclosingclass</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Non constructor method has the same name as host Class</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">errorprone</value>
    </values>
</CustomMetadata>
