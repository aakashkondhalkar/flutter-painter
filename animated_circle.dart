// Circle with projection with custom painter

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  double angle = 0;
  
  @override
  initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (t){
      setState((){
        tick();
      });
    });    
  }
  
  void tick() {

    if(angle >= 360) {
      angle = 0;
    } else {
      angle++;
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CustomPaint(
            //                       <-- CustomPaint widget
            size: const Size(200, 200),
            painter: CircleWidget(angle: angle),
          ),
        ),
      ),
    );
  }
}

class CircleWidget extends CustomPainter {
  
  final double angle;
  CircleWidget({this.angle = 0});
  
  @override
  void paint(Canvas canvas, Size size) {
    var fillPaint = Paint()
      ..color = const Color(0xFF192a3c)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    var outlinedPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    var coordinatePaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    
    var rotatorLinePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    
    var pojectionLinePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;


    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);

    var yCoordinatePath = Path()
      ..moveTo(centerX, centerY)
      ..lineTo(centerX, centerY - 200)
      ..lineTo(centerX, centerY + 200);
    
    var xCoordinatePath = Path()
      ..moveTo(centerX, centerY)
      ..lineTo(centerX - 200, centerY)
      ..lineTo(centerX + 200, centerY);

    var lineX = centerX + 100 * sin(angle * pi / 180);
    var lineY = centerY + 100 * cos(angle * pi / 180);

    canvas.drawLine(Offset(centerX, centerY), Offset(lineX, lineY), rotatorLinePaint);
    
    canvas.drawLine(Offset(lineX, lineY), Offset(lineX, 100), pojectionLinePaint);
    canvas.drawLine(Offset(lineX, lineY), Offset(100, lineY), pojectionLinePaint);
    
    canvas.drawPath(yCoordinatePath, coordinatePaint);
    canvas.drawPath(xCoordinatePath, coordinatePaint);
    
    canvas.drawCircle(center, 100, outlinedPaint);

    var outerCircleRadis = radius + 5;
    var innerCircleRadius = radius + 12;
    for(int i = 0; i < 360; i+=12) {
      var x1 = centerX + outerCircleRadis * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadis * sin(i * pi / 180);
      
      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), rotatorLinePaint);
    }    

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


