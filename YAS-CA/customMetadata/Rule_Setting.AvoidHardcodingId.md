<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidHardcodingId</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.errorprone.AvoidHardcodingIdRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">When deploying Apex code between sandbox and production environments, or installing Force.com AppExchange packages, it is essential to avoid hardcoding IDs in the Apex code. By doing so, if the record IDs change between environments, the logic can dynamically identify the proper data to operate against and not fail.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public without sharing class Foo {
    void foo() {
        //Error - hardcoded the record type id
        if(a.RecordTypeId == &apos;012500000009WAr&apos;){
            //do some logic here.....
        } else if(a.RecordTypeId == &apos;0123000000095Km&apos;){
            //do some logic here for a different record type...
        }
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#avoidhardcodingid</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Hard coding of IDs is prohibited</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">5.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">errorprone</value>
    </values>
</CustomMetadata>
