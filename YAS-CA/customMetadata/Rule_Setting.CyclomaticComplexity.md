<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CyclomaticComplexity</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">net.sourceforge.pmd.lang.apex.rule.design.CyclomaticComplexityRule</value>
    </values>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">The complexity of methods directly affects maintenance costs and readability. Concentrating too much decisional logic in a single method makes its behaviour hard to read and change.

Cyclomatic complexity assesses the complexity of a method by counting the number of decision points in a method, plus one for the method entry. Decision points are places where the control flow jumps to another place in the program. As such, they include all control flow statements, such as: if ;while ;for and case;.

Generally, numbers ranging from 1-4 denote low complexity, 5-7 denote moderate complexity, 8-10 denote high complexity, and 11+ is very high complexity. By default, this rule reports methods with a complexity = 10. Additionnally, classes with many methods of moderate complexity get reported as well once the total of their methods ; complexities reaches 40, even if none of the methods was directly reported.

Reported methods should be broken down into several smaller methods. Reported classes should probably be broken down into subcomponents.</value>
    </values>
    <values>
        <field>Example__c</field>
        <value xsi:type="xsd:string">public class Complicated {
  public void example() { // This method has a cyclomatic complexity of 12
    int x = 0, y = 1, z = 2, t = 2;
    boolean a = false, b = true, c = false, d = true;
    if (a &amp;&amp; b || b &amp;&amp; d) {
      if (y == z) {
        x = 2;
      } else if (y == t &amp;&amp; !d) {
        x = 2;
      } else {
        x = 2;
      }
    } else if (c &amp;&amp; d) {
      while (z &lt; y) {
        x = 2;
      }
    } else {
      for (int n = 0; n &lt; t; n++) {
        x = 2;
      }
    }
  }
}</value>
    </values>
    <values>
        <field>External_Info_URL__c</field>
        <value xsi:type="xsd:string">https://pmd.github.io/latest/pmd_rules_apex_design.html#cyclomaticcomplexity</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">Class and/or Method is too complex</value>
    </values>
    <values>
        <field>Priority__c</field>
        <value xsi:type="xsd:double">4.0</value>
    </values>
    <values>
        <field>Rule_Set__c</field>
        <value xsi:type="xsd:string">design</value>
    </values>
</CustomMetadata>
