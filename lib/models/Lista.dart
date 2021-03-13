// To parse this JSON data, do
//
//     final lista = listaFromJson(jsonString);

import 'dart:convert';

Lista listaFromJson(String str) => Lista.fromJson(json.decode(str));

List<Lista> listaListaFromJson(String str) => List<Lista>.from(json.decode(str).map((x) => Lista.fromJson(x)));
String listaListaToJson(List<Lista> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String listaToJson(Lista data) => json.encode(data.toJson());

class Lista {
    Lista({
        this.id,
        this.nombreLista,
        this.tareas,
    });

    int id;
    String nombreLista;
    List<Tarea> tareas;

    factory Lista.fromJson(Map<String, dynamic> json) => Lista(
        id: json["id"],
        nombreLista: json["nombreLista"],
        tareas: List<Tarea>.from(json["tareas"].map((x) => Tarea.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreLista": nombreLista,
        "tareas": List<dynamic>.from(tareas.map((x) => x.toJson())),
    };
}

class Tarea {
    Tarea({
        this.nombre,
        this.completada,
    });

    String nombre;
    bool completada;

    factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        nombre: json["nombre"],
        completada: json["completada"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "completada": completada,
    };
}

class UtilLista{

  static List<Lista> generateLista(List<dynamic> list){
    List<Lista> listaListas=  [];
    Lista lista;
    list.forEach((element) { 
      lista = new Lista(nombreLista: element["nombreLista"], tareas: null);
      listaListas.add(lista);
    });
    return listaListas;
  }

  
}