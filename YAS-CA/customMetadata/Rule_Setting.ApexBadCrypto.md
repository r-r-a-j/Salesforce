<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ApexBadCrypto</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.security.ApexBadCryptoRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">The rule makes sure you are using randomly generated IVs and keys for Crypto calls. Hard-wiring these values greatly compromises the security of encrypted data.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public without sharing class Foo {
    Blob hardCodedIV = Blob.valueOf(&apos;Hardcoded IV 123&apos;);
    Blob hardCodedKey = Blob.valueOf(&apos;0000000000000000&apos;);
    Blob data = Blob.valueOf(&apos;Data to be encrypted&apos;);
    Blob encrypted = Crypto.encrypt(&apos;AES128&apos;, hardCodedKey, hardCodedIV, data);
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_security.html#apexbadcrypto</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Hard coded Cryto keys detected</value>
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
