import 'package:ambient_assistant/widgets/camera_widget.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/record_audio_floating_action_button.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/send_audio_and_photo_floating_action_button.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/send_audio_floating_action_button.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/shoot_audio_floating_action_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: CameraWidget(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RecordAudioFloatingActionButton(),
          ShootPhotoFloatingActionButton(),
          SendAudioFloatingActionButton(),
          SendAudioAndPhotoFloatingActionButton(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
