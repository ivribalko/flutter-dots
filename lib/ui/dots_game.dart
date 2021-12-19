import 'dart:async';
import 'package:flame/input.dart';
import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'component/dot_view.dart';
import 'path_painter.dart';

class DotsGame extends FlameGame
    with HasCollidables, HasTappables, HasDraggables, MultiTouchDragDetector {
  final Model model = Get.find();
  final List<DotView> dots = [];
  final PathPainter path = Get.put(PathPainter());

  DotsGame() {
    Get.put(this);

    path.dots.stream.listen((selected) {
      for (var dotComponent in children.query<DotView>()) {
        dotComponent.picked.value = selected.contains(dotComponent);
      }
    });
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    var dots = path.dots;
    for (var dotView in children.query<DotView>()) {
      if (dotView.containsPoint(info.eventPosition.global)) {
        if (dots.isEmpty) {
          path.color = dotView.paint.color;
          path.dots.add(dotView);
        } else if (dots.first.paint.color == dotView.paint.color) {
          var next = dotView.data;
          if (dots.length > 1 && next == dots[dots.length - 2].data) {
            dots.removeLast();
          } else {
            var last = dots.last.data;
            if (last.x == next.x && (last.y - next.y).abs() == 1 ||
                last.y == next.y && (last.x - next.x).abs() == 1) {
              dots.add(dotView);
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
      var color = path.dots.first.data.color.value;
      model.traverse((dot) {
        if (dot.color.value == color) {
          dot.color.value = null;
        }
      });
    } else if (path.dots.length > 1) {
      model.traverse((dot) {
        if (path.dots.any((i) => i.data == dot)) {
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

      add(DotView(
        dot,
        position,
      )..anchor = Anchor.center);
    });

    children.register<DotView>();

    return super.onLoad();
  }
}
