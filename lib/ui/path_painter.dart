import 'dart:ui';

import 'package:flame/src/extensions/vector2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/component/dot_view.dart';
import 'package:get/get.dart';

class PathPainter extends CustomPainter {
  RxList<DotView> dots = <DotView>[].obs;
  Color color = Colors.transparent;
  List<Offset> _points = [];

  PathPainter() {
    dots.stream.listen((i) {
      _points = i.map((e) => e.position.toOffset()).toList();
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.polygon,
        _points,
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
