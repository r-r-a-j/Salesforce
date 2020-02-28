public class CodeAnalysis 
{
    private final String strXML_PROPERTIES = '</properties>';
    
	public static void generate(Id idCode)
    {
        List<String> lstFileName = new List<String>();
        try 
        {
            //get all Rulesets for this code scan
            List<Rule_Set__c> lstRuleSet = [SELECT   id
                                                    ,Name
                                                    ,Active_Rules__c
                                            FROM 	Rule_Set__c 
                                            WHERE 	Code_Analysis__c =:idCode];

            For (Rule_Set__c objRuleSet :lstRuleSet)
            {
                //only generate a file if there are Active rules
                If (objRuleSet.Active_Rules__c > 0)
                {
                    //get all Rules for this RuleSet
                    List<Rule__c> lstRule = [SELECT XML_Format__c
                                                    ,Name
                                                    ,No_Of_Properties__c
                                            FROM 	Rule__c 
                                            WHERE 	Rule_Set__c =:objRuleSet.id
                                            AND 	Active__c = TRUE];
                        
                    XmlStreamWriter w = new XmlStreamWriter();
                    w.writeStartDocument(null, '1.0');

                    //Header info 
                    w.writeStartElement('', 'ruleset', '');
                    w.writeAttribute(null, null, 'name', objRuleSet.Name);
                    w.writeAttribute(null, null, 'xmlns', 'http://pmd.sourceforge.net/ruleset/2.0.0');
                    w.writeAttribute(null, null, 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
                    w.writeAttribute(null, null, 'xsi:schemaLocation', 'http://pmd.sourceforge.net/ruleset/2.0.0 http://pmd.sourceforge.net/ruleset_2_0_0.xsd');
                    
                    //Description
                    w.writeStartElement(null, 'description', null);
                    w.writeCharacters('Custom Rule Set file for ' + objRuleSet.Name);
                    w.writeEndElement();

                    //get all XML fields from all Rules
                    For(Rule__c objRule :lstRule)
                    {
                        //HACK! This is simply a placeholder...we will need to do a string replacement later on
                        w.writeCharacters('||' + objRule.Name + '||');                  
                    }
                
                    //End XML elements
                    w.writeEndElement(); 
                    w.writeEndDocument();
                    
                    String strXML = w.getXmlString();
                    
                    //loop through the list again to perform the replace on the string version
                    For(Rule__c objRule :lstRule)
                    {
                        String strXMLRule = objRule.XML_Format__c;
                        String strProperties = '';

                        //check to see if this Rule has properties attached to it
                        If(objRule.No_Of_Properties__c > 0)
                        {
                            //get all Property__c for this Rule
                            List<Property__c> lstProperty = [SELECT XML_Format__c
                                                                    ,Name
                                                             FROM 	Property__c 
                                                             WHERE 	Rule__c =:objRule.id];

                            For(Property__c objProperty: lstProperty)
                            {
                                strProperties += objProperty.XML_Format__c;
                            }   

                            //insert the Property__c's into the appropriate place
                            strXMLRule = strXMLRule.replace('<properties></properties>', '<properties>' + strProperties + '</properties>');                                                          
                        }
                        else 
                        {
                            //no properties exist, so remove the "<properties></properties>" tags
                            strXMLRule = strXMLRule.replace('<properties></properties>', '');     
                        }

                        strXML = strXML.replace('||' + objRule.Name + '||', strXMLRule);              
                    }
                                
                    System.debug(strXML);

                    //Create the document & add the FileName_DTTM.xml to a list
                    lstFileName.add(Utils.createFile(idCode, objRuleSet.Name, strXML)); 

                    w.close();   
                }
            } 
            //update the entire class path of rules
            List<Code_Analysis__c> lstCodeAnalysis = [SELECT id
                                                            ,PMD_Class_Path__c
                                                            ,Rules_Path__c
                                                            ,Command__c
                                                            ,Source_Files_Path__c
                                                            ,Report_Type__c
                                                            ,Report_Location__c
                                                      FROM 	 Code_Analysis__c 
                                                      WHERE  id =:idCode LIMIT 1];
            
            List<Code_Analysis__c> lstCodeAnalysisToUpdate = new List<Code_Analysis__c>();

            for (Code_Analysis__c objCodeAnalysis: lstCodeAnalysis)
            {
                Integer i = 0;

                for (String strFileName: lstFileName)
                {
                    If(i > 0)
                    {
                        objCodeAnalysis.Rules_Path__c += ',' + objCodeAnalysis.PMD_Class_Path__c + '\\' + strFileName;
                    }
                    else
                    {
                        objCodeAnalysis.Rules_Path__c = objCodeAnalysis.PMD_Class_Path__c + '\\' + strFileName;
                    }
                    i++;
                }
                objCodeAnalysis.Command__c = 'pmd.bat' 
                                                + ' -d "' + objCodeAnalysis.Source_Files_Path__c + '"'
                                                + ' -R "' + objCodeAnalysis.Rules_Path__c + '"'
                                                + ' -f ' + objCodeAnalysis.Report_Type__c 
                                                + ' -reportfile "' + objCodeAnalysis.Report_Location__c + '"';
                lstCodeAnalysisToUpdate.add(objCodeAnalysis);
                System.debug('>>>>>>>>' + objCodeAnalysis.Rules_Path__c); 
            } 
            update lstCodeAnalysisToUpdate;                                             
        } 
        catch (Exception ex) 
        {
            
        }
    }
	public static void Doc(Id idCode)
    {
        //Create the document
       /**  Document doc = new Document();
        doc.Name = 'ComplexRR';
        doc.ContentType = 'text/plain';
        doc.Type = 'xml';
        //doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = '00l1t000001MmWdAAK';
        
        //String bodyStr = 'Hello World<Test>Value</Test>';
        Blob body = Blob.valueOf(strXML);
        doc.Body = body;
        insert doc;   
        */       
    } 

    public static String test()
    {
        return 'Works';   
    }
}