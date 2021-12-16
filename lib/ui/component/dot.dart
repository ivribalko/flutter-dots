import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class DotComponent extends CircleComponent {
  final Dot dot;
  final Color color;
  final RxBool highlighted = false.obs;

  DotComponent(
    this.dot,
    this.color,
    Vector2 position,
  ) : super(
          radius: kDotRadius,
          position: position,
          paint: Paint()..color = color,
        );

  @override
  Future<void>? onLoad() {
    var paint = Paint()..color;

    add(CircleComponent(
      paint: paint,
      position: Vector2.all(kDotRadius - kDotHighlightRadius),
      radius: kDotHighlightRadius,
    ));

    highlighted.listen((v) => udpatePaint(paint, v));

    udpatePaint(paint, highlighted.value);

    return super.onLoad();
  }

  void udpatePaint(Paint paint, bool highlighted) {
    paint.color = highlighted ? color.withAlpha(100) : Colors.transparent;
  }
}
