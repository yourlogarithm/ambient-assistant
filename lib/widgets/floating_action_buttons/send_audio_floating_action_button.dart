import 'package:ambient_assistant/file_provider_utils.dart';
import 'package:ambient_assistant/http_utils.dart';
import 'package:ambient_assistant/record_utils.dart';
import 'package:flutter/material.dart';

import 'my_floating_action_button.dart';

class SendAudioFloatingActionButton extends MyFloatingActionButton {
  const SendAudioFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButton> getState() {
    return SendAudioFloatingActionButtonState();
  }
}

class SendAudioFloatingActionButtonState extends MyFloatingActionButtonState {
  IconData icon = Icons.send;

  @override
  void onPressed() {
    HttpUtils.postFile('speech-to-text', FileProviderUtils.cacheDir + RecordUtils.filename);
  }
}