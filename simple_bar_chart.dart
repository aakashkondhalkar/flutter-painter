import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<int> data = [50, 100, 75, 150, 80];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bar Chart with Custom Painter'),
        ),
        body: Center(
          child: Container(
            width: 500,
            height: 400,
            child: CustomPaint(
              painter: BarChartPainter(data),
            ),
          ),
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> data;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final double chartWidth = size.width;
    final double chartHeight = size.height;
    final double barWidth = chartWidth / data.length;
    final int maxBarHeight = data.reduce((max, value) => max > value ? max : value);
    final double unitHeight = chartHeight / maxBarHeight;

    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw vertical coordinate lines
    for (int i = 0; i <= data.length; i++) {
      double x = i * barWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, chartHeight), paint);
    }

    // Draw horizontal coordinate lines
    for (int i = 0; i <= maxBarHeight; i += 25) {
      double y = chartHeight - (i * unitHeight);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), paint);

      TextSpan span = TextSpan(
        text: i.toString(),
        style: TextStyle(color: Colors.black, fontSize: 12),
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(-25, y - tp.height / 2));
    }

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      double barHeight = data[i] * unitHeight;
      double x = i * barWidth;
      double y = chartHeight - barHeight;
      Rect barRect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
