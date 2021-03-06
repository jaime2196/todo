import 'package:flutter/material.dart';
import 'package:to_do/services/SharedPref.dart';

class HeaderPaintWaves extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = SharedPref.getColor()[500]
    ..style = PaintingStyle.fill
    ..strokeWidth = 10;
    
    final path = Path();
    path.lineTo(0, size.height * 0.30);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.35,
      size.width * 0.5, size.height * 0.30);
    path.quadraticBezierTo(size.width * 0.75,size.height * 0.22,                                 
      size.width, size.height *0.25);  
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);


    ///
    final paint2 = Paint()
    ..color = SharedPref.getColor()[500]
    ..style = PaintingStyle.fill
    ..strokeWidth = 10;

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.60);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.55,
      size.width * 0.5, size.height * 0.60);
    path2.quadraticBezierTo(size.width * 0.75,size.height * 0.70,                                 
      size.width, size.height *0.60);  
    path2.lineTo(size.width, size.height);
    canvas.drawPath(path2, paint2);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}