import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class Dot extends PositionComponent with HasHitboxes, Collidable {
  Dot({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(20),
        );

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
      paint: Paint()..color = Colors.white,
    );
  }
}
