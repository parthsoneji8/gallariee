import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AlbumVideo2 extends StatefulWidget {
  final List<String> videos;
  final int initialIndex;
  const AlbumVideo2({Key? key, required this.videos, required this.initialIndex}) : super(key: key);

  @override
  State<AlbumVideo2> createState() => _AlbumVideo2State();
}

class _AlbumVideo2State extends State<AlbumVideo2> {
  late PageController pageController;
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
    videoPlayerController = VideoPlayerController.file(File(widget.videos[widget.initialIndex]));
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
  }
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final videoPath = widget.videos[index];
          return FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
        onPageChanged: (index) {
          setState(() {
            videoPlayerController.pause();
            videoPlayerController = VideoPlayerController.file(File(widget.videos[index]));
            _initializeVideoPlayerFuture = videoPlayerController.initialize();
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (videoPlayerController.value.isPlaying) {
              videoPlayerController.pause();
            } else {
              videoPlayerController.play();
            }
          });
        },
        child: Icon(videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
