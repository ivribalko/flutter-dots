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

    path.dots.stream.listen((picked) {
      for (var dotView in children.query<DotView>()) {
        dotView.picked.value = picked.contains(dotView);
      }
    });
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    var dots = path.dots;
    for (var dotView in children.query<DotView>()) {
      if (dotView.containsPoint(info.eventPosition.global)) {
        if (dots.isEmpty) {
          path.color = kColors[dotView.data.color.value!];
          dots.add(dotView);
        } else if (dots.first.data.color.value == dotView.data.color.value) {
          var next = dotView.data;
          if (dots.length > 1 && next == dots[dots.length - 2].data) {
            dots.removeLast();
          } else if (connectable(dots.last.data, next)) {
            dots.add(dotView);
          }
        }

        break;
      }
    }

    super.onDragUpdate(pointerId, info);
  }

  bool connectable(DotData last, DotData next) =>
      last.x == next.x && (last.y - next.y).abs() == 1 ||
      last.y == next.y && (last.x - next.x).abs() == 1;

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    var dots = path.dots;
    if (dots.length > 1) {
      if (dots.length > dots.toSet().length) {
        var color = dots.first.data.color.value;
        model.traverse((data) {
          if (data.color.value == color) {
            data.color.value = null;
          }
        });
      } else {
        for (var dotView in dots) {
          dotView.data.color.value = null;
        }
      }
    }

    dots.clear();
    model.refresh();
    super.onDragEnd(pointerId, info);
  }

  @override
  Future<void>? onLoad() {
    add(CustomPainterComponent(
      painter: path,
    )..anchor = Anchor.center);

    final side = kBetween * (model.side - 1);

    final start = Vector2(
      size.x / 2 - side / 2,
      size.y / 2 - side / 2,
    );

    model.traverse(null, (data, x, y) {
      add(DotView(
        data,
        Vector2(
          start.x + kBetween * y,
          start.y + kBetween * x,
        ),
      )..anchor = Anchor.center);
    });

    children.register<DotView>();

    return super.onLoad();
  }
}
