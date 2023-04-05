import 'package:flutter/material.dart';
import 'dart:math';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class Data {
  int x;
  int y;
  Data(this.x, this.y);
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
        body: BarChart(),
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    List<int> data = [4, 5, 8, 2, 9, 1, 3, 1, 6, 7];
    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        size: Size(width, height),
        painter: BarChartPainter(data: data),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> data;

  BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    var coordinateLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    var barPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    var barPaint2 = Paint()..color = Colors.transparent;

    var vLineStart = Offset(0, size.height);
    var vLineEnd = const Offset(0, 0);

    var hLineStart = Offset(0, size.height);
    var hLineEnd = Offset(size.width, size.height);

    canvas.drawLine(vLineStart, vLineEnd, coordinateLinePaint);
    canvas.drawLine(hLineStart, hLineEnd, coordinateLinePaint);

    var totalBars = data.length;
    var barWidth = (size.width - 32) / totalBars;
    var totalWidthWithSpace = barWidth + 2;

    var maxLabelsValue = data.reduce(max);

    // We need to get height for single data value
    // Which we can use for bar height
    // We can calculate bar height in `calculatBarHeight` function below
    var heightPerValue = size.height / maxLabelsValue;

    // Calculate height for given X value
    // e.g if value is 2 means height of bar will
    // be 2 multiply by heightPerValue which is 20
    // of screen height
    double calculatBarHeight(int value) {
      return value * heightPerValue;
    }

    var paddingAtFirstBar = 12;

    // Draw bars
    for (double i = 0; i < totalBars; i++) {
      var barHeight = calculatBarHeight(
          data[i.toInt()]); //size.height * (data[i.toInt()] / 100);

      var barOffsetX = i * totalWidthWithSpace + paddingAtFirstBar;

      var rect = Offset(barOffsetX, size.height - barHeight) &
          Size(barWidth * 1.0, barHeight);
      canvas.drawRect(rect, barPaint);

      // Draw X-axis lines for labels
      canvas.drawLine(Offset(barOffsetX - 1, size.height - 10),
          Offset(barOffsetX - 1, size.height), coordinateLinePaint);
    }

    // Draw Y-axis lines for labels
    for (double i = 0; i <= size.height; i += heightPerValue) {
      canvas.drawLine(Offset(0, i), Offset(10, i), coordinateLinePaint);
    }

    print(totalBars);
    print(barWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
