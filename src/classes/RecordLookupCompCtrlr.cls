/**
 * The Apex Controller will be used
 * for the Record Lookup Component.
 * 
 * @author          Shruti Sridharan
 * @since           11/05/2017
 * @revisions       N/A
 */
global class RecordLookupCompCtrlr {
    global class ListItem {
        public String label { get; set; }
        public String value { get; set; }
        
        public ListItem( String label, String value ) {
            this.label  = label;
            this.value  = value;
        }
    }
    
    global class Field {
        public String label     { get; set; }
        public String name      { get; set; }
        public String value     { get; set; }
        public String dataType  { get; set; }
    }
    
    global class Record {
        public String id            { get; set; }
        public String name          { get; set; }
        public List<Field> fields   { get; set; }
        
        public Record() {
            this.fields = new List<Field>();
        }
    }
    
    /**
     * This method is created to fetch the
     * List Views of an object.
     * 
     * @param       objName         Recieves the name of the
     *                              object whose List Views
     *                              have to be collected
     * 
     * @return      ActionResponse  Returns a list of ListItem
     *                              instances which contains the
     *                              List Views of the respected
     *                              object
     */
    @RemoteAction
    global static ActionResponse fetchListViews( String objName ) {
        try {
            ListViewsResponse lstViewResp = ListViewAPI.getListViews( objName );
            
            List<ListItem> listViews = new List<ListItem>();
            
            listViews.add( new ListItem( 'Global Search', 'sosl' ) );
            
            for( ListViewsResponse.ListView lstView : lstViewResp.listviews ) {
                ListItem lstItem    = new ListItem( lstView.label, lstView.id );
                
                listViews.add( lstItem );
            }
            
            return new ActionResponse( TRUE, NULL, listViews );
        }
        catch( Exception ex ) {
            return new ActionResponse( FALSE, ex.getMessage() );
        }
    }
    
    /**
     * This method is created to fetch recently
     * viewed records of a particular object to
     * display in the Record Lookup Component
     * drop down.
     * 
     * @param       objName         Recieves the name of the object
     * 
     * @return      ActionResponse  Returns a list of records of the
     *                              respected object
     */
    @RemoteAction
    global static ActionResponse fetchDefaultRecords( String objName ) {
        try {
            String selClause        = ' SELECT Id, Name';
            String fromClause       = ' FROM ' + objName;
            String whereClause      = ' WHERE LastViewedDate = THIS_MONTH';
            String limitClause      = ' LIMIT 200';
            
            String query            = selClause + fromClause + whereClause + limitClause;
            
            List<Record> records    = new List<Record>();
            
            for( SObject sObj : Database.query( query ) ) {
                Record rec  = new Record();
                
                rec.id      = sObj.Id;
                rec.name    = String.valueOf( sObj.get( 'Name' ) );
                
                records.add( rec );
            }
            
            return new ActionResponse( TRUE, NULL, records );
        }
        catch( Exception ex ) {
            return new ActionResponse( FALSE, ex.getMessage() );
        }
    }
    
    /**
     * This method is created to fetch the records
     * of a selected List View in the Record Lookup
     * Component.
     * 
     * @param       listViewId      The Id of the selected List View
     * 
     * @param       objName         The name of the objects whose records
     *                              have to be queried
     * 
     * @return      ActionResponse  Returns a list of records which
     *                              come under the selected List View
     */
    @RemoteAction
    global static ActionResponse fetchRecords( String listViewId, String objName ) {
        try {
            ListViewsDescribeResponse resp = ListViewAPI.describeListView( listViewId, objName );
            
            System.debug( resp.query );
            
            Boolean found = FALSE;
            
            for( ListViewsDescribeResponse.Columns col : resp.columns ) {
                if( col.fieldNameOrPath == 'Name' ) {
                    found = TRUE;
                }
            }
            
            if( found == FALSE ) {
                resp.query = resp.query.replace( 'SELECT ', 'SELECT Name,' );
            }
            
            List<SObject> sObjRecords = Database.query( resp.query );
            
            System.debug( resp.query );
            
            List<Record> records = new List<Record>();
            
            for( SObject sObj : sObjRecords ) {
                Record rec = new Record();
                
                rec.id   = sObj.Id;
                rec.name = String.valueOf( sObj.get( 'Name' ) );
                
                for( ListViewsDescribeResponse.Columns col : resp.columns ) {
                    Field fld       = new Field();
                    
                    fld.label       = col.label;
                    fld.name        = col.fieldNameOrPath;
                    fld.dataType    = col.dataType;
                    
                    /**
                     * Handling instances when there
                     * are fields queried from the
                     * related or parent object.
                     */
                    if( !col.fieldNameOrPath.contains( '.' ) ) {
                        fld.value = String.valueOf( sObj.get( col.fieldNameOrPath ) );
                    }
                    else {
                        List<String> parts = col.fieldNameOrPath.split( '\\.' );
                        
                        System.debug( col.fieldNameOrPath );
                        System.debug( sObj );
                        
                        if( sObj.getSObject( parts[0] ) != NULL ) {
                            fld.value = String.valueOf( sObj.getSObject( parts[0] ).get( parts[1] ) );
                        }
                    }
                    
                    rec.fields.add( fld );
                }
                
                records.add( rec );
            }
            
            return new ActionResponse( TRUE, NULL, records );
        }
        catch( Exception ex ) {
            return new ActionResponse( FALSE, ex.getMessage() );
        }
    }
    
    /**
     * This method is created to perform a
     * global search for records when a
     * user starts typing in the Record
     * Lookup Component.
     * 
     * @param       searchStr           String entered by the User in the
     *                                  textbox
     * 
     * @param       objName             The name of the object from which
     *                                  the records have to be queried
     * 
     * @param       globalSearchFilter  The WHERE condition which has to
     *                                  be included in the SOSL query
     * 
     * @return      ActionResponse      Returns a list of records which
     *                                  satisfy the search string and the
     *                                  where condition
     */
    @RemoteAction
    global static ActionResponse searchRecords( String searchStr, String objName, String globalSearchFilter ) {
        try {
            String findQuery        = 'FIND \'' + String.escapeSingleQuotes( searchStr ) + '\'';
            String inQuery          = ' IN ALL Fields ';
            String returningQuery   = 'RETURNING ' + objName + '(Id, Name'+ ( !String.isBlank( globalSearchFilter ) ? ' WHERE ' + globalSearchFilter : '' )  + ')';
            
            String soslQuery = findQuery + inQuery + returningQuery;
                
            List<List<SObject>> globalSearch = Search.query( soslQuery );
            
            List<Record> records = new List<Record>();
            
            if( globalSearch[0] != NULL && !globalSearch[0].isEmpty() ) {
                for( SObject sObj : globalSearch[0] ) {
                    Record rec  = new Record();
                    
                    rec.id      = sObj.Id;
                    rec.name    = String.valueOf( sObj.get( 'Name' ) );
                    
                    records.add( rec );
                }
            }
            
            return new ActionResponse( TRUE, NULL, records );
        }
        catch( Exception ex ) {
            return new ActionResponse( FALSE, ex.getMessage() );
        }
    }

    /**
     * This method is created to set the 
     * selected record in the Record Lookup
     * Component
     * 
     * @param       recordId        The Id of the record
     *      
     * @param       objName         The name of the Object
     * 
     * @return      ActionResponse  The record selected by
     *                              the User
     */
    @RemoteAction
    global static ActionResponse setSelectedRecord( String recordId, String objName ) {
        try {
            String selClause        = ' SELECT Id, Name';
            String fromClause       = ' FROM ' + objName;
            String whereClause      = ' WHERE Id = \'' + recordId + '\'';
            
            String query            = selClause + fromClause + whereClause;
            
            SObject sObj            = Database.query( query );
            
            Record rec  = new Record();
            
            rec.id      = sObj.Id;
            rec.name    = String.valueOf( sObj.get( 'Name' ) );
            
            return new ActionResponse( TRUE, NULL, rec );
        }
        catch( Exception ex ) {
            return new ActionResponse( FALSE, ex.getMessage() );
        }
    }
}