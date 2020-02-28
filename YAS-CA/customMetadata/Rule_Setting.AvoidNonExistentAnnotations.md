<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidNonExistentAnnotations</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.errorprone.AvoidNonExistentAnnotationsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Apex supported non existent annotations for legacy reasons. In the future, use of such non-existent annotations could result in broken apex code that will not compile. This will prevent users of garbage annotations from being able to use legitimate annotations added to Apex in the future. A full list of supported annotations can be found at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation.htm</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">@NonExistentAnnotation public class ClassWithNonexistentAnnotation {
  @NonExistentAnnotation public void methodWithNonExistentAnnotation() {
    // ...
  }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_errorprone.html#avoidnonexistentannotations</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Avoid using old and/or non-existing annotations&quot; class=&quot;net.sourceforge.pmd.lang.apex.rule.errorprone.AvoidNonExistentAnnotationsRule</value>
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
