import 'package:ambient_assistant/widgets/record_utils.dart';
import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  IconData iconData = Icons.camera_alt_outlined;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        RecordUtils.isRecording ? RecordUtils.stopRecord().then((value) {
          setState(() {
            iconData = Icons.camera_alt_outlined;
          });
        }) : RecordUtils.startRecord().then((value) {
          setState(() {
            iconData = Icons.mic;
          });
        });
      },
      shape: const CircleBorder(),
      child: Icon(iconData),
    );
  }
}
