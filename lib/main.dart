import 'package:ambient_assistant/home_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pinkAccent
        ),
        useMaterial3: true,
      ),
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    availableCameras().then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CameraPage(cameras: value)));
    });
    return const Placeholder();
  }
}
