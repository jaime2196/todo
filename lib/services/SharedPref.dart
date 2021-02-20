


import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/models/Lista.dart';


class SharedPref{

  static SharedPreferences _sharedPreferences;
  static init() async{
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

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
}