import 'package:flame/effects.dart';
import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/component/effect_queue.dart';
import 'package:flutter_app/ui/config.dart';
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
    var paintPick = Paint();

    add(CircleComponent(
      paint: paintPick,
      position: Vector2.all(kDotRadius - kDotHighlightRadius),
      radius: kDotHighlightRadius,
    ));

    data.color.stream.startWith(data.color.value).listen((i) {
      append(
        ScaleEffect.to(
          Vector2.zero(),
          CurvedEffectController(
            kDuration,
            Curves.elasticInOut,
          )..advance(0.3),
        ),
      );

      append(
        ScaleEffect.to(
          Vector2.all(1),
          CurvedEffectController(
            kDuration,
            Curves.elasticInOut,
          )..advance(0.3),
        ),
        onLoaded: () => paint.color = kColors[i],
      );
    });

    picked.stream.startWith(picked.value).distinct().listen((picked) {
      paintPick.color = paint.color.withAlpha(picked ? 100 : 0);
    });

    return super.onLoad();
  }
}
