/**
 * This class will be utilised by
 * all the Remote Action methods 
 * to return it's instance back to
 * JavaScript.
 * 
 * @author      Shruti
 * @since       18/10/2016
 * @revisions   N/A
 */
global class ActionResponse {
    public Boolean status               { get; set; }
    public String message               { get; set; }
    
    public Object datum                 { get; set; }
    
    /**
     * List of Standard or Custom
     * Object Records.
     */
    public List<SObject> dataRecords    { get; set; }
    
    /**
     * List of user-defined class
     * instances.
     */
    public List<Object> dataCustom      { get; set; }
    
    public ActionResponse() {

    }
    
    public ActionResponse( Boolean status, String message, Object datum ) {
        this.status     = status;
        this.message    = message;
        this.datum      = datum;
    }
    
    /**
     * Constructor utilised when an
     * error occurs.
     */
    public ActionResponse( Boolean status, String message ) {
        this.status     = status;
        this.message    = message;
    }
    
    /**
     * Constructor utilised when
     * a list of standard or custom 
     * object records are returned.
     */
    public ActionResponse( Boolean status, String message, List<SObject> dataRecords ) {
        this.status         = status;
        this.message        = message;
        this.dataRecords    = dataRecords;
        this.dataCustom     = NULL;
    }
    
    /**
     * Constructor utilised when
     * a list of instances of a 
     * user-defined class is returned.
     */
    public ActionResponse( Boolean status, String message, List<Object> dataCustom ) {
        this.status         = status;
        this.message        = message;
        this.dataRecords    = NULL;
        this.dataCustom     = dataCustom;
    }
}