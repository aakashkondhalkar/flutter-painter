// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Delivery> deliveries = [];

  @override
  void initState() {
    deliveries.addAll([
      Delivery(2200000, DateTime(2024, DateTime.april, 5)),
      Delivery(1000000, DateTime(2024, DateTime.april, 6)),
      Delivery(100000, DateTime(2024, DateTime.april, 7)),
      Delivery(900000, DateTime(2024, DateTime.april, 8)),
      Delivery(2000000, DateTime(2024, DateTime.april, 9)),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 32.0, left: 16, right: 16, bottom: 16),
        child: CustomPaint(
          size: size,
          painter: HorizontalBar(deliveries),
        ),
      ),
    );
  }
}

class Delivery {
  final int qty;
  final DateTime date;

  Delivery(this.qty, this.date);
}

class HorizontalBar extends CustomPainter {
  final List<Delivery> deliveries;

  HorizontalBar(this.deliveries);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    int numberOfXLables = (deliveries.length / 1.5).floor();
    int numberOfYLables = deliveries.length;

    var linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Vertical Line (y co-ordinate)
    canvas.drawLine(Offset(0, height), Offset(0, 0), linePaint);
    // Horizontal Line (x co-ordinate)
    canvas.drawLine(Offset(0, 0), Offset(width, 0), linePaint);

    var maxValue = deliveries.map((d) => d.qty).reduce((a, b) => a > b ? a : b);

    // Horizontal ticks
    for (int i = 0; i < numberOfXLables; i++) {
      var x = (width / numberOfXLables) * i;
      canvas.drawLine(Offset(x, 2), Offset(x, -5), linePaint);

      var label = i * (maxValue / numberOfXLables);

      // Label
      TextPainter painter = TextPainter(
        text: TextSpan(
            text: label.toInt().toString(),
            style: TextStyle(fontSize: 12, color: Colors.white)),
        textDirection: TextDirection.rtl,
      );

      painter.layout();

      painter.paint(canvas, Offset(x - (painter.width / 2), -24));
    }

    // Horizontal Bars
    var barSpacing = 16;

    for (int i = 0; i < numberOfYLables; i++) {
      var y = (height / numberOfYLables) * i;
      var barHHight = deliveries[i].qty * (width / maxValue);
      var barThickness = (height / numberOfYLables) - barSpacing;
      // canvas.drawLine(Offset(0, y), Offset(5, y), linePaint);
      canvas.drawRect(
          Rect.fromLTWH(0, y + barSpacing, barHHight, barThickness), linePaint);

      // Label
      TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: deliveries[i].date.day.toString(),
            style: TextStyle(fontSize: 12, color: Colors.white)),
        textDirection: TextDirection.rtl,
      );

      textPainter.layout();

      textPainter.paint(
          canvas, Offset(-10, (y + ((barThickness + barSpacing) / 2))));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
