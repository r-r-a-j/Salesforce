trigger RuleTrigger on Rule__c (before insert, before update) 
{
   // List<Rule__c> lstRuleSet = new List<Rule__c>();
    
    //loop through all Rule Sets
    For(Rule__c objRule: Trigger.New)
    {
        //skip if not Active
        If (objRule.Active__c)
        {
            /**
                The code below wraps up the contents of Rule__c and assembles the details
                into an XML compliant string. It then stores this string in 
                Rule__c.XML_Format__c
                The parent of Rule__c (Code_Analysis__c) will later retrieve Rule__c.XML_Format__c 
                and assemble a much larget XML doc, and save it to it's File related list
             */
            XmlStreamWriter w = new XmlStreamWriter();
            //w.writeStartDocument(null, '1.0');
    
            //Header info 
            w.writeStartElement('', 'rule', '');
            w.writeAttribute(null, null, 'name', objRule.Name);
            w.writeAttribute(null, null, 'language', 'apex');
            w.writeAttribute(null, null, 'message', objRule.Message__c);
            w.writeAttribute(null, null, 'class', objRule.Class__c);
            w.writeAttribute(null, null, 'externalInfoUrl', objRule.External_Info_URL__c);

            //Description
            w.writeStartElement(null, 'description', null);
            w.writeCharacters(objRule.Description__c);
            w.writeEndElement();
  
            //Priority
            w.writeStartElement(null, 'priority', null);
            //for some reason, [objRule.Priority__c] is interpretted as a Decimal value, and PMD complains if the Decimal
            //is in the <Priority> field in the XML. Explicitly remove.
            String strPriority = '' + objRule.Priority__c;
            w.writeCharacters('' + strPriority.substringBefore('.'));
            w.writeEndElement();

            //Properties - this is a placeholder. It may be removed at a later stage
            w.writeStartElement(null, 'properties', null);
            w.writeEndElement();           

            //Example - wrapped up in CDATA tag
            w.writeStartElement(null, 'example', null);
            w.writeCData(objRule.Example__c);
            w.writeEndElement();

            //End XML elements
            w.writeEndElement(); 
            w.writeEndDocument();
            
            objRule.XML_Format__c = w.getXmlString();
            //lstRuleSet.add(objRule);
            w.close();    
        }
    }
}
