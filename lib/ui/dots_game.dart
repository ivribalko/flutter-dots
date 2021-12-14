// ignore_for_file: unawaited_futures

import 'dart:async';
import 'package:flame/input.dart';
import 'package:flutter_app/src/model.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'component/dot.dart';
import 'component/dot_highlight.dart';
import 'path_painter.dart';

class DotsGame extends FlameGame
    with HasCollidables, HasTappables, HasDraggables, MultiTouchDragDetector {
  late PathPainter path;
  final Model model = Get.find();
  final double between = 50;
  final List<DotComponent> dots = [];
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  DotsGame() {
    Get.put(this);
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
      painter: path = Get.put(PathPainter()),
    )..anchor = Anchor.center);

    final side = between * (model.size - 1);

    final start = Vector2(
      size.x / 2 - side / 2,
      size.y / 2 - side / 2,
    );

    for (var x = 0; x < model.size; x++) {
      for (var y = 0; y < model.size; y++) {
        var position = Vector2(
          start.x + between * y,
          start.y + between * x,
        );

        var dot = model.dots[x][y];
        var color = colors[dot.color];

        add(DotComponent(
          dot,
          color,
          position,
        )..anchor = Anchor.center);

        add(DotHighlightComponent(
          position: position,
          color: color,
        )..anchor = Anchor.center);
      }
    }

    children.register<DotComponent>();

    return super.onLoad();
  }
}
