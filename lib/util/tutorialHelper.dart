
import 'package:flutter/material.dart';
import 'package:tutorial/tutorial.dart';

class TutorialHelper{

  static TutorialItens getAyuda(GlobalKey key, String texto, ShapeFocus forma){
    return TutorialItens(
      globalKey: key,
      touchScreen: true,
          top: 250,
          left: 50,
          children: [
            Text(
              texto/*"Pulse en el botón para crear su primera lista."*/,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 50,
            )
          ],
        widgetNext: Text(
            "Toque para continuar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          shapeFocus: forma
      );
    
  }
}