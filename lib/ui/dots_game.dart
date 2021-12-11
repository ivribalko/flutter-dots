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
    path.points.last = info.eventPosition.global.toOffset();
    super.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
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

        var color = colors[model.dots[x][y].color];

        add(DotComponent(
          position: position,
          color: color,
        )..anchor = Anchor.center);

        add(DotHighlightComponent(
          position: position,
          color: color,
        )..anchor = Anchor.center);
      }
    }

    return super.onLoad();
  }
}
