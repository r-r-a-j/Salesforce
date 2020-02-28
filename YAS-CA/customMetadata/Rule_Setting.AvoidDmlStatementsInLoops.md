<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AvoidDmlStatementsInLoops</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.performance.AvoidDmlStatementsInLoopsRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Avoid DML statements inside loops to avoid hitting the DML governor limit. Instead, try to batch up the data into a list and invoke your DML once on that list of data outside the loop.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Something {
	public void foo() {  
		for (Integer i = 0; i &lt; 151; i++) {
		    Account account;
		    ...
		    insert account;
		}
	}
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_performance.html#avoiddmlstatementsinloops</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Avoid DML statements inside loops</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">5.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">performance</value>
    </values>
</CustomMetadata>
