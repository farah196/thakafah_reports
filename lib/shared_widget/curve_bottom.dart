


import 'package:flutter/material.dart';

class CurveBottom   extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Circle

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(130, 163, 209, 207)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_1 = Path();
    path_1.moveTo(size.width*1.0533464,size.height*1.0181086);
    path_1.cubicTo(size.width*0.9300861,size.height*1.0323472,size.width*0.2095960,size.height*1.0325491,size.width*0.0671953,size.height*1.0067407);
    path_1.cubicTo(size.width*-0.0009998,size.height*0.9083687,size.width*0.3458315,size.height*0.6647108,size.width*0.5358080,size.height*0.4927221);
    path_1.cubicTo(size.width*0.6443561,size.height*0.3944367,size.width*0.9123043,size.height*0.0910833,size.width*1.0316780,size.height*0.2632163);
    path_1.cubicTo(size.width*1.0606637,size.height*0.3615595,size.width*1.0815324,size.height*0.8349107,size.width*1.0533464,size.height*1.0181086);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);


    // Circle

    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(125, 163, 209, 207)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_1, paint_stroke_1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

