/**
 * This class represents the response
 * recieved from the List View Describe
 * APIs.
 * 
 * @author      Shruti Sridharan
 * @since       11/05/2017
 * @revisions   N/A
 */
public class ListViewsDescribeResponse {
    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    public class OrderBy {
        public String fieldNameOrPath {get;set;} 
        public String nullsPosition {get;set;} 
        public String sortDirection {get;set;} 

        public OrderBy(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'fieldNameOrPath') {
                            fieldNameOrPath = parser.getText();
                        } else if (text == 'nullsPosition') {
                            nullsPosition = parser.getText();
                        } else if (text == 'sortDirection') {
                            sortDirection = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'OrderBy consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public List<Columns> columns {get;set;} 
    public String id {get;set;} 
    public List<OrderBy> orderBy {get;set;} 
    public String query {get;set;} 
    public String scope {get;set;} 
    public String sobjectType {get;set;} 
    public WhereCondition whereCondition {get;set;} 

    public ListViewsDescribeResponse(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'columns') {
                        columns = new List<Columns>();
                        while (parser.nextToken() != JSONToken.END_ARRAY) {
                            columns.add(new Columns(parser));
                        }
                    } else if (text == 'id') {
                        id = parser.getText();
                    } else if (text == 'orderBy') {
                        orderBy = new List<OrderBy>();
                        while (parser.nextToken() != JSONToken.END_ARRAY) {
                            orderBy.add(new OrderBy(parser));
                        }
                    } else if (text == 'query') {
                        query = parser.getText();
                    } else if (text == 'scope') {
                        scope = parser.getText();
                    } else if (text == 'sobjectType') {
                        sobjectType = parser.getText();
                    } else if (text == 'whereCondition') {
                        whereCondition = new WhereCondition(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Columns {
        public String ascendingLabel {get;set;} 
        public String descendingLabel {get;set;} 
        public String fieldNameOrPath {get;set;} 
        public Boolean hidden {get;set;} 
        public String label {get;set;} 
        public String selectListItem {get;set;} 
        public String sortDirection {get;set;} 
        public Integer sortIndex {get;set;} 
        public Boolean sortable {get;set;} 
        public String dataType {get;set;} // in json: type

        public Columns(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ascendingLabel') {
                            ascendingLabel = parser.getText();
                        } else if (text == 'descendingLabel') {
                            descendingLabel = parser.getText();
                        } else if (text == 'fieldNameOrPath') {
                            fieldNameOrPath = parser.getText();
                        } else if (text == 'hidden') {
                            hidden = parser.getBooleanValue();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'selectListItem') {
                            selectListItem = parser.getText();
                        } else if (text == 'sortDirection') {
                            sortDirection = parser.getText();
                        } else if (text == 'sortIndex') {
                            sortIndex = parser.getIntegerValue();
                        } else if (text == 'sortable') {
                            sortable = parser.getBooleanValue();
                        } else if (text == 'type') {
                            dataType = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Columns consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class WhereCondition {
        public List<Conditions> conditions {get;set;} 
        public String conjunction {get;set;} 

        public WhereCondition(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'conditions') {
                            conditions = new List<Conditions>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                conditions.add(new Conditions(parser));
                            }
                        } else if (text == 'conjunction') {
                            conjunction = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'WhereCondition consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Conditions {

        public Conditions(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Conditions consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static ListViewsDescribeResponse parse(String json) {
        return new ListViewsDescribeResponse(System.JSON.createParser(json));
    }
}