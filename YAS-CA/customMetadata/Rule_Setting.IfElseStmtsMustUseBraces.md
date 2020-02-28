<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>IfElseStmtsMustUseBraces</label>
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
        <value xsi:type="xsd:string">Avoid using if..else statements without using surrounding braces. If the code formatting or indentation is lost then it becomes difficult to separate the code being controlled from the rest.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">// this is OK
if (foo) x++;

// but this is not
if (foo)
    x = x+1;
else
    x = x-1;</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_codestyle.html#ifelsestmtsmustusebraces</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">When using IF..ELSE statements, you must use braces.</value>
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
