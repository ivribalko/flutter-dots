import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class DotComponent extends PositionComponent with HasHitboxes, Collidable {
  final Color color;

  DotComponent({
    required Vector2 position,
    required Color color,
  })  : color = color,
        super(
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
      paint: Paint()..color = color,
    );
  }
}
