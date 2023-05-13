import 'package:ambient_assistant/widgets/floating_action_buttons/my_floating_action_button.dart';
import 'package:flutter/material.dart';

import '../../record_utils.dart';

class RecordAudioFloatingActionButton extends MyFloatingActionButton {
  const RecordAudioFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> getState() {
    return RecordAudioFloatingActionButtonState();
  }
}

class RecordAudioFloatingActionButtonState extends MyFloatingActionButtonState {
  IconData icon = Icons.mic;

  @override
  void onPressed() {
    RecordUtils.isRecording ?
    RecordUtils.stopRecord().then((value) {
      setState(() { icon = Icons.mic; });
    }) :
    RecordUtils.startRecord().then((value) {
      setState(() { icon = Icons.square; });
    });
  }
}

