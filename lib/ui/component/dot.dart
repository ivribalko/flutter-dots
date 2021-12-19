import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DotComponent extends CircleComponent {
  final Dot dot;
  final RxBool highlighted = false.obs;

  DotComponent(
    this.dot,
    Vector2 position,
  ) : super(
          radius: kDotRadius,
          position: position,
          paint: Paint(),
        );

  @override
  Future<void>? onLoad() {
    var paintComponent = paint;
    var paintHighlight = Paint();

    add(CircleComponent(
      paint: paintHighlight,
      position: Vector2.all(kDotRadius - kDotHighlightRadius),
      radius: kDotHighlightRadius,
    ));

    CombineLatestStream.list([
      dot.color.stream.startWith(dot.color.value).distinct(),
      highlighted.stream.startWith(highlighted.value).distinct(),
    ]).listen((l) => set(
          paintComponent,
          paintHighlight,
          l[0] as int?,
          l[1] as bool,
        ));

    return super.onLoad();
  }

  void set(
    Paint paintComponent,
    Paint paintHighlight,
    int? colorIndex,
    bool highlighted,
  ) {
    var color = colorIndex == null ? Colors.transparent : kColors[colorIndex];

    paintComponent.color = color;
    paintHighlight.color = color.withAlpha(highlighted ? 100 : 0);
  }
}
