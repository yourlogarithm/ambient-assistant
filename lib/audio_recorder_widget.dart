import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:ambient_assistant/camera_utils.dart';
import 'package:ambient_assistant/file_provider_utils.dart';
import 'package:ambient_assistant/http_utils.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecoderWidget extends StatefulWidget {
  const AudioRecoderWidget({Key? key}) : super(key: key);

  @override
  State<AudioRecoderWidget> createState() => _AudioRecoderWidgetState();
}

class _AudioRecoderWidgetState extends State<AudioRecoderWidget> {
  final FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  Codec _codec = Codec.aacMP4;
  String _extension = '.mp4';
  bool _mRecorderIsInited = false;
  double _mSubscriptionDuration = 0;
  StreamSubscription? _recorderSubscription;
  int pos = 0;
  double dbLevel = 0;
  bool _mPlayerIsInited = false;
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  late String filename;

  @override
  void initState() {
    super.initState();
    init().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopRecorder(_mRecorder);
    cancelRecorderSubscriptions();
    _mRecorder.closeRecorder();
    stopPlayer();
    _mPlayer.closePlayer();
    super.dispose();
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openRecorder();
    if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _extension = '.webm';
      if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
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

    _mRecorderIsInited = true;
  }

  Future<void> init() async {
    await openTheRecorder();
    _recorderSubscription = _mRecorder.onProgress!.listen((e) {
      setState(() {
        pos = e.duration.inMilliseconds;
        if (e.decibels != null) {
          dbLevel = e.decibels as double;
        }
      });
    });
  }

  // Record Audio

  String getFilename() {
    return DateTime.timestamp().toString() + _extension;
  }

  Future<void> record(FlutterSoundRecorder? recorder) async {
    filename = getFilename();
    await recorder!.startRecorder(codec: _codec, toFile: filename);
    setState(() {});
  }

  Future<void> stopRecorder(FlutterSoundRecorder recorder) async {
    await recorder.stopRecorder();
    Uint8List audioFileBytes = await File(FileProviderUtils.cacheDir + filename).readAsBytes();
    Uint8List imageFileBytes = await File(FileProviderUtils.cacheDir + CameraUtils.filename).readAsBytes();
    HttpUtils.postBinaryRequest(audioFileBytes, '/speech-to-text').then((value) => print('Speech-to-text: $value'));
    HttpUtils.postBinaryRequest(imageFileBytes, '/image/label').then((value) => print('Image-label: $value'));
  }

  Future<void> setSubscriptionDuration(double d) async {
      _mSubscriptionDuration = d;
      setState(() {});
      await _mRecorder.setSubscriptionDuration(
        Duration(milliseconds: d.floor()),
    );
  }

  VoidCallback uiRecordAudio(FlutterSoundRecorder? recorder) {
    if (!_mRecorderIsInited) {return () {};}
    return recorder!.isStopped ? () {record(recorder);} : () {
      stopRecorder(recorder).then((value) {
        setState(() {});});

    };
  }

  // Play audio

  void play(String uri) async {
    await _mPlayer.startPlayer(
        fromURI: uri,
        codec: Codec.aacMP4,
        whenFinished: () { setState(() {}); });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(3),
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF0E6),
        border: Border.all(
          color: Colors.indigo,
          width: 3,
        ),
      ),
      child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _mRecorderIsInited ? uiRecordAudio(_mRecorder) : () {},
                  child: Text(_mRecorder.isRecording ? 'Stop' : 'Record'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(_mRecorder.isRecording ? '' : 'Stopped'),
                const SizedBox(
                  width: 20,
                ),
                Text('Pos: $pos  dbLevel: ${((dbLevel * 100.0).floor()) / 100}'),
              ]
            ),
          Text('Player is inited: $_mPlayerIsInited'),
          Text('Player is playing: ${_mPlayer != null ? _mPlayer!.isPlaying : false}'),
          const Text('Subscription Duration:'),
          Slider(
            value: _mSubscriptionDuration,
            min: 0.0,
            max: 2000.0,
            onChanged: setSubscriptionDuration,
            //divisions: 100
          ),
        ]
      ),
    );
  }
}
