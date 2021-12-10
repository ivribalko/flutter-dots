import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

///
class DotComponent extends PositionComponent with HasHitboxes, Collidable {
  /// Create a new Rocket component at the given [position].
  DotComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas, paint: Paint()..color = Colors.white);
  }
}
