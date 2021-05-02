import 'dart:math';

import 'package:flutter/material.dart';
import 'package:main/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<String> cautions = [
    "Maintain at least 6-feet social distance.",
    "Avoid touching your eyes, nose and mouth.",
    "Wear a mask or two!",
  ];
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
      gradientBackground: RadialGradient(
        colors: [Colors.blueGrey, Colors.blueGrey[800]],
      ),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 110,
      image: Image.asset("assets/images/COVID.png"),
      title: Text(
        cautions[Random().nextInt(cautions.length)],
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15, color: Colors.white60),
      ),
    );
  }
}
