import 'dart:async';
import 'package:flame/input.dart';
import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'component/dot.dart';
import 'path_painter.dart';

class DotsGame extends FlameGame
    with HasCollidables, HasTappables, HasDraggables, MultiTouchDragDetector {
  final Model model = Get.find();
  final List<DotComponent> dots = [];
  final PathPainter path = Get.put(PathPainter());

  DotsGame() {
    Get.put(this);

    path.dots.stream.listen((selected) {
      for (var dotComponent in children.query<DotComponent>()) {
        dotComponent.highlighted.value = selected.contains(dotComponent);
      }
    });
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    var dots = path.dots;
    for (var component in children.query<DotComponent>()) {
      if (component.containsPoint(info.eventPosition.global)) {
        if (dots.isEmpty) {
          path.color = component.paint.color;
          path.dots.add(component);
        } else if (dots.first.paint.color == component.paint.color) {
          var next = component.dot;
          if (dots.length > 1 && next == dots[dots.length - 2].dot) {
            dots.removeLast();
          } else {
            var last = dots.last.dot;
            if (last.x == next.x && (last.y - next.y).abs() == 1 ||
                last.y == next.y && (last.x - next.x).abs() == 1) {
              dots.add(component);
            }
          }
        }

        break;
      }
    }

    super.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    if (path.dots.length > path.dots.toSet().length) {
      var color = path.dots.first.dot.color.value;
      model.traverse((dot) {
        if (dot.color.value == color) {
          dot.color.value = null;
        }
      });
    } else if (path.dots.length > 1) {
      model.traverse((dot) {
        if (path.dots.any((i) => i.dot == dot)) {
          dot.color.value = null;
        }
      });
    }
    model.refresh();
    path.dots.clear();
    super.onDragEnd(pointerId, info);
  }

  @override
  Future<void>? onLoad() {
    add(CustomPainterComponent(
      painter: path,
    )..anchor = Anchor.center);

    final side = kBetween * (model.size - 1);

    final start = Vector2(
      size.x / 2 - side / 2,
      size.y / 2 - side / 2,
    );

    model.traverse(null, (dot, x, y) {
      var position = Vector2(
        start.x + kBetween * y,
        start.y + kBetween * x,
      );

      add(DotComponent(
        dot,
        position,
      )..anchor = Anchor.center);
    });

    children.register<DotComponent>();

    return super.onLoad();
  }
}
