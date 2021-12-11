import 'package:flutter_app/ui/path_painter.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DotComponent extends PositionComponent
    with HasHitboxes, Collidable, Tappable {
  final Color color;
  final PathPainter path = Get.find();

  DotComponent({
    required Vector2 position,
    required Color color,
  })  : color = color,
        super(
          position: position,
          size: Vector2.all(20),
        );

  @override
  bool onTapDown(TapDownInfo info) {
    path.color = color;
    path.points
      ..add(position.toOffset())
      ..add(position.toOffset());

    return false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(
      canvas,
      paint: Paint()..color = color,
    );
  }
}
