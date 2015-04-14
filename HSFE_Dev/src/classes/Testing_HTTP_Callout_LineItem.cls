public class Testing_HTTP_Callout_LineItem {

public String org{get;set;}

public Static List<String> XMLData{get;set;}

public Testing_HTTP_Callout_LineItem(){
	XMLData=new List<String>();
}
    
@future (callout=true)    
public static void getOrganisationInfo(String ip){ 
    
    Http http = new Http();
    
    HttpRequest req = new HttpRequest();
    
    req.setEndpoint('http://xml.utrace.de/?query='+ip);
    
    req.setMethod('GET');
    
    HttpResponse res = http.send(req);
    
    // Log the XML content
    
    String xmlContent=res.getBody();
    
    System.debug(res.getBody());
    
    System.debug('#####XmlStreamReader ##11##');
    
    // Generate the HTTP response as an XML stream
    
    XmlStreamReader reader = res.getXmlStreamReader();
    
    System.debug('##########XML DATA##########'+res.getXmlStreamReader());
    
    XMLData=XMLParser(res.getBody());
    
    System.debug('#### XMLData ##########3' + XMLData);

}

public static List<String> XMLParser(String strXml){

	System.debug('####Inside XMLParser Method########'+strXml);
    
    List<String> orgInfo=new List<String>();
    
    Dom.Document doc = new Dom.Document();
    
    doc.load(strXml);
    
    //Retrieve the root element for this document.
    
    Dom.XMLNode Envelope = doc.getRootElement();
    
    Dom.XMLNode Body= Envelope.getChildElements()[0];
    
    string user_createResult = '';
    
    for(Dom.XMLNode child : Body.getChildElements()) {
    
    orgInfo.add(child .getText());

	}

	return orgInfo;

}

}