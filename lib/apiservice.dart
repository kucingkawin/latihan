import 'package:http/http.dart' show Client, Response;
import 'profile.dart';

class ApiService {

  final String baseUrl = "http://sulistiyanto.000webhostapp.com/view.php";
  Client client = Client();

  Future<List<Profile>> getProfiles() async {
    //Test Perubahan
    //Dapatkan response client
    Response response = await client.get("$baseUrl");

    //Cek status responsenya
    if (response.statusCode == 200) 
      return profileDariJson(response.body); 
    else
      return null;
  }

  Future<String> getProfilesString() async {
    //Dapatkan response client
    Response response = await client.get("$baseUrl");

    //Cek status responsenya
    if (response.statusCode == 200) 
      return response.body;
    else
      return null;
  }  

}