import 'dart:io';

import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key, required this.image}) : super(key: key);
  final String? image;

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        width: 500,
        decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(25)
        ),
        child: Image.file(File(widget.image!),fit: BoxFit.cover,),
      ),
    );
  }
}
