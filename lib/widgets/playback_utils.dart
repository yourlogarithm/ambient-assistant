import 'dart:ui';

import 'package:ambient_assistant/widgets/record_utils.dart';
import 'package:flutter_sound/flutter_sound.dart';

class PlaybackUtils {
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool isPlayerInitialized = false;
  bool isPlaying = false;

  void playAudio(String uri, VoidCallback? whenFinished) async {
    await _mPlayer.startPlayer(
        fromURI: uri,
        codec: RecordUtils.codec,
        whenFinished: whenFinished ?? () {}
    );
  }

  Future<void> stopAudio() async {
    await _mPlayer.stopPlayer();
  }
}