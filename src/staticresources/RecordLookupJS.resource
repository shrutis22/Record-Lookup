/**
 * The JavaScript file used for
 * the RecordLookup component.
 *
 * @author      Shruti Sridharan
 * @since       11/05/2017
 * @revisions   N/A
 */

/**
 * The Object Constructor that defines
 * the properties on an instance of the
 * RecordLookup object.
 * 
 * @param   options     Various configurable attributes
 *                      of the component as recieved from
 *                      the markup.
 */
var RecordLookup = function( options ) {
    this.options = options;
    
    this.remoteActionConfig = {
        escape  : false,
        buffer  : false,
        timeout : 120000
    };
    
    /**
     * When packaged the Controller will
     * have to be accessed via the the
     * Namespace.
     */
    window.RecordLookupCompCtrlr = window.RecordLookupCompCtrlr || window[options.ns].RecordLookupCompCtrlr;
};

/////////////////////////////
// Internal Helper Methods //
/////////////////////////////

/**
 * Generate a fully qualified Id
 * for an element/tag on the component.
 * 
 * @param       localId         Local Id of the Component/Tag.
 */
RecordLookup.prototype.__generateFullyQualifiedId = function( localId ) {
    /**
     * Every element/tag on the component
     * will have a Local Id that will stand
     * unique with respect to the markup of
     * the component. But when multiple such
     * components are placed on the page the
     * Local Id will not stand unique and hence
     * we need to prefix with a unique identifier
     * that will be passed as an attribute on
     * the component.
     */
    return "#" + this.options.id + "__" + localId;
};

/**
 * Return all the records pertaining
 * to the given List View Id.
 * 
 * @param       self            Current Record Lookup Instance
 * @param       listViewId      Selected List View from the Filter or
 *                              available List Views.
 */
RecordLookup.prototype.__fetchRecords = function( self, listViewId ) {
    var id = self.__generateFullyQualifiedId( "selRecords" );

    /**
     * SOSL is when the User has
     * selected "Global Search".
     */
    if( listViewId === "sosl" ) {
        if( self.__$selRecords ) {
            self.__$selRecords[0].selectize.destroy();
        }
        
        self.__$selRecords = $( id ).removeClass().selectize(
            {
                loadingClass    : "fetching",
                maxItems        : 1,
                sortField       : "name",
                labelField      : "name",
                searchField     : "name",
                valueField      : "id",
                /**
                 * We will show the currently selected
                 * List View's name on the list
                 * of records that are being displayed.
                 */
                placeholder     : self.__$selListView.text(),
                onChange        : function( value ) {
                    if( self.options.onselect !== "" ) {
                        /**
                         * When a record has been selected
                         * we will invoke the Callback
                         * by sending in the selected 
                         * record Id into the Callback
                         * function.
                         */
                        eval( self.options.onselect )( value );
                    }
                },
                load            : function( query, callback ) {
                    var selectize = this;

                    if ( !query.length || query.length < 3 ) return callback();
                    
                    /**
                     * Perform a SOSL with the given
                     * search string. The SOSL can also
                     * take into account a Search Filter
                     * which is actually supplied as an
                     * attribute on the component.
                     */
                    RecordLookupCompCtrlr.searchRecords(
                        query,
                        self.options.sobject,
                        self.options.globalSearchFilter,
                        function( result, event ) {
                            if( result.status ) {
                                result.dataCustom.forEach(
                                    function( record ) {
                                        selectize.addOption(
                                            {
                                                value   : record.id,
                                                text    : record.name
                                            }
                                        );
                                    }
                                );
                                
                                callback( result.dataCustom );
                            }
                        },
                        self.remoteActionConfig
                    );
                }
            }
        );
        
        self.__$selRecords[0].selectize.focus();
        
        self.__toggleProgress();
    }
    else {
        /**
         * If not SOSL/Global Search then
         * it is all about running the SOQL
         * powering the selected List View,
         * grabbing the records and displaying
         * the same.
         */
        RecordLookupCompCtrlr.fetchRecords(
            listViewId,
            self.options.sobject,
            function( result, event ) {
                if( result.status ) {
                    if( self.__$selRecords ) {
                        self.__$selRecords[0].selectize.destroy();
                    }
                    
                    self.__$selRecords = $( id ).removeClass().selectize(
                        {
                            loadingClass    : "fetching",
                            maxItems        : 1,
                            sortField       : "name",
                            labelField      : "name",
                            searchField     : "name",
                            valueField      : "id",
                            options         : result.dataCustom,
                            /**
                             * We will show the currently selected
                             * List View's name on the list
                             * of records that are being displayed.
                             */
                            placeholder     : self.__$selListView.text(),
                            onChange        : function( value ) {
                                if( self.options.onselect !== "" ) {
                                    /**
                                     * When a record has been selected
                                     * we will invoke the Callback
                                     * by sending in the selected 
                                     * record Id into the Callback
                                     * function.
                                     */
                                    eval( self.options.onselect )( value );
                                }
                            }
                        }
                    );
                    
                    self.__$selRecords[0].selectize.focus();
                    
                    self.__toggleProgress();
                }
            },
            this.remoteActionConfig
        );
    }
};

/**
 * Show/Hide the Filter Drop Down.
 */
RecordLookup.prototype.__toggleFilter = function() {
    /**
     * Show the available Filters/List Views
     * drop down and hide the Records Drop Down.
     */
    if( this.__$selListView && !this.__$selListView[0].selectize.$wrapper.is( ":visible" ) ) {
        this.__$selListView[0].selectize.$wrapper.show() && 
        this.__$selListView[0].selectize.focus();
        
        this.__$selRecords &&
        this.__$selRecords[0].selectize.$wrapper.hide();
    }
    else {
        this.__$selRecords &&
        this.__$selRecords[0].selectize.$wrapper.show() && 
        this.__$selRecords[0].selectize.focus();
        
        this.__$selListView && 
        this.__$selListView[0].selectize.$wrapper.hide();
    }
};

/**
 * Show/Hide the Progress indicating that
 * the records pertaining to the selected
 * List View are being fetched.
 */
RecordLookup.prototype.__toggleProgress = function() {
    var id = this.__generateFullyQualifiedId( "fetchProgress" );
    
    $( id ).toggle();
};

////////////////////
// Public Methods //
////////////////////

/**
 * Binding Event Handlers to the
 * Elements/Tags on the component.
 */
RecordLookup.prototype.bindEvents = function() {
    var self = this;
    
    $( this.__generateFullyQualifiedId( "toggleFilter" ) ).click(
        function() {
            self.__toggleFilter();
        }
    );
};


/**
 * Fetch and display the recently viewed
 * records.
 */
RecordLookup.prototype.fetchDefaultRecords = function() {
    var self = this;
    
    if( this.options.sobject !== "" ) {
        var id = this.__generateFullyQualifiedId( "selRecords" );
        
        RecordLookupCompCtrlr.fetchDefaultRecords(
            this.options.sobject,
            function( result, event ) {
                if( result.status ) {
                    self.__$selRecords = $( id ).removeClass().selectize(
                        {
                            loadingClass    : "fetching",
                            maxItems        : 1,
                            sortField       : "name",
                            labelField      : "name",
                            searchField     : "name",
                            valueField      : "id",
                            options         : result.dataCustom,
                            onChange        : function( value ) {
                                if( self.options.onselect !== "" ) {
                                    eval( self.options.onselect )( value );
                                }
                            }
                        }
                    );
                    
                    /**
                     * If there needs to be a specific 
                     * record that needs to be pre-selected.
                     */
                    if( self.options.defaultValue !== "" ) {
                        self.setSelectedRecord( self.options.defaultValue );
                    }
                    
                    if( self.options.callback !== "" ) {
                        eval( self.options.callback )();
                    }
                }
            },
            this.remoteActionConfig
        );
    }
};

/**
 * Fetch and display all the List Views
 * defined on the Object.
 */
RecordLookup.prototype.showListViews = function() {
    var self = this;
    
    if( this.options.sobject !== "" ) {
        RecordLookupCompCtrlr.fetchListViews(
            this.options.sobject,
            function( result, event ) {
                if( result.status ) {
                    var id = self.__generateFullyQualifiedId( "selListViews" );
                    
                    self.__$selListView = $( id ).removeClass().addClass( "hidden" ).selectize(
                        {
                            loadingClass    : "fetching",
                            maxItems        : 1,
                            sortField       : "label",
                            labelField      : "label",
                            searchField     : "label",
                            options         : result.dataCustom,
                            /**
                             * When the List View selected
                             * has been changed, start fetching
                             * the records pertaining to that
                             * List View.
                             */
                            onChange        : function( value ) {
                                self.__toggleFilter();
                    
                                self.__toggleProgress();
                                
                                self.__fetchRecords( self, value );
                            }
                        }
                    );
                }
            },
            this.remoteActionConfig
        );
    }
};

/**
 * Setting the pre-selected value
 * on the component.
 */
RecordLookup.prototype.setSelectedRecord = function( recordId ) {
    var self = this;
    
    if( this.__$selRecords.val() !== recordId ) {
        /**
         * We need to determine if the record
         * that needs to be pre-selected has already
         * been fetched or not.
         * 
         * If it hasn't been fetched then we would
         * fetch that records with the Id and Name
         * field and then add it to the list.
         */
        if( !this.__$selRecords[0].selectize.options.hasOwnProperty( recordId ) ) {
            RecordLookupCompCtrlr.setSelectedRecord(
                recordId,
                this.options.sobject,
                function( result, event ) {
                    if( result.status ) {
                        self.__$selRecords[0].selectize.addOption( result.datum );
                        
                        self.__$selRecords[0].selectize.setValue( result.datum.id );
                    }
                },
                this.remoteActionConfig
            );
        }
        else {
            this.__$selRecords[0].selectize.setValue( recordId );
        }
    }
};

/**
 * Return the object with all the
 * properties that represents the
 * selected record.
 */
RecordLookup.prototype.getSelectedRecord = function() {
    return this.__$selRecords[0].selectize.options[this.__$selRecords.val()];
};