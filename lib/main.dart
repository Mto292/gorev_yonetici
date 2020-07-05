import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screen/ana_sayfa.dart';

void main() {
  runApp(MaterialApp(
    title: "Günlük Gürev",
    //uygulamanın genelinde kullanılan temalar ayarlanıyor
    theme: ThemeData(
      buttonColor: Colors.deepOrange,
      //ekranların arka plan renkleri
      backgroundColor: Colors.blueGrey.shade50,
      scaffoldBackgroundColor: Colors.blueGrey.shade50,
      primarySwatch: Colors.teal,
    ),
    debugShowCheckedModeBanner: false,
    home: AnaSayfa(),
  ));
}
