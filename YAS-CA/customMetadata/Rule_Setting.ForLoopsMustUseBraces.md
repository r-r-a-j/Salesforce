<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ForLoopsMustUseBraces</label>
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
        <value xsi:type="xsd:string">If the code formatting or indentation is lost then it becomes difficult to separate the code being controlled from the rest.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">for (int i = 0; i &lt; 42; i++) // not recommended
    foo();

for (int i = 0; i &lt; 42; i++) { // preferred approach
    foo();
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#forloopsmustusebraces</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">void using FOR statements without using surrounding braces.</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">codestyle</value>
    </values>
</CustomMetadata>
