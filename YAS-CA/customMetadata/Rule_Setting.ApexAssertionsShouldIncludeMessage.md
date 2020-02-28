<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexAssertionsShouldIncludeMessage</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.bestpractices.ApexAssertionsShouldIncludeMessageRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">The second parameter of System.assert/third parameter of System.assertEquals/System.assertNotEquals is a message. Having a second/third parameter provides more information and makes it easier to debug the test failure and improves the readability of test output.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">@isTest
public class Foo {
     @isTest
    static void methodATest() {
        System.assertNotEquals(&apos;123&apos;, o.StageName); // not good
        System.assertEquals(&apos;123&apos;, o.StageName, &apos;Opportunity stageName is wrong.&apos;); // good
        System.assert(o.isClosed); // not good
        System.assert(o.isClosed, &apos;Opportunity is not closed.&apos;); // good
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#apexassertionsshouldincludemessage</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">For each Assertion, include a message about the failure.</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">unit_testing</value>
    </values>
</CustomMetadata>
