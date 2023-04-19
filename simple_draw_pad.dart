import 'package:flutter/material.dart';
import 'dart:ui';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SimpleDrawPadWidget(),
        ),
      ),
    );
  }
}

class Point {
  final double dx;
  final double dy;

  Point(this.dx, this.dy);

  get x => dx;
  get y => dy;

  @override
  String toString() {
    return "X:$x -- Y:$y";
  }
}

class SimpleDrawPadWidget extends StatefulWidget {
  @override
  State<SimpleDrawPadWidget> createState() => _SimpleDrawPadWidgetState();
}

class _SimpleDrawPadWidgetState extends State<SimpleDrawPadWidget> {
  List<Point?> points = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: GestureDetector(
      onPanDown: (details) {
        setState(() {
          points
              .add(Point(details.globalPosition.dx, details.globalPosition.dy));
        });
      },
      onPanStart: (details) {
        setState(() {
          points
              .add(Point(details.globalPosition.dx, details.globalPosition.dy));
        });
      },
      onPanUpdate: (details) {
        setState(() {
          points
              .add(Point(details.globalPosition.dx, details.globalPosition.dy));
        });
      },
      onPanEnd: (details) {
        setState(() {
          points.add(null);
        });
      },
      child: CustomPaint(
          size: Size(width, height),
          painter: SimpleDrawPadPainter(points: points)),
    ));
  }
}

class SimpleDrawPadPainter extends CustomPainter {
  final List<Point?> points;
  final List<Offset> offsets = [];

  SimpleDrawPadPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // Draw lines while user moving mouse or fingure
        canvas.drawLine(Offset(points[i]!.dx, points[i]!.dy),
            Offset(points[i + 1]!.dx, points[i + 1]!.dy), linePaint);
      } else if (points[i] != null && points[i + 1] == null) {
        // Draw single dot after if user starts drawing again
        offsets.clear();
        offsets.add(Offset(points[i]!.dx, points[i]!.dy));
        canvas.drawPoints(PointMode.points, offsets, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(SimpleDrawPadPainter oldDelegate) => true;
}
