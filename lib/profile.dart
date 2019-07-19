import 'dart:convert';

class Profile {

  String npm;
  String nama;
  String kelas;
  String sesi;

  Profile({this.npm, this.nama, this.kelas, this.sesi});

  factory Profile.dariJson(Map<String, dynamic> map) {
    return Profile(
        npm: map["npm"], nama: map["nama"], kelas: map["kelas"], sesi: map["sesi"]);
  }

  Map<String, dynamic> keJson() {
    return {"npm": npm, "nama": nama, "kelas": kelas, "sesi": sesi};
  }

  @override
  String toString() {
    return 'Profile{npm: $npm, nama: $nama, kelas: $kelas, sesi: $sesi}';
  }

}

List<Profile> profileDariJson(String jsonData) {

  // Ubah data ke format json
  final data = json.decode(jsonData);

  // Kembalikan
  return List<Profile>.from(data['result'].map((item) => Profile.dariJson(item)));
}

String profileToJson(Profile data) {

  //Dari profile ke json
  final jsonData = data.keJson();

  //Kembalikan ke jsonnya
  return json.encode(jsonData);
}