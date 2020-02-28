public class Utils 
{
   /**
        DESCRIPT    : Remove prefix directory path 
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static String trimDir(String strDir)
    {
        //intialise to incoming string, so if there is no last "\" found, then the the same arg is returned
        String strRet = strDir;
        Integer intLastIndex = -1;
        intLastIndex = strDir.lastIndexOf('\\');

        If (intLastIndex > -1)
        {
             strRet = strDir.substring(intLastIndex + 1, strDir.length());
        }
        return strRet; 
    } 

    /**
        DESCRIPT    : Uploads a Document into the ContentFolder
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
     */
    public static String createFile(Id idRecord, String strFileName, String strXML)
    {
        try 
        {
            //Step 1 - create & insert a [ContentVersion]
            ContentVersion cv = new ContentVersion();
            String srtDTTM = '' + Datetime.now().getTime();
            cv.Title = strFileName + '_' + srtDTTM + '.xml';
            cv.PathOnClient = strFileName + '_' + srtDTTM + '.xml';
            //"S" = Doc is in SF
            //"E" = Doc is external
            cv.ContentLocation = 'S';

            //NOT NEEDED - leave blank
            //cv.ContentDocumentId = idDocContenent;
            
            //Set payload
            cv.VersionData = Blob.valueOf(strXML);
            insert cv;

            //Step 2 - create & insert a [ContentDocumentLink]
            ContentDocumentLink cdl = new ContentDocumentLink();
            //we need to query the DB to get the inserts [ContentVersion]
            cdl.ContentDocumentId = [SELECT Id
                                            ,ContentDocumentId 
                                    FROM   ContentVersion 
                                    WHERE  Id =:cv.Id].ContentDocumentId;
            //set link Record
            cdl.LinkedEntityId = idRecord;
            cdl.Visibility = 'AllUsers';
            //"I" = Inferred permission (checkout description of ContentDocumentLink object for more details)
            cdl.ShareType = 'I';
            insert cdl;     
            return cv.Title;       
        } 
        catch (Exception ex) 
        {
            System.debug('Error in Utils.createDoc()');
            return 'Error';
        }
    }
   
    /**
        DESCRIPT    : Extracts CDATA data and returns a map
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static Map<Integer, String> extractCDATA(String strPayload)
    {
        Map<Integer, String> myMap = new Map<Integer, String>(); 

        Integer intIndexEnd = 0;
        Integer intIndexStart = 0;
        String strCDATAOld = '';
        String strCDATANew = '';
        String strPiece = '';
        String strNewPayload = '';
        Integer intPayloadSize = strPayload.length();
        Boolean blnEOF = false;
        Integer intCount = 0;

        try
        {
            //System.debug('>>>>>>>>>>>> 001 ');
            strPayload = strPayload.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );

            //System.debug('>>>>>>>>>>>>  ' + strPayload);
            while (!blnEOF)
            {
                //System.debug('>>>>>>>>>>>>  strNewPayload : ' + strNewPayload);
                //get the beginning  
                intIndexEnd = strPayload.indexOf('XML_CDATA_END', intIndexStart);
                //System.debug('>>>>>>>>>>>> intIndexEnd ' + intIndexEnd);

                If (intIndexEnd < 0)
                {
                    blnEOF = true;
                }
                else
                {
                    intCount++;
                    intIndexEnd = intIndexEnd + 13; //13 = sizeOf('XML_CDATA_END') 
                    strPiece = strPayload.substring(intIndexStart, intIndexEnd); 

                    //System.debug('>>>>>>>>>>>> 03 strPiece ' + strPiece);

                    //get occurance of "XML_CDATA_START"
                    strCDATANew = strPiece.substringBetween('XML_CDATA_START', 'XML_CDATA_END').escapeXML().replaceAll('\\$', 'XML_DOLLAR');

                    //do the 2 lines below seperately as its needed in the -1 state
                    strPiece = strPiece.replaceFirst(strCDATAOld, strCDATANew);
                    myMap.put(intCount, strCDATANew);

                    strNewPayload += strPiece;
                    intIndexStart = intIndexEnd;
                }
            }
        }
        catch (System.XmlException ex) 
        {
            System.debug('System.XmlException (Utils.extractCDATA()): ' + ex.getMessage());
        }        
        catch (Exception ex) 
        {
            System.debug('General Exception (Utils.extractCDATA()): ' + ex.getMessage());
        }

        return myMap; 
    } 
        
    /**
        DESCRIPT    : The apex XMLNode code doesn't allow CDATA to be parsed, therefore a workaround is needed.
                      This method takes a String payload, removes the CDATA tags and then manually escapes the XML
                      elements (therefore negating the need of the CDATA tags in the first place).
                      Note: RegEx and Pattern Matchers were tried but the compiler complained about the RegEx being too complex. 
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static String escapeCDATA(String strPayload)
    {
        Integer intIndexEnd = 0;
        Integer intIndexStart = 0;
        String strCDATAOld = '';
        String strCDATANew = '';
        String strPiece = '';
        String strNewPayload = '';
        Integer intPayloadSize = strPayload.length();
        Boolean blnEOF = false;
        Integer intCount = 0;

        //System.debug('>>>>>>>>>>>> 001 ');
        strPayload = strPayload.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );

        //System.debug('>>>>>>>>>>>>  ' + strPayload);
        while (!blnEOF)
        {
            //System.debug('>>>>>>>>>>>>  strNewPayload : ' + strNewPayload);
            //get the beginning  
            intIndexEnd = strPayload.indexOf('XML_CDATA_END', intIndexStart);

            //System.debug('>>>>>>>>>>>> intIndexEnd ' + intIndexEnd);

            If (intIndexEnd < 0)
            {
                intIndexStart = intCount * 13;
                //no more CDATA so simply gather the rest of the file until the end
                //System.debug('>>>>>>>>>>>> 10 intIndexStart ' + intIndexStart);
                strNewPayload += strPiece.substring(intIndexStart);
               // System.debug('>>>>>>>>>>>> 02 strNewPayload ' + strNewPayload);
                blnEOF = true;
                //break;
            }
            else
            {
                intCount++;
                intIndexEnd = intIndexEnd + 13; //13 = sizeOf('XML_CDATA_END') 
                strPiece = strPayload.substring(intIndexStart, intIndexEnd); 

                //System.debug('>>>>>>>>>>>> 03 strPiece ' + strPiece);

                //get occurance of "XML_CDATA_START"
                strCDATAOld = strPiece.substringBetween('XML_CDATA_START', 'XML_CDATA_END');
                strCDATANew = strCDATAOld.escapeXML();
                //System.debug('>>>>>>>>>>>> 04 strCDATAOld ' + strCDATAOld);
                //System.debug('>>>>>>>>>>>> 05 strCDATANew ' + strCDATANew);
                
                //do the 2 lines below seperately as its needed in the -1 state
                strPiece = strPiece.replaceFirst(strCDATAOld, strCDATANew);
                strNewPayload += strPiece;
                intIndexStart = intIndexEnd;
            }
        }
        return strPayload; 
    } 

   /**
        DESCRIPT    : Read an XML Document from ContentVersion/Files 
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static void readXML(Id idRecord)
    {
        integer intDupes = 0;
        integer intDupeLines = 0;
        integer intDupeStart = 0;
        string strClass = '';
        boolean blnRecordCreated = false;
        List<Duplication__c> lstDuplication = new List<Duplication__c>();
        Integer intCount = 0;
        Integer intClassCount = 0;

        try 
        {
            //Read the ContentVersion from Files
            ContentVersion cv = [SELECT VersionData 
                                 FROM   ContentVersion 
                                 WHERE  ContentDocumentId = :idRecord 
                                 AND    IsLatest = true];

            String strPayLoad = cv.VersionData.toString();
            
            //excape CDATA before loading into DOM
            Map<Integer, String> myMap = new Map<Integer, String>(); 
            myMap = Utils.extractCDATA(strPayLoad);

            //parse into XML world
            DOM.Document doc = new DOM.Document();
            doc.load(strPayLoad);

            //Start with the root element
            DOM.XmlNode rootNode = doc.getRootElement();
            System.debug('rootNode = ' + rootNode.getName()); 

            //loop all child elements from the root
            for (Dom.XMLNode xmlDuplication: rootNode.getChildElements()) 
            {
                Integer intFile = 0;

                if (xmlDuplication.getNodeType() == DOM.XMLNodeType.ELEMENT)
                {
                    if (xmlDuplication.getName() == 'duplication')
                    {
                        intClassCount = 0;
                        Duplication__c objDuplication = new Duplication__c();
                        intDupeLines = Integer.valueOf(xmlDuplication.getAttributeValue('lines', ''));
                        System.debug('Total lines of Duplication = ' + String.valueOf(intDupeLines)); 
                        objDuplication.Duplicated_Lines__c = intDupeLines;

                        //loop any children of <duplication>. There is likely to be <file> and <codefragment>
                        for (Dom.XMLNode xmlDupeChildren: xmlDuplication.getChildElements()) 
                        {
                            if (xmlDupeChildren.getNodeType() == DOM.XMLNodeType.ELEMENT)
                            {
                                switch on (xmlDupeChildren.getName()) 
                                {
                                    when 'file' 
                                    {	
                                        intClassCount++;
                                        //System.debug('intFile = ' + intFile);

                                        strClass = Utils.trimDir(xmlDupeChildren.getAttributeValue('path', ''));
                                        intDupeStart = Integer.valueOf(xmlDupeChildren.getAttributeValue('line', ''));	
                                        objDuplication.Classes__c += strClass + ' (Lines ' + String.valueOf(intDupeStart) 
                                                                       + ' to ' + String.valueOf(intDupeStart + intDupeLines) + ') \n';

                                        System.debug('>>>>>>>>>>>>> '+ objDuplication.Classes__c); 	
                                    }	
                                    when 'codefragment' 
                                    {	
                                        intCount++;
                                        objDuplication.Code__c = myMap.get(intCount);
                                        System.debug('>>>>>>>>>>>>> CDATA '+ myMap.get(intCount)); 
                                    }
                                    when else 
                                    {		  
                                        //do nothing
                                    }
                                }
                            }
                        }
                       objDuplication.Class_Count__c = intClassCount;
                       lstDuplication.add(objDuplication); 
                    }              
                }
            }            

            //insert records
            Copy_Paste_Scan__c objCopyAndPaste = new Copy_Paste_Scan__c();
            insert objCopyAndPaste;

            //update all parent Ids before insertion
            for(Duplication__c objDuplication :lstDuplication)
            {
                objDuplication.Copy_Paste_Scan__c = objCopyAndPaste.Id;
            }
            insert lstDuplication;
        } 
        catch (System.XmlException ex) 
        {
            System.debug('System.XmlException (Utils.readXML()): ' + ex.getMessage());
        }        
        catch (Exception ex) 
        {
            System.debug('General Exception (Utils.readXML()): ' + ex.getMessage());
        }
    }

    /**
        *****************WORK IN PROGRESS*****************
    */
    public static void test1(Id idRecord)
    {
        
        List<Duplication__c> lstDuplicates = new List<Duplication__c>();
        integer intDupes = 0;
        integer intDupeLines = 0;
        integer intDupeStart = 0;
        string strClass = '';
        boolean blnRecordCreated = false;
        List<Duplication__c> lstDuplication = new List<Duplication__c>();
        String strPayLoad = '';
        try 
        {
            //Read the ContentVersion from Files
            ContentVersion cv = [SELECT VersionData 
                                 FROM   ContentVersion 
                                 WHERE  ContentDocumentId = :idRecord 
                                 AND    IsLatest = true];

            strPayLoad = cv.VersionData.toString();
            strPayLoad = Utils.escapeCDATA(strPayLoad);
            System.debug('++++++++ Escaped Payload ' + strPayLoad);
        }
        catch (Exception ex) 
        {
            System.debug('General Exception (Utils.readXML()): ' + ex.getMessage());
        }
        System.debug('++++++++ 003');
        //excape CDATA before loading into DOM
           // return Utils.escapeCDATA(strPayLoad);
    }

    /**
        DESCRIPT    : @Deprecated
                      This uses the XMLStreamReader to parse an XML document. This is lower level and is buggy.
                      Preferred method is to use the DOM.Document object model instead.
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static void readXMLStreamReader(Id idRecord, Boolean blnSimplePrint)
    {
        boolean blnIsNextElementSafe = true;
        integer intCount = 0;
        try 
        {
            //Read the ContentVersion from Files
            ContentVersion cv = [SELECT VersionData 
                                 FROM   ContentVersion 
                                 WHERE  ContentDocumentId = :idRecord 
                                 AND    IsLatest = true];
            String strPayLoad = cv.VersionData.toString();
            
            //parse into XML world
            XmlStreamReader reader = new XmlStreamReader(strPayLoad);

            if (blnSimplePrint)
            {   
                System.debug('>>>>>>>>>>>>>>>>>>>>>>>>  strPayLoad = ' + strPayLoad);
            }
            else
            {
                //loop entire XML tree
                while(blnIsNextElementSafe) 
                {
                    //only process if a valid start XML element
                    if (reader.getEventType() == XmlTag.START_ELEMENT)
                    {
                        if (reader.getLocalName() == 'duplication') 
                        {
                            intCount++;
                            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>  intCount = ' + intCount);
                            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>  <duplication lines="' + reader.getAttributeValue(null, 'lines') 
                                                                + '" tokens="' + reader.getAttributeValue(null, 'tokens') + '">'); 
                        }
                    }
                    
                    //get next node
                    if (reader.hasNext()) 
                    {
                        reader.next();
                        //System.debug('>>>>>>>>> increment : ');
                    } 
                    else 
                    {
                        blnIsNextElementSafe = false;
                        System.debug('>>>>>>>>> break : ');
                        break;
                    }
                }
            }
        } 
        catch (System.XmlException ex) 
        {
            System.debug('System.XmlException (Utils.readXML()): ' + ex.getMessage());
        }        
        catch (Exception ex) 
        {
            System.debug('General Exception (Utils.readXML()): ' + ex.getMessage());
        }
    }

   /**
        DESCRIPT    : @Deprecated
                      This is the preferred method of escaping CDATA elements, but for some reason adding multi lines was an issue
                      for the Apex compiler.
        AUTHOR      : Ravi Raj
        DATE        : Nov 2019
    */
    public static String escapeCDATARegEx(String strPayload)
    {
        // replace CDATA sections with parseable tokens
        //strPayLoad = '<?xml version="1.0" encoding="Cp1252"?><pmd-cpd>   <duplication lines="223" tokens="840"><file line="1211"path="OpportunityTriggerHandler.cls"/><file line="33"path="OpportunityTriggerHelper.cls"/><codefragment><![CDATA[ << Line 1 >> && ]]></codefragment>   </duplication>   <duplication lines="223" tokens="840"><file line="1211"path="OpportunityTriggerHandler.cls"/><file line="33"path="OpportunityTriggerHelper.cls"/><codefragment><![CDATA[ << Line 2 >> & ]]></codefragment>   </duplication>    <duplication lines="223" tokens="840"><file line="1211"path="OpportunityTriggerHandler.cls"/><file line="33"path="OpportunityTriggerHelper.cls"/><codefragment><![CDATA[ << Line 3 >> & ]]></codefragment>   </duplication></pmd-cpd>';

        strPayload = strPayload.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' ); //.replaceAll( '\\n', '' );

        System.debug('++++++++ 005 ' +strPayload);
        // we will build up a map of original text and replacement text
        Map<String, String> replacementMap = new Map<String, String>();

        // regular expression to match sections we want to replace

        //This workes.....
        Pattern myPattern = Pattern.compile( '(XML_CDATA_START)(.*?)(XML_CDATA_END)' );
        //...but adding "(?s)" [multi line] does not.....
        //Pattern myPattern = Pattern.compile( '(XML_CDATA_START)(?s)(.*?)(XML_CDATA_END)' );
       
        Matcher myMatcher = myPattern.matcher( strPayload );

        while ( myMatcher.find() ) {
            System.debug('++++++++ 001 ');
            // the regex was too complicated for Matcher.replaceFirst(..)
            // so have to do it manually so just put in this map the
            // original text and the replacement text, we do replacing later
            replacementMap.put( myMatcher.group(), myMatcher.group(2).escapeXML() );
        }

        // replace in the xml each CDATA section with the escaped XML of its inner content
        for ( String key : replacementMap.keySet() ) {

            System.debug('++++++++ Key = ' + key);
            System.debug('++++++++ Value = ' + replacementMap.get( key ));
            strPayload = strPayload.replace( key, replacementMap.get( key ) );
        }
        return strPayload; 
    } 

}