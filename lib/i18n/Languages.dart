import 'package:flutter/material.dart';

abstract class Languages {
  
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }
  // Basico
  String get appName;
  String get labelNoListas;
  String get labelCrearLista;
  String get labelCancelar;
  String get labelCrear;
  String get labelGuardar;
  String get labelOpciones;
  String get labelInformacion;
  String get labeltarea;
  String get labelTareas;
  String get labelNombreTarea;
  String get labelNoTareas;
  String get labelTareaEliminada;
  String get labelDeshacer;
  String get labelNuevaLista;
  String get labelEditarTitulo;

  //Opciones
  String get labelEspanol;
  String get labelIngles;
  String get labelIdioma;
  String get labelMostrarTutorial;
  String get labelMostrar;
  //Tutorial
  


}