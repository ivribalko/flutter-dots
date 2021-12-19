import 'dart:math';

import 'package:flutter_app/ui/config.dart';
import 'package:get/get.dart';
import 'package:darq/darq.dart';

class Model {
  int get size => 4;
  final List<List<Dot>> dots = [
    [0, 0, 2, 3],
    [0, 0, 2, 3],
    [0, 1, 2, 3],
    [0, 1, 2, 3],
  ].select((e, y) => e.select((e, x) => Dot(e, x, y)).toList()).toList();

  void traverse([
    void Function(Dot)? action1,
    void Function(Dot, int, int)? action2,
  ]) {
    for (var x = 0; x < size; x++) {
      for (var y = 0; y < size; y++) {
        action1?.call(dots[x][y]);
        action2?.call(dots[x][y], x, y);
      }
    }
  }

  void refresh() {
    var random = Random();
    traverse((dot) {
      dot.color.value ??= random.nextInt(kColors.length);
    });
  }
}

class Dot {
  final int x;
  final int y;
  final RxnInt color;

  Dot(int? color, this.x, this.y) : color = RxnInt(color);
}
