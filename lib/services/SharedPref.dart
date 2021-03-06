


import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/models/Lista.dart';

import '../main.dart';


class SharedPref{
  
  static SharedPreferences _sharedPreferences;
  static init() async{
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    String locale = await Devicelocale.currentLocale;
    _deviceLanguage=locale.split("_")[0];
    print(_deviceLanguage);
  }

  static String _deviceLanguage="en";

  static List<Lista> getListas()  {
    String datos= _sharedPreferences.getString('datos');
    if(datos!= null){
      return listaListaFromJson(datos);
    }
    return null;
  }

  static Lista getLista(int indice)  {
    String datos= _sharedPreferences.getString('datos');
    
    if(datos!= null){
      return listaListaFromJson(datos)[indice];
    }
    return null;
  }

  static void addLista(Lista lista){
    List<Lista> listas= getListas();
    if(listas!=null){
      listas.add(lista);
    }else{
      listas = new List<Lista>();
      listas.add(lista);
    }
    setListas(listas);
  }

  static setListas(List<Lista> lista ) {
    String json = listaListaToJson(lista);
    
    _sharedPreferences.setString('datos',  json);
  }

  static limpiar(){
    _sharedPreferences.setString('datos',  null);
  }

  static isPrimeraVez(){
    bool datos= _sharedPreferences.getBool('primeraVez');
    if(datos==null){
      return true;
    }
    return datos;
  }

  static setPrimeraVez(bool valor){
    _sharedPreferences.setBool("primeraVez", valor);
  }
  
  static const String prefSelectedLanguageCode = "prefSelectedLanguage";

  static Locale _locale(String languageCode) {
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');
  }

  static getLocale(){
    if(_deviceLanguage!="en" && _deviceLanguage!="es"){
      _deviceLanguage="en";
    }
    String languageCode = _sharedPreferences.getString(prefSelectedLanguageCode) ?? _deviceLanguage;
    return _locale(languageCode);
  }

  static Locale setLocale(String languageCode) {
    _sharedPreferences.setString(prefSelectedLanguageCode, languageCode);
    return _locale(languageCode);
  }

  static void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale =  setLocale(selectedLanguageCode);
    MyApp.setLocale(context, _locale);
  }

  static void setColor(int color){
    _sharedPreferences.setInt('colorTema', color);
  }

  static MaterialColor getColor(){
    int codColor= _sharedPreferences.getInt('colorTema');
    if(codColor==null || codColor==0){
      return Colors.blue;
    }
    Color color= Color(codColor);
    Map<int, Color> colorCodes = {
      50: Color.fromRGBO(color.red, color.green, color.blue, .1),
      100: Color.fromRGBO(color.red, color.green, color.blue, .2),
      200: Color.fromRGBO(color.red, color.green, color.blue, .3),
      300: Color.fromRGBO(color.red, color.green, color.blue, .4),
      400: Color.fromRGBO(color.red, color.green, color.blue, .5),
      500: Color.fromRGBO(color.red, color.green, color.blue, .6),
      600: Color.fromRGBO(color.red, color.green, color.blue, .7),
      700: Color.fromRGBO(color.red, color.green, color.blue, .8),
      800: Color.fromRGBO(color.red, color.green, color.blue, .9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1),
    };

    MaterialColor matColor = new MaterialColor(color.value, colorCodes);
    
    return matColor;
  }

  static bool esOscuro(){
    Color color= SharedPref.getColor();
    double darkness = 1-(0.299*color.red + 0.587*color.green + 0.114*color.green)/255;
    return !(darkness<0.5);
  }

}