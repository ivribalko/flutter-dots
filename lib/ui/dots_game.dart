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
    var points = path.points;

    if (points.isNotEmpty) {
      var dots = path.dots;
      var offset = info.eventPosition.global;

      for (var component in children.query<DotComponent>()) {
        if (component.containsPoint(offset)) {
          if (dots.first.color == component.color) {
            var last = dots.last.dot;
            var item = component.dot;
            if (last.x == item.x && (last.y - item.y).abs() == 1 ||
                last.y == item.y && (last.x - item.x).abs() == 1) {
              dots.add(component);
              points.insert(
                points.length - 1,
                component.position.toOffset(),
              );
            }
          }
        }
      }

      points.last = offset.toOffset();
    }

    super.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    path.dots.clear();
    path.points.clear();
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
