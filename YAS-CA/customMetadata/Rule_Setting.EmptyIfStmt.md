<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>EmptyIfStmt</label>
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
        <value xsi:type="xsd:string">Empty If Statement finds instances where a condition is checked but nothing is done about it.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
  public void bar(Integer x) {
    if (x == 0) {
      // empty!
    }
  }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#emptyifstmt</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Empty If Statement violation</value>
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
