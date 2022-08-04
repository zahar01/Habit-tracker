import 'package:flutter/material.dart';
import 'package:myapp/pages/habitTracker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "Flutter App";

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: habitTracker(),
    );
  }
}


