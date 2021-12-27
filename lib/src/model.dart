import 'dart:math';
import 'package:get/get.dart';
import 'package:darq/darq.dart';

class Model {
  final int side = 4;
  final int colors = 4;
  final List<List<DotData>> dots = [
    [0, 0, 2, 3],
    [0, 0, 2, 3],
    [0, 1, 2, 3],
    [0, 1, 2, 0],
  ].select((e, y) => e.select((e, x) => DotData(e, x, y)).toList()).toList();

  void traverse([
    void Function(DotData)? action1,
    void Function(DotData, int, int)? action2,
  ]) {
    for (var x = 0; x < side; x++) {
      for (var y = 0; y < side; y++) {
        action1?.call(dots[x][y]);
        action2?.call(dots[x][y], x, y);
      }
    }
  }
}

class DotData {
  final int x;
  final int y;
  final RxInt color;

  DotData(int color, this.x, this.y) : color = RxInt(color);

  void recolor() {
    var next = Random().nextInt(Get.find<Model>().colors);
    if (color.value == next) {
      color.trigger(next);
    } else {
      // won't trigger same
      color.value = next;
    }
  }
}
