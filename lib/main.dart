import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'ioc.dart';
import 'ui/app.dart';
import 'ui/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    CommonFutureBuilder(
      future: IoC.init(),
      result: (dynamic _) => GameWidget(
        game: App(),
      ),
    ),
  );
}
