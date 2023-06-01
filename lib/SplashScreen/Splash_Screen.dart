import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallary/Screens/FirstScreen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FirstScreen(),)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Splash Screen",style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
