import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;
import 'apiservice.dart';
import 'profile.dart';
import 'input.dart';
import 'argumentDaftar.dart';

class Menu extends StatefulWidget
{
  Menu({Key key}) : super(key: key);
  
  static String tag = 'menu';

  @override
  _MenuState createState() {
      return _MenuState();
  }
}

class _MenuState extends State<StatefulWidget>
{
  ApiService apiService;
  Future<List<Profile>> futureProfile;
  bool loading;

  // Munculkan dialog notifikasi login salah
  void notifikasiLogin(BuildContext context, bool benar) {

    // Tombol OK
    Widget tombolOK = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // Membuat alert dialog terlebih dahulu
    AlertDialog alert = AlertDialog(
      title: Text("Username dan Password " + (benar ? 'Benar' : 'Salah')),
      content: Text("Username dan password " + (benar ? '' : 'tidak ') + "ada di basis data."),
      actions: [
        tombolOK,
      ],

    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false
    );
  }

  @override
  void initState() {
    apiService = ApiService();
    futureProfile = apiService.getProfiles();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    //apiService.getProfiles().then((value) => print("value: $value"));
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Karyawan')
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Input.tag, arguments: ArgumentDaftar('tambah', null));
          },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureProfile,
          builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
            if (snapshot.hasError)
            {
              return Center(
                child: Text(
                "Something wrong with message: ${snapshot.error.toString()}"),
              );
            }
            else if (snapshot.connectionState == ConnectionState.done)
            {
              print('Berhasil dalam load data profil');
              List<Profile> profiles = snapshot.data;
              return _buatListView(profiles);
            }
            else
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        )
      )
    );
  }

  Widget _buatListView(List<Profile> profiles) {
    Widget widget = null;
    if(!loading)
    {
      widget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            Profile profile = profiles[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Image.network(src)
                      Text(
                        profile.nama,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(profile.nama),
                      Text(profile.gaji),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              // Alert dialog.
                              AlertDialog alertDialog = AlertDialog(
                                  title: Text('Konfirmasi Hapus'),
                                  content: Text('Data ${profile.nama} (${profile.id}) akan dihapus. Apakah anda yakin ingin menghapusnya'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        //Hilangkan proses data
                                        Navigator.of(context).pop();

                                        //Lakukan proses update interface
                                        setState((){loading = true;});

                                        //Lakukan proses hapus data
                                        apiService.hapusProfile(profile).then((isSuccess)
                                        {
                                          String teks = "";
                                          if(isSuccess)
                                            teks = "Penghapusan berhasil";
                                          else
                                            teks = "Penghapusan tidak berhasil";

                                          print(teks);

                                          //Segera loading ulang datanya
                                          futureProfile = apiService.getProfiles();

                                          //Lakukan proses update interface
                                          setState((){loading = false;});
                                        });
                                      },
                                      child: Text('Ya')
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Tidak')
                                    )
                                  ]
                              );

                              //Munculkan dialog
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return alertDialog;
                                  }
                              );
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(Input.tag, arguments: ArgumentDaftar('ubah', profile.id));

                              //Segera loading ulang datanya
                              futureProfile = apiService.getProfiles();

                              //Lakukan proses update interface
                              setState((){loading = false;});
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: profiles.length,
        ),
      );
    }
    else
    {
      widget = Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hapus Data',
                ),
                SizedBox(height: 15),
                CircularProgressIndicator(),
              ],
            )
          ),
        ],
      );
    }

    return widget;
  }
}