<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>EmptyWhileStmt</label>
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
        <value xsi:type="xsd:string">Empty While Statement finds all instances where a while statement does nothing.
If it is a timing loop, then you should use Thread.sleep() for it; if it is a while loop that does a lot in the exit expression, rewrite it to make it clearer.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public void bar(Integer a, Integer b) {
  while (a == b) {
    // empty!
  }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#emptywhilestmt</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Empty While Statement</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">errorprone</value>
    </values>
</CustomMetadata>
