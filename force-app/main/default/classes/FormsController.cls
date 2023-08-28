public class FormsController {
	@auraEnabled
    public static void getFormsbyName(String sCounty){
        system.debug('hello'+ sCounty);
    }
}