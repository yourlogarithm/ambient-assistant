import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraUtils {
  static late CameraController cameraController;
  static late String filename;

  static Future<void> takePhoto() async {
    try {
      final file = await cameraController.takePicture();
      filename = file.path;
      debugPrint(filename);
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}