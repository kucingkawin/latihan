import 'package:http/http.dart' show Client, Response;
import 'profile.dart';

class ApiService {

  final String baseUrl = "http://dummy.restapiexample.com/api/v1";
  Client client = Client();

  Future<List<Profile>> getProfiles() async
  {
    //Dapatkan response client
    Response response = await client.get("$baseUrl/employees");

    //Cek status responsenya
    if (response.statusCode == 200) 
      return profileDariJson(response.body);
    else
      return null;
  }

  Future<Profile> getSatuProfile(String id) async
  {
    Response response = await client.get("$baseUrl/employee/${id}");

    print('HTTPS: $baseUrl/employee/${id}');
    print('STATUS: ' + response.statusCode.toString());
    print(response.body);

    //Cek status responsenya
    if (response.statusCode == 200)
      return profileDariSatuJson(response.body);
    else
      return null;
  }

  Future<bool> buatProfile(Profile profile) async
  {
    //Dapatkan response client
    Response response = await client.post(
        "$baseUrl/create",
        headers: {"content-type": "application/json"},
        body: profileToJson(profile)
    );

    print("Penambahan Data");
    print(profileToJson(profile));
    print("Response: " + response.body);
    print("Kode response: " + response.statusCode.toString());

    //return responsenya
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> ubahProfile(Profile profile) async
  {
    //Dapatkan response client
    Response response = await client.put(
        "$baseUrl/update/${profile.id}",
        headers: {"content-type": "application/json"},
        body: profileToJson(profile)
    );

    print("Pengubahan Data");
    print(profileToJson(profile));
    print("Response: " + response.body);
    print("Kode response: " + response.statusCode.toString());

    //return responsenya
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> hapusProfile(Profile profile) async
  {
    //Dapatkan response client
    Response response = await client.delete("$baseUrl/delete/${profile.id}");

    //Kesimpulan
    print("Penghapusan Data");
    print(profileToJson(profile));
    print("Kode response: " + response.statusCode.toString());
    print("Status response: " + response.body);

    // Cek status responsenya
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<String> getProfilesString() async
  {
    //Dapatkan response client
    Response response = await client.get("$baseUrl");

    //Cek status responsenya
    if (response.statusCode == 200){
      print ('Berhasil');
      return response.body;
    }
    else{
      print ('Gagal (' + response.statusCode.toString());
      return null;
    }
  }  

}