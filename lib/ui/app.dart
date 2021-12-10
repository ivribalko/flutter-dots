import 'dart:async';

import 'package:flame/game.dart';

import 'dot_component.dart';

class App extends FlameGame with HasCollidables {
  @override
  Future<void> onLoad() async {
    unawaited(add(DotComponent(
      position: size / 2,
      size: Vector2.all(20),
    )));

    return super.onLoad();
  }
}
