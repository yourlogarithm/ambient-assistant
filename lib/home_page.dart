import 'package:ambient_assistant/widgets/camera_widget.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/record_audio.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/send_audio_photo.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/send_audio.dart';
import 'package:ambient_assistant/widgets/floating_action_buttons/shoot_photo.dart';
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
