import 'package:flutter/material.dart';

class Login extends StatefulWidget
{
  Login({Key key}) : super(key: key);
  
  static String tag = 'login';

  @override
  _LoginState createState() {
      return _LoginState();
  }
}

class _LoginState extends State<StatefulWidget>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  // Lakukan login
  void login()
  {
    // Cek email
    int emailBenar = emailTextEditingController.text == 'nandaprasesoft98@gmail.com' ? 1 : 0;
    
    // Cek password
    int passwordBenar = passwordTextEditingController.text == '123' ? 1 : 0;

    // Cek apakah benar atau tidak
    if(emailBenar * passwordBenar == 0)
      notifikasiLogin(context, false);
    else
      notifikasiLogin(context, true);
  }

  // Munculkan dialog notifikasi login salah
  void notifikasiLogin(BuildContext context, bool benar) {

    // Tombol OK
    Widget tombolOK = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    if(benar)
    {
      Navigator.of(context).pushNamed('menu');
    }
    else
    {
      // Membuat alert dialog terlebih dahulu
      AlertDialog alert = AlertDialog(
        title: Text("Username dan Password Salah"),
        content: Text("Username dan password tidak ada di basis data."),
        actions: [
          tombolOK,
        ],

      );

      // Munculkan sebuah dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // Email
    TextField email = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailTextEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)
      ),
    );

    // Password
    TextField password = TextField(
      obscureText: true,
      autofocus: false,
      controller: passwordTextEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)
      ),
    );

    // Tombol Login
    Padding tombolLogin = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => login(),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text('Login', style: TextStyle(fontSize: 45)),
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            tombolLogin
          ],
        ),
      ),
    );
  }
  
}