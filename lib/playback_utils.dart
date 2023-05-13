import 'dart:typed_data';
import 'dart:ui';

import 'package:ambient_assistant/record_utils.dart';
import 'package:flutter_sound/flutter_sound.dart';

class PlaybackUtils {
  static final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  static bool isPlayerInitialized = false;
  static bool isPlaying = false;

  static void playAudio(Uint8List bytes, VoidCallback? whenFinished) async {
    await _mPlayer.startPlayer(
        fromDataBuffer: bytes,
        codec: RecordUtils.codec,
        whenFinished: whenFinished ?? () {}
    );
  }

  static Future<void> stopAudio() async {
    await _mPlayer.stopPlayer();
  }
}