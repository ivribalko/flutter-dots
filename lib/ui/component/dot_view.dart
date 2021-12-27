import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/component/effect_queue.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:flutter_app/ui/single_audio.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DotView extends CircleComponent with EffectQueue {
  final DotData data;
  final RxBool picked = false.obs;

  DotView(
    this.data,
    Vector2 position,
  ) : super(
          radius: kDotRadius,
          position: position,
          paint: Paint(),
        );

  @override
  Future<void>? onLoad() {
    data.color.stream.startWith(data.color.value).listen((i) {
      append(
        ScaleEffect.to(
          Vector2.zero(),
          CurvedEffectController(
            kDuration,
            Curves.elasticInOut,
          )..advance(0.3),
        ),
        onLoaded: () => SingleAudio.play('show.mp3'),
      );

      append(
        ScaleEffect.to(
          Vector2.all(1),
          CurvedEffectController(
            kDuration,
            Curves.elasticInOut,
          )..advance(0.3),
        ),
        onLoaded: () {
          paint.color = kColors[i];
          SingleAudio.play('show.mp3');
        },
      );
    });

    var pickedView = _PickedView(Vector2.all(kDotRadius - kDotHighlightRadius));

    add(pickedView);

    picked.stream.startWith(picked.value).distinct().listen(pickedView.set);

    return super.onLoad();
  }
}

class _PickedView extends CircleComponent with HasPaint {
  static OpacityEffect? _existing;

  _PickedView(
    Vector2 position,
  ) : super(
          radius: kDotHighlightRadius,
          position: position,
          paint: Paint(),
        );

  void set(bool picked) {
    FlameAudio.play('pick.mp3');
    if (picked) {
      var dt =
          _existing?.isMounted ?? false ? _existing!.controller.progress : 0.0;
      add(_existing = OpacityEffect.fadeOut(
        InfiniteEffectController(
          SequenceEffectController([
            LinearEffectController(kDuration),
            ReverseLinearEffectController(kDuration),
          ]),
        )..advance(dt),
      ));
    } else if (children.any((it) => it is OpacityEffect)) {
      remove(children.firstWhere((it) => it is OpacityEffect));
    }
    paint.color =
        findParent<DotView>()!.paint.color.withAlpha(picked ? 100 : 0);
  }
}
