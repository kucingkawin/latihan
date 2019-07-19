import 'package:flutter/material.dart';
import 'apiservice.dart';

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
  Widget build(BuildContext context) {
    ApiService().getProfiles().then((value) => print("value: $value"));

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text('Selamat Berhasil Dibuka', style: TextStyle(fontSize: 45)),
            SizedBox(height: 8.0),
            Text('Selamat, anda sudah melihat-lihat kebunku.')
          ],
        ),
      ),
    );
  }
}