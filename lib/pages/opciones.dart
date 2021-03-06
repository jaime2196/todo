import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:to_do/i18n/Languages.dart';
import 'package:to_do/services/SharedPref.dart';
import 'package:to_do/util/header_painter.dart';

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

  Color currentColor = SharedPref.getColor();
  void changeColor(Color color) =>{
    SharedPref.setColor(color.value),
    MyApp.setColor(context,SharedPref.getColor()),
    setState(() => currentColor = color)
  };

  

  @override
  Widget build(BuildContext context) {
    valorDropIdioma=SharedPref.getLocale().toString()=="es"?es:en;
    return Scaffold(
      appBar: AppBar(title: Text(Languages.of(context).labelOpciones)),
      body: CustomPaint(
        painter: HeaderPaintWaves(),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                _opcionIdioma(es,en),
                _opcionTutorial(), 
                _opcionColor()
            ],
          ),
        ),
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
      elevation: 20,
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
                  color: SharedPref.getColor(),
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
      elevation: 20,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(Languages.of(context).labelMostrarTutorial,style: TextStyle(fontSize: 18)),
          ListTile(
            title: Center(
              child: RaisedButton(
                color: SharedPref.getColor()[800],
                child: Text(
                  Languages.of(context).labelMostrar, 
                  style: TextStyle(
                    color: SharedPref.esOscuro()?Colors.white:Colors.black
                    ),
                  ),
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

  Widget _opcionColor(){
    return  Card(
      elevation: 20,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(Languages.of(context).labelCambiarColor,style: TextStyle(fontSize: 18)),
          ListTile(
            title: Center(
              child: RaisedButton(
                color: SharedPref.getColor()[800],
                child: Text(Languages.of(context).labelCambiar, style: TextStyle(color: SharedPref.esOscuro()?Colors.white:Colors.black),),
                onPressed: (){
                  _mostrarDialogo(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogo(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext ctx){
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          content: SingleChildScrollView(
            child: SlidePicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
              paletteType: PaletteType.rgb,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: false,
              showIndicator: true,
              indicatorBorderRadius:
              const BorderRadius.vertical(
                top: const Radius.circular(25.0),
              ),
            ),
          ),
        );
      }
    );
  }


  



  
}