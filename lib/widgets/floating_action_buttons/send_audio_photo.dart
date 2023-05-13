import 'package:flutter/material.dart';

import '../../http_utils.dart';
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

  @override
  void onPressed() {
    HttpUtils.postFile('image/label',  "");
  }
}