import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _cameraController;

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  final loadingIndicator = const Center(
    child: CircularProgressIndicator()
  );

  Widget cameraPreview() {
    return CameraPreview(_cameraController);
  }

  @override
  Widget build(BuildContext context) {
    return _cameraController.value.isInitialized ? cameraPreview() : loadingIndicator;
  }
}
