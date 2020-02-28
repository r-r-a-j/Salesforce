trigger PropertyTrigger on Property__c (before insert, before update) 
{
  For(Property__c objProperty: Trigger.New)
    {

        /**
            The code below wraps up the contents of Property__c and assembles the details
            into an XML compliant string. It then stores this string in 
            Property__c.XML_Format__c
            The grand parent of Property__c (Code_Analysis__c) will later retrieve Property__c.XML_Format__c 
            and assemble a much larget XML doc, and save it to it's File related list
        */
        XmlStreamWriter w = new XmlStreamWriter();

        //Start "Property" 
        w.writeStartElement('', 'property', '');
        w.writeAttribute(null, null, 'name', objProperty.Name);

        //if the property is xpath, then we need to encase within an CDATA block
        if(objProperty.Name == 'xpath')
        {
            //value/XPath syntax - wrapped up in CDATA tag
            w.writeStartElement(null, 'value', null);
            w.writeCData(objProperty.Value__c);
            w.writeEndElement();  
        }
        else if(objProperty.Name == 'strictMode')
        {
            w.writeAttribute(null, null, 'type', 'Boolean');
            w.writeAttribute(null, null, 'value', objProperty.Value__c);
            w.writeAttribute(null, null, 'description', 'If true, mark combined declaration even if the declarations are on separate lines.');
        }
        else 
        {
            //simply write the Value__c has an attribute - no need for a separate element
            w.writeAttribute(null, null, 'value', objProperty.Value__c);           
        } 

        //End "Property"
        w.writeEndElement(); 
        
        objProperty.XML_Format__c = w.getXmlString();
        w.close();    
    }
}