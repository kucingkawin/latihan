import 'package:flutter/material.dart';
import 'package:latihan/apiservice.dart';
import 'package:latihan/profile.dart';

import 'argumentDaftar.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Input extends StatefulWidget {

  Future<Profile> futureProfile;
  ArgumentDaftar argumentDaftar;

  Input(this.argumentDaftar);

  static String tag = 'input';

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  // Memastikan apakah loading
  bool _isLoading = false;

  // Api service
  ApiService _apiService = ApiService();

  // Validasi input
  bool _idValid;
  bool _namaValid;
  bool _gajiValid;
  bool _umurValid;

  // Text api controller
  TextEditingController _controllerId = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerGaji = TextEditingController();
  TextEditingController _controllerUmur = TextEditingController();

  // Tipe input
  String tipeInput;

  void submit()
  {
    /*if (_npmValid == null || _namaValid == null || _kelasValid == null || _sesiValid == null ||
        !_npmValid || !_namaValid || !_kelasValid || !_sesiValid)
    {
      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text("Semua field dibutuhkan."),
        ),
      );

      return;
    }*/

    // Set state
    setState(() => _isLoading = true);

    //Tampung nilainya
    String id = _controllerId.text.toString();
    String nama = _controllerNama.text.toString();
    String gaji = _controllerGaji.text.toString();
    String umur = _controllerUmur.text.toString();

    //Buat satu objek profile
    Profile profile = Profile(id: id, nama: nama, gaji: gaji, umur: umur);

    if(widget.argumentDaftar.tipe == "tambah")
    {
      //Segera lakukan proses pembuatan
      _apiService.buatProfile(profile).then((isSuccess) {
        setState(() => _isLoading = false);
        if (isSuccess) {
          Navigator.pop(_scaffoldState.currentState.context);
        } else {
          _scaffoldState.currentState.showSnackBar(SnackBar(
            content: Text("Submit data failed"),
          ));
        }
      });
    }
    else if (widget.argumentDaftar.tipe == "ubah")
    {
      _apiService.ubahProfile(profile).then((isSuccess) {
        setState(() => _isLoading = false);
        if (isSuccess) {
          Navigator.pop(_scaffoldState.currentState.context);
        } else {
          _scaffoldState.currentState.showSnackBar(SnackBar(
            content: Text("Submit data failed"),
          ));
        }
      });
    }
  }


  @override
  void initState() {
    ArgumentDaftar argumentDaftar = widget.argumentDaftar;
    if(argumentDaftar.tipe == "ubah")
      widget.futureProfile = _apiService.getSatuProfile(widget.argumentDaftar.argumen);
  }

  @override
  Widget build(BuildContext context)
  {
    tipeInput = widget.argumentDaftar.tipe;

    // Tentukan title berdasarkan tipe inputnya.
    String teksJudul = "";
    if(tipeInput == "tambah")
      teksJudul = "Tambah Data";
    else if(tipeInput == "ubah")
      teksJudul = "Ubah Data";

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(teksJudul, style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: widget.futureProfile,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){

              if(snapshot.connectionState == ConnectionState.done){
                Profile profile = snapshot.data;
                print('ALUE: ' + profile.toString());
                _controllerNama.text = profile.nama;
                _controllerId.text = profile.id;
                _controllerUmur.text = profile.umur;
                _controllerGaji.text = profile.gaji;
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buatInputNama(),
                    _buatInputGaji(),
                    _buatInputUmur(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RaisedButton(
                        onPressed: () => submit(),
                        child: Text(
                          "Submit".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.orange[600],
                      ),
                    )
                  ]
                ),
              );
            }
          )
        , _isLoading ?
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.3,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
          : Container()
        ]
      )
    );
  }

  Widget _buatInputNama()
  {
    return TextField(
      controller: _controllerNama,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Nama',
          errorText: _namaValid == null || _namaValid ? null : "Nama dibutuhkan."
      ),
      onChanged: (value) {
        bool fieldValid = value.trim().isNotEmpty;
        if (fieldValid != _namaValid) {
          setState(() => fieldValid = _namaValid);
        }
      },
    );
  }

  Widget _buatInputGaji()
  {
    return TextField(
      controller: _controllerGaji,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Gaji',
          errorText: _gajiValid == null || _gajiValid ? null : "Kelas dibutuhkan."
      ),
      onChanged: (value) {
        bool fieldValid = value.trim().isNotEmpty;
        if (fieldValid != _gajiValid) {
          setState(() => fieldValid = _gajiValid);
        }
      },
    );
  }

  Widget _buatInputUmur()
  {
    return TextField(
      controller: _controllerUmur,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Umur',
          errorText: _umurValid == null || _umurValid ? null : "Sesi dibutuhkan."
      ),
      onChanged: (value) {
        bool fieldValid = value.trim().isNotEmpty;
        if (fieldValid != _umurValid) {
          setState(() => fieldValid = _umurValid);
        }
      },
    );
  }
}