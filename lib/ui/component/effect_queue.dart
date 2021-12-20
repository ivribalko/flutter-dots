import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

mixin EffectQueue on PositionComponent {
  final Queue<Effect> _queue = Queue<Effect>();

  Effect? _playing;

  void append(Effect effect, {Function? onLoaded}) {
    var lifecycle = LifecycleComponent();
    lifecycle.onLoaded = onLoaded;
    lifecycle.onRemoved = () {
      assert(_playing == effect);
      _playing = null;
      _playNext();
    };
    effect.add(lifecycle);
    _queue.add(effect);
    _playNext();
  }

  void _playNext() {
    if (_queue.isEmpty) {
      return;
    }

    if (_playing != null) {
      return;
    }

    add(_playing = _queue.removeFirst());
  }
}

class LifecycleComponent extends Component {
  Function? onLoaded;
  Function? onRemoved;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    onLoaded?.call();
  }

  @override
  void onRemove() {
    super.onRemove();
    onRemoved?.call();
  }
}
