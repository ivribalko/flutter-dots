import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/path_painter.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DotComponent extends CircleComponent with Tappable {
  final Dot dot;
  final Color color;
  final PathPainter path = Get.find();

  DotComponent(
    this.dot,
    this.color,
    Vector2 position,
  ) : super(
          radius: 10,
          position: position,
          paint: Paint()..color = color,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    path.dots.add(this);
    path.color = color;
    path.points
      ..add(position.toOffset())
      ..add(position.toOffset());

    return false;
  }
}
