import 'package:flutter/material.dart';
import 'package:to_do/i18n/Languages.dart';
import 'package:to_do/services/SharedPref.dart';

import '../main.dart';

class OpcionesPage extends StatefulWidget {
  OpcionesPage({Key key}) : super(key: key);

  @override
  _OpcionesPageState createState() => _OpcionesPageState();
}

class _OpcionesPageState extends State<OpcionesPage> {
  String es="Spanish / Español";//Languages.of(context).labelEspanol;
  String en="English / Inglés";//Languages.of(context).labelIngles;

  String valorDropIdioma=""; //SharedPref.getLocale().toString()=="es"?es:en;

  

  @override
  Widget build(BuildContext context) {
    valorDropIdioma=SharedPref.getLocale().toString()=="es"?es:en;
    return Scaffold(
      appBar: AppBar(title: Text(Languages.of(context).labelOpciones)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _opcionIdioma(es,en),
            _opcionTutorial()
          ],
        ),
      ),
    );
  }

  Widget _opcionIdioma(String es, String en){
    if(valorDropIdioma=="es"){
      valorDropIdioma=es;
    }else if(valorDropIdioma=="en"){
      valorDropIdioma=en;
    }
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(Languages.of(context).labelIdioma,style: TextStyle(fontSize: 18)),
          ListTile(

            title: Center(
              child: DropdownButton<String>(
                value: valorDropIdioma,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                
                onChanged: (String newValue) {
                  setState(() {
                    _cambiarPreferencias(newValue);
                    valorDropIdioma = newValue;
                  });
                },
                items: <String>[es, en]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _cambiarPreferencias(String nuevoValor){
    if(nuevoValor==es){
      MyApp.setLocale(context,Locale('es',''));
      SharedPref.setLocale("es");
      //Navigator.pop(context);
    }else if(nuevoValor==en){
      MyApp.setLocale(context,Locale('en',''));
      SharedPref.setLocale("en");
      //Navigator.pop(context);
    }
    setState(() {
      
    });
  }

  Widget _opcionTutorial(){
    return  Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(Languages.of(context).labelMostrarTutorial,style: TextStyle(fontSize: 18)),
          ListTile(
            title: Center(
              child: RaisedButton(
                child: Text(Languages.of(context).labelMostrar),
                onPressed: (){
                  SharedPref.setPrimeraVez(true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}