import 'dart:async';
import 'package:flutter_app/src/model.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'component/dot.dart';
import 'component/dot_highlight.dart';

class App extends FlameGame with HasCollidables, HasTappables {
  final Model model = Get.find();
  final double between = 50;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  Future<void> onLoad() async {
    final side = between * (model.size - 1);

    final start = Vector2(
      size.x / 2 - side / 2,
      size.y / 2 + side / 2,
    );

    for (var x = 0; x < model.size; x++) {
      for (var y = 0; y < model.size; y++) {
        var position = Vector2(
          start.x + between * y,
          start.y - between * x,
        );

        var color = colors[model.dots[x][y].color];

        unawaited(add(DotComponent(
          position: position,
          color: color,
        )..anchor = Anchor.center));

        unawaited(add(DotHighlightComponent(
          position: position,
          color: color,
        )..anchor = Anchor.center));
      }
    }

    return super.onLoad();
  }
}
