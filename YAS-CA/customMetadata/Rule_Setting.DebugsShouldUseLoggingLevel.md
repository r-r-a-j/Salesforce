<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>DebugsShouldUseLoggingLevel</label>
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
        <value xsi:type="xsd:string">Having the Logging Level specified provides a cleaner log, and improves readability of it</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">@isTest
public class Foo {
    @isTest
    static void bar() {
        System.debug(&apos;Hey this code executed.&apos;); // not good
        System.debug(LoggingLevel.WARN, &apos;Hey, something might be wrong.&apos;); // good
        System.debug(LoggingLevel.DEBUG, &apos;Hey, something happened.&apos;); // not good when on strict mode
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#debugsshoulduselogginglevel</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">The first parameter of System.debug, when using the signature with two parameters, is a LoggingLevel enum.</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">bestpractices</value>
    </values>
</CustomMetadata>
