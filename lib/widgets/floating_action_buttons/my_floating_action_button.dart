import 'package:flutter/material.dart';

abstract class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  State<MyFloatingActionButton> getState();

  @override
  State<MyFloatingActionButton> createState() => getState();
}

abstract class MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  late IconData icon;

  void onPressed();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      child: Icon(icon),
    );
  }
}
