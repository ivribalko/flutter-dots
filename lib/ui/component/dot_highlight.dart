import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DotHighlightComponent extends PositionComponent
    with HasHitboxes, Collidable, Tappable {
  final Color color;

  Color _color = Colors.transparent;

  /// Create a new Rocket component at the given [position].
  DotHighlightComponent({
    required Vector2 position,
    required Color color,
  })  : color = color.withAlpha(100),
        super(
          position: position,
          size: Vector2.all(30),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    _color = color;
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    _color = Colors.transparent;
    return false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(
      canvas,
      paint: Paint()..color = _color,
    );
  }
}
