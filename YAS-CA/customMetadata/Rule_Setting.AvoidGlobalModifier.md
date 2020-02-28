<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidGlobalModifier</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.bestpractices.AvoidGlobalModifierRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">lobal classes should be avoided (especially in managed packages) as they can never be deleted or changed in signature. Always check twice if something needs to be global.
Many interfaces (e.g. Batch) required global modifiers in the past but don&apos;t require this anymore. Don&apos;t lock yourself in.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">global class Unchangeable {
	global UndeletableType unchangable(UndeletableType param) {
		// ...
	}
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_bestpractices.html#avoidglobalmodifier</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Avoid using global modifier</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">bestpractices</value>
    </values>
</CustomMetadata>
