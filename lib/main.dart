import 'package:flutter/material.dart';
import 'package:main/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoCo',
      theme: ThemeData(
        fontFamily: "Lemon",
        primarySwatch: Colors.blueGrey,
      ),
      home: FirstScreen(),
    );
  }
}
