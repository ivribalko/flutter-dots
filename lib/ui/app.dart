import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'component/dot.dart';
import 'component/dot_highlight.dart';

class App extends FlameGame with HasCollidables, HasTappables {
  @override
  Future<void> onLoad() async {
    unawaited(add(Dot(
      position: size / 2,
    )..anchor = Anchor.center));

    unawaited(add(DotHighlight(
      position: size / 2,
    )..anchor = Anchor.center));

    return super.onLoad();
  }
}
