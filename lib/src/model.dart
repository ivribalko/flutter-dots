import 'package:get/get.dart';

class Model extends GetxController {
  int get size => dots.length;
  final List<List<Dot>> dots = [
    [Dot(0), Dot(0), Dot(2), Dot(3)],
    [Dot(0), Dot(0), Dot(2), Dot(3)],
    [Dot(0), Dot(1), Dot(2), Dot(3)],
    [Dot(0), Dot(1), Dot(2), Dot(3)],
  ];
}

class Dot {
  final int color;

  Dot(this.color);
}
