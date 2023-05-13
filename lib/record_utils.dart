import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RecordUtils {
  static final FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  static Codec codec = Codec.aacMP4;
  static String _extension = '.mp4';
  static StreamSubscription? _recorderSubscription;
  static bool isRecorderInited = false;
  static bool isRecording = false;
  static int pos = 0;
  static double dbLevel = 0;
  static late String filename;

  static Future<void> init() async {
    await openTheRecorder();
    _recorderSubscription = _mRecorder.onProgress!.listen((e) {
        pos = e.duration.inMilliseconds;
        if (e.decibels != null) { dbLevel = e.decibels as double; }
    });
    isRecorderInited = true;
  }

  static Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openRecorder();
    if (!await _mRecorder.isEncoderSupported(codec) && kIsWeb) {
      codec = Codec.opusWebM;
      _extension = '.webm';
      if (!await _mRecorder.isEncoderSupported(codec) && kIsWeb) {
        return;
      }
    }

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  static void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  static String getFilename() {
    return DateTime.timestamp().toString() + _extension;
  }

  static Future<String> startRecord() async {
    if (!isRecorderInited) {
      await init();
    }
    filename = getFilename();
    await _mRecorder.startRecorder(codec: codec, toFile: filename);
    isRecording = true;
    return filename;
  }

  static Future<void> stopRecord() async {
    await _mRecorder.stopRecorder();
    isRecording = false;
  }
}