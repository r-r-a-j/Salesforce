<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexCRUDViolation</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexCRUDViolationRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">The rule validates you are checking for access permissions before a SOQL/SOSL/DML operation.
Since Apex runs in system mode not having proper permissions checks results in escalation of 
privilege and may produce runtime errors. This check forces you to handle such scenarios.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Foo {
    public Contact foo(String status, String ID) {
        Contact c = [SELECT Status__c FROM Contact WHERE Id=:ID];

        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Contact.fields.Name.isUpdateable()) {
            return null;
        }

        c.Status__c = status;
        update c;
        return c;
    }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/pmd-5.8.1/rules/apex/security.html#ApexCRUDViolationRule</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Insecure method of accessing data without cross referencing CRUD permissions</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">1.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">security</value>
    </values>
</CustomMetadata>
