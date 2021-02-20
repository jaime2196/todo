import 'package:flutter/material.dart';
import 'package:to_do/pages/detalleLista.dart';
import 'package:to_do/pages/home.dart';
import 'package:to_do/services/SharedPref.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  //SharedPref.setPrimeraVez(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        'home': (BuildContext context) => Home(),
        'detalles': (BuildContext context) => DetalleLista()
      },
    );
  }
}