/**
 * This class represents the response
 * recieved from the List View APIs 
 * which the Salesforce offers.
 * 
 * @author      Shruti Sridharan
 * @since       11/05/2017
 * @revisions   N/A
 */
public class ListViewsResponse {
    public Boolean done;
    public List<ListView> listviews;
    public Object nextRecordsUrl;
    public Integer size;
    public String sobjectType;

    public class ListView {
        public String describeUrl;
        public String developerName;
        public String id;
        public String label;
        public String resultsUrl;
        public Boolean soqlCompatible;
        public String url;
    }
    
    public static ListViewsResponse parse( String json ) {
        return ( ListViewsResponse ) System.JSON.deserialize( json, ListViewsResponse.class );
    }
}