<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexUnitTestShouldNotUseSeeAllDataTrue</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.bestpractices.ApexUnitTestShouldNotUseSeeAllDataTrueRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Apex unit tests should not use @isTest(seeAllData=true) because it opens up the existing database data for unexpected modification by tests.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">@isTest(seeAllData = true)
public class Foo {
   public static testMethod void testSomething() {
      Account a = null;
   // This is better than having a NullPointerException
   // System.assertNotEquals(a, null, &apos;account not found&apos;);
   a.toString();
   }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#apexunittestshouldnotuseseealldatatrue</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Apex unit tests should not use @isTest(seeAllData=true)</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">1.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">unit_testing</value>
    </values>
</CustomMetadata>
