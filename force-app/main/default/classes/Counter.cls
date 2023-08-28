public class Counter
{
    @InvocableMethod
    public static List<integer> countPicklist(List<String> opts)
    {
        List<String> str = new List<String>();
        str = opts[0].split(';') ;
        integer count = str != null && str.size()>0 ? str.size():0;
        list<integer> listInteger = new List<integer>();
        listInteger.add(count);
        return listInteger;
    }
}