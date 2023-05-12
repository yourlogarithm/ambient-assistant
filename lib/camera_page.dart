import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/system_chrome.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        _cameraController.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _cameraController.value.isInitialized ?
          Column(
              children: [
                CameraPreview(_cameraController),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _cameraController.takePicture().then((value) => print(value.path));
                        },
                        icon: const Icon(Icons.camera_alt_outlined)
                    )
                  ],
                ),
              ]
          ) : const Center(child: CircularProgressIndicator())
      )
    );
  }
}
