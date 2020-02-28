<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>xpath</label>
    <protected>false</protected>
    <values>
        <field>Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Rule__c</field>
        <value xsi:type="xsd:string">OneDeclarationPerLine</value>
    </values>
    <values>
        <field>Value__c</field>
        <value xsi:type="xsd:string">//VariableDeclarationStatements  [count(VariableDeclaration) &gt; 1]  [$strictMode or count(distinct-values(VariableDeclaration/@BeginLine)) != count(VariableDeclaration)] |  //FieldDeclarationStatements  [count(FieldDeclaration) &gt; 1]  [$strictMode or count(distinct-values(FieldDeclaration/VariableExpression/@BeginLine)) != count(FieldDeclaration/VariableExpression)]</value>
    </values>
</CustomMetadata>
