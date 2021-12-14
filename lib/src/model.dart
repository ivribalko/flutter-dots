import 'package:get/get.dart';
import 'package:darq/darq.dart';

class Model extends GetxController {
  int get size => dots.length;
  final List<List<Dot>> dots = [
    [0, 0, 2, 3],
    [0, 0, 2, 3],
    [0, 1, 2, 3],
    [0, 1, 2, 3],
  ].select((e, y) => e.select((e, x) => Dot(e, x, y)).toList()).toList();
}

class Dot {
  final int color;
  final int x;
  final int y;

  Dot(this.color, this.x, this.y);
}
