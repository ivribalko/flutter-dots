import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/component/dot.dart';

class PathPainter extends CustomPainter {
  List<Offset> points = [];
  List<DotComponent> dots = [];
  Color color = Colors.transparent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.polygon,
        points,
        Paint()
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
