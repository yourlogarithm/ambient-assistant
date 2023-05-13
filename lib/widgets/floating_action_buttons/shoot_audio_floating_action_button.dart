import 'package:flutter/material.dart';

import 'my_floating_action_button.dart';

class ShootPhotoFloatingActionButton extends MyFloatingActionButton {
  const ShootPhotoFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButton> getState() {
    return ShootPhotoFloatingActionButtonState();
  }
}

class ShootPhotoFloatingActionButtonState extends MyFloatingActionButtonState {
  IconData icon = Icons.camera_alt;

  @override
  void onPressed() {
  }
}