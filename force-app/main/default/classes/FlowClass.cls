public class FlowClass {
     @InvocableMethod(label='Get Account Names')
     public static void getAccountNames() {
         System.debug('Hello World');
         makeCallout('Called from Invocable');
     }
    @future( callout=true )
    public static void makeCallout( String strInput ) {
        System.debug('makeCallout' + strInput );
    }
}