import 'dart:typed_data';

import 'package:ambient_assistant/camera_utils.dart';
import 'package:ambient_assistant/playback_utils.dart';
import 'package:flutter/material.dart';

import '../../file_provider_utils.dart';
import '../../http_utils.dart';
import '../../record_utils.dart';
import 'my_floating_action_button.dart';

class SendAudioAndPhotoFloatingActionButton extends MyFloatingActionButton {
  const SendAudioAndPhotoFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButton> getState() {
    return SendAudioAndPhotoFloatingActionButtonState();
  }
}

class SendAudioAndPhotoFloatingActionButtonState extends MyFloatingActionButtonState {
  IconData icon = Icons.send_time_extension_outlined;

  void execute() async {
    HttpUtils.deleteChat();
    final label = (await HttpUtils.postFile('image/label',  CameraUtils.filename)) as String;
    final transcript = (await HttpUtils.postFile('speech-to-text', FileProviderUtils.cacheDir + RecordUtils.filename));
    final message = 'I have a $label bag of 140g. $transcript';
    final audioMesssage = (await HttpUtils.generateResponse(message)) as Uint8List;
    PlaybackUtils.playAudio(audioMesssage, null);
}

  @override
  void onPressed() {
    execute();
  }
}