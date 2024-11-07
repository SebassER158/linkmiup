import 'package:http/http.dart' as http;

class Apis {
  

  String server = "http://72.167.45.26:2031";

  getValoresByCurp(String cuenta, String tabla, String curp) async{
    var url = "$server/getValuesTableByCurp/$cuenta/$tabla/$curp";
    print(url);
    return await http.get(Uri.parse(url));
  }
}