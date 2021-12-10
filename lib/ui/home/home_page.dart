import 'package:flutter/material.dart';
import 'package:flutter_app/src/model.dart';
import 'package:get/get.dart';

import '../routes.dart';

class HomePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text('${model.count.value}')),
              IconButton(
                onPressed: () => model.count + 1,
                icon: Icon(Icons.add),
              ),
              IconButton(
                onPressed: () => Get.toNamed(
                  Routes.page,
                  arguments: model.count.value,
                ),
                icon: Icon(Icons.link),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
