import 'package:flutter/material.dart';
import 'package:gallary/Model/class.dart';

class AlbumVideo1 extends StatefulWidget {
  final List<Files> videos;

  const AlbumVideo1({Key? key, required this.videos}) : super(key: key);

  @override
  State<AlbumVideo1> createState() => _AlbumVideo1State();
}

class _AlbumVideo1State extends State<AlbumVideo1> {
  List<String>? video = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello'),
    );
  }
}
