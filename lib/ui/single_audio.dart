import 'package:flame_audio/flame_audio.dart';

class SingleAudio {
  static final List<String> _playing = [];

  static void play(String name) async {
    if (!_playing.contains(name)) {
      _playing.add(name);
      await FlameAudio.play(name);
      // no way to get the length?
      await Future.delayed(Duration(milliseconds: 100));
      _playing.remove(name);
    }
  }
}
