<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>xpath</label>
    <protected>false</protected>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">xpath</value>
    </values>
    <values>
        <field>Rule__c</field>
        <value xsi:type="xsd:string">DebugsShouldUseLoggingLevel</value>
    </values>
    <values>
        <field>Value__c</field>
        <value xsi:type="xsd:string">//MethodCallExpression[lower-case(@FullMethodName)=&apos;system.debug&apos;][count(*)=2
    or ($strictMode=true() and count(*)=3 and lower-case(VariableExpression/@Image)=&apos;debug&apos;)]</value>
    </values>
</CustomMetadata>
