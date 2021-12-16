// ignore_for_file: unawaited_futures

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
  final PathPainter path = Get.put(PathPainter());
  final Model model = Get.find();
  final List<DotComponent> dots = [];

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
          path.color = component.color;
          path.dots.add(component);
        } else if (dots.first.color == component.color) {
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
    path.dots.clear();
    super.onDragEnd(pointerId, info);
  }

  @override
  Future<void> onLoad() async {
    add(CustomPainterComponent(
      painter: path,
    )..anchor = Anchor.center);

    final side = kBetween * (model.size - 1);

    final start = Vector2(
      size.x / 2 - side / 2,
      size.y / 2 - side / 2,
    );

    for (var x = 0; x < model.size; x++) {
      for (var y = 0; y < model.size; y++) {
        var position = Vector2(
          start.x + kBetween * y,
          start.y + kBetween * x,
        );

        var dot = model.dots[x][y];
        var color = kColors[dot.color];

        add(DotComponent(
          dot,
          color,
          position,
        )..anchor = Anchor.center);
      }
    }

    children.register<DotComponent>();

    return super.onLoad();
  }
}
