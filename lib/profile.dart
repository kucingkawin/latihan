import 'dart:convert';

class Profile {

  String id;
  String nama;
  String gaji;
  String umur;

  Profile({this.id, this.nama, this.gaji, this.umur});

  factory Profile.dariJson(Map<String, dynamic> map) {
    return Profile(
        id: map["id"], nama: map["employee_name"], gaji: map["employee_salary"], umur: map["employee_age"]);
  }

  Map<String, dynamic> keJson() {
    return {"id": id, "name": nama, "salary": gaji, "age": umur};
  }

  @override
  String toString() {
    return 'Profile{id: $id, nama: $nama, gaji: $gaji, umur: $umur}';
  }

}

List<Profile> profileDariJson(String jsonData) {

  // Ubah data ke format json
  final data = json.decode(jsonData);

  // Kembalikan
  return List<Profile>.from(data.map((item) => Profile.dariJson(item)));
}

Profile profileDariSatuJson(String jsonData) {

  // Ubah data ke format json
  final data = json.decode(jsonData);

  // Kembalikan
  return Profile.dariJson(data);
}

String profileToJson(Profile data) {

  //Dari profile ke json
  final jsonData = data.keJson();

  //Kembalikan ke jsonnya
  return json.encode(jsonData);
}