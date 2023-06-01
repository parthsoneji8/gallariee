import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AlbumVideo2 extends StatefulWidget {
  final String Videos;
  const AlbumVideo2({Key? key, required this.Videos}) : super(key: key);

  @override
  State<AlbumVideo2> createState() => _AlbumVideo2State();
}

class _AlbumVideo2State extends State<AlbumVideo2> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:  Text(
        widget.Videos + "videos" ,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),),
    );
  }
}
