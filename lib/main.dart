import 'package:flutter/material.dart';
import 'package:linkmiup/splashscreen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}