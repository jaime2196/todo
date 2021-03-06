
import 'package:flutter/material.dart';
import 'package:tutorial/tutorial.dart';

class TutorialHelper{

  static TutorialItens getAyuda(GlobalKey key, String texto, ShapeFocus forma, String textoContinuar){
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
        widgetNext: Row(
          children: [
            Icon(Icons.forward, color: Colors.white,),
            SizedBox(width: 5),
            Text(
                textoContinuar,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            SizedBox(width: 5),
            Icon(Icons.forward, color: Colors.white,),
          ],
        ),
          shapeFocus: forma
      );
    
  }
}