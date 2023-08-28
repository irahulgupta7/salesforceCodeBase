Public class DemoSoql {
    
    public static void getData(){
        Set<Id> SetIds = new Set<Id>();
        for(Account acc: [Select ID FROM Account WHERE Phone != Null]){
            SetIds.add(acc.Id);
        }
        for (Contact con : [Select Id,Name FROM CONTACT where AccountID NOT IN :SetIds]){
            System.debug('con'+con.name);
        }
        integer year =2019;
        List<Opportunity> opp =[Select ID FROM Opportunity 
                  ];
        System.debug('opp'+opp);
    }

}