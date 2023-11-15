
import 'package:flutter/material.dart';
class CurveTop  extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Circle

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(130, 214, 203, 149)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_1 = Path();
    path_1.moveTo(size.width*-0.0074583,size.height*-0.0109143);
    path_1.cubicTo(size.width*0.1120000,size.height*-0.0250143,size.width*0.8102667,size.height*-0.0252143,size.width*0.9482750,size.height*0.0003429);
    path_1.cubicTo(size.width*1.0143667,size.height*0.0977571,size.width*0.6782333,size.height*0.3390429,size.width*0.4941167,size.height*0.5093571);
    path_1.cubicTo(size.width*0.3889167,size.height*0.6066857,size.width*0.1292333,size.height*0.9070857,size.width*0.0135417,size.height*0.7366286);
    path_1.cubicTo(size.width*-0.0145500,size.height*0.6392429,size.width*-0.0347750,size.height*0.1705000,size.width*-0.0074583,size.height*-0.0109143);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);


    // Circle

    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(125, 214, 203, 149)
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







