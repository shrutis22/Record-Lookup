/**
 * This class is created to make calls
 * to List View APIs which Salesforce
 * offers to get the List View details
 * of a particular object.
 * 
 * @author      Shruti Sridharan
 * @since       11/05/2017
 * @revisions   N/A
 */
public class ListViewAPI {
    /**
     * This method is created to make request
     * to the List View APIs with the object 
     * name to get the List Views in that
     * object.
     * 
     * @param       sObjectName         The name of the Object
     *                                  whose List Views are 
     *                                  required.
     * 
     * @return      ListViewsResponse   Returns an instance of the
     *                                  'ListViewsResponse' class
     *                                  which contains the List Views
     *                                  existing in the selected
     *                                  Object.
     */
    public static ListViewsResponse getListViews( String sObjectName ) {
        Http http = new Http();
        HttpRequest httpReq = new  HttpRequest();
        
        String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
        
        String endpoint = orgDomain + '/services/data/v37.0/sobjects/' + sObjectName + '/listviews';
        
        httpReq.setEndpoint( endpoint );
        httpReq.setMethod( 'GET' );
        httpReq.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
        httpReq.setHeader( 'Accept', 'application/json' );
        
        String sessionId = 'Bearer ' + UserInfo.getSessionId();
        
        httpReq.setHeader( 'Authorization', sessionId );
        
        HttpResponse httpRes = http.send( httpReq );
        
        ListViewsResponse listViewResp = ( ListViewsResponse ) JSON.deserialize( httpRes.getBody(), ListViewsResponse.class );
        
        return listViewResp;
    }
    
    /**
     * This method is created to get the Query 
     * to obtain records from a particular object
     * 
     * @param       listViewId      Recieves the List 
     *                              View Id whichever
     *                              the User wants.
     * 
     * @param       objName         The name of the SObject.
     * 
     * @return      String          Returns the query
     *                              for the particular
     *                              List View.
     */
    public static String getListViewQuery( String listViewId, String objName ) {
        Http http = new Http();
        HTTPRequest httpReq = new HTTPRequest();
        String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
        
        String endpoint = orgDomain + '/services/data/v37.0/sobjects/' + objName + '/listviews/' + listViewId + '/describe';
        
        httpReq.setEndpoint( endpoint );
        httpReq.setMethod( 'GET' );
        httpReq.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
        httpReq.setHeader( 'Accept', 'application/json' );
        
        String sessionId = 'Bearer ' + UserInfo.getSessionId();
        
        httpReq.setHeader( 'Authorization', sessionId );
        
        HTTPResponse httpRes = http.send( httpReq );
        
        ListViewsDescribeResponse listViewDescResp = ( ListViewsDescribeResponse ) JSON.deserialize( httpRes.getBody(), ListViewsDescribeResponse.class );
        
        return listViewDescResp.query;
    }
    
    /**
     * This method is created to describe a
     * ListView given it's List Vew Id and
     * the Object Name.
     * 
     * @param       listViewId                  Recieves the List 
     *                                          View Id whichever
     *                                          the User wants and the
     *                                          one that needs to be
     *                                          described.
     * 
     * @param       objName                     The name of the SObject.
     * 
     * @return      ListViewsDescribeResponse   Details of the List View
     */
    public static ListViewsDescribeResponse describeListView( String listViewId, String objName ) {
        Http http = new Http();
        HTTPRequest httpReq = new HTTPRequest();
        String orgDomain = Url.getSalesforceBaseUrl().toExternalForm();
        
        String endpoint = orgDomain + '/services/data/v37.0/sobjects/' + objName + '/listviews/' + listViewId + '/describe';
        
        httpReq.setEndpoint( endpoint );
        httpReq.setMethod( 'GET' );
        httpReq.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
        httpReq.setHeader( 'Accept', 'application/json' );
        
        String sessionId = 'Bearer ' + UserInfo.getSessionId();
        
        httpReq.setHeader( 'Authorization', sessionId );
        
        HTTPResponse httpRes = http.send( httpReq );
        
        ListViewsDescribeResponse listViewDescResp = ( ListViewsDescribeResponse ) JSON.deserialize( httpRes.getBody(), ListViewsDescribeResponse.class );
        
        return listViewDescResp;
    }
}