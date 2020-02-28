<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexUnitTestMethodShouldHaveIsTestAnnota</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.bestpractices.ApexUnitTestMethodShouldHaveIsTestAnnotationRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Apex test methods should have @isTest annotation. As testMethod keyword is deprecated, Salesforce advices to use @isTest annotation for test class/methods.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">@isTest
private class ATest {
    @isTest
    static void methodATest() {
    }
    static void methodBTest() {
    }
    @isTest static void methodCTest() {
        System.assert(1==2);
    }
    @isTest static void methodCTest() {
        System.debug(&apos;I am a debug statement&apos;);
    }
    private void fetchData() {
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#apexunittestmethodshouldhaveistestannotation</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Apex test methods should have @isTest annotation (not testMethod).</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">unit_testing</value>
    </values>
</CustomMetadata>
