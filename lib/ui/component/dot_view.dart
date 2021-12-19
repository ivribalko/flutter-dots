import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DotView extends CircleComponent {
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
    var paintSelf = paint;
    var paintPick = Paint();

    add(CircleComponent(
      paint: paintPick,
      position: Vector2.all(kDotRadius - kDotHighlightRadius),
      radius: kDotHighlightRadius,
    ));

    CombineLatestStream.list([
      data.color.stream.startWith(data.color.value).distinct(),
      picked.stream.startWith(picked.value).distinct(),
    ]).listen((l) => set(
          paintSelf,
          paintPick,
          l[0] as int?,
          l[1] as bool,
        ));

    return super.onLoad();
  }

  void set(
    Paint paintSelf,
    Paint paintPick,
    int? colorIndex,
    bool highlighted,
  ) {
    var color = colorIndex == null ? Colors.transparent : kColors[colorIndex];

    paintSelf.color = color;
    paintPick.color = color.withAlpha(highlighted ? 100 : 0);
  }
}
