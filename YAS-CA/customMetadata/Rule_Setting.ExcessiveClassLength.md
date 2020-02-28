<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ExcessiveClassLength</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.ExcessiveClassLengthRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Excessive class file lengths are usually indications that the class may be burdened with excessive responsibilities that could be provided by external classes or functions. In breaking these methods apart the code becomes more managable and ripe for reuse.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public void bar1() {
        // 1000 lines of code
    }
    public void bar2() {
        // 1000 lines of code
    }
    public void bar3() {
        // 1000 lines of code
    }
    public void barN() {
        // 1000 lines of code
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#excessiveclasslength</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Total class length is excessive. (This rule &quot;NcssTypeCount&quot;; for non-commented line count)</value>
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
