import 'package:ambient_assistant/widgets/camera_widget.dart';
import 'package:ambient_assistant/widgets/my_floating_action_button.dart';
import 'package:ambient_assistant/widgets/record_utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        // height: double.infinity,
        child: CameraWidget(),
      ),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
