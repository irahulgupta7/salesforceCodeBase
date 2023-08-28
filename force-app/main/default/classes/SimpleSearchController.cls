public with sharing class SimpleSearchController {
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of contacts to display
  public List<Contact> contacts {get;set;}
  
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
  
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }
  
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }

  // init the controller and display some sample data when the page loads
  public SimpleSearchController() {
    soql = 'select firstname from contact where account.name != null';
    runQuery();
  }
  
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
  
  // runs the actual query
  public void runQuery() {
        
    try {
      contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }
  
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
    
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    
    
    soql = 'select firstname, lastname, account.name from contact where account.name != null';
    String str0 = '\'%' + String.escapeSingleQuotes(firstName.trim()) + '%\'';
    if (!firstName.equals(''))
      soql += ' and firstname like'+ str0;
    // run the query again
    runQuery();

    return null;
  }
}