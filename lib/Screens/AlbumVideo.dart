import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallary/Screens/AlbumVideo2.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AlbumVideo1 extends StatefulWidget {
  final List<String> videos;

  AlbumVideo1({Key? key, required this.videos}) : super(key: key);

  @override
  State<AlbumVideo1> createState() => _AlbumVideo1State();
}

class _AlbumVideo1State extends State<AlbumVideo1> {
  List<String> videoThumbnails = [];

  Future<void> loadThumbnails() async {
    for (var video in widget.videos) {
      final thumbnail = await VideoThumbnail.thumbnailFile(video: video);
      setState(() {
        videoThumbnails.add(thumbnail!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadThumbnails();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: widget.videos.length,
                itemBuilder: (context, index) {
                  final video = widget.videos[index];
                  final thumbnail = videoThumbnails[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumVideo2(Videos: video),));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Expanded(child: Image.file(File(thumbnail), fit: BoxFit.cover)),
                          Text(
                            'Video $index',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
    );
  }
}
