import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallary/Model/class.dart';
import 'package:gallary/Screens/AlbumVideo2.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AlbumVideo1 extends StatefulWidget {
  final VideoFIles videos;
  final List<String> thumbnails;

  AlbumVideo1({Key? key, required this.videos, required this.thumbnails})
      : super(key: key);

  @override
  State<AlbumVideo1> createState() => _AlbumVideo1State();
}

class _AlbumVideo1State extends State<AlbumVideo1> {
  Map<String, String?> videoThumbnails = {};

  Future<void> loadThumbnails() async {
    for (var video in widget.videos.files!) {
      if (!videoThumbnails.containsKey(video.path!)) {
        final thumbnail =
        await VideoThumbnail.thumbnailFile(video: video.path!);
        setState(() {
          videoThumbnails[video.path!] = thumbnail;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadThumbnails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              itemCount: widget.videos.files!.length,
              itemBuilder: (context, index) {
                final video = widget.videos;
                final videoPath = video.files![index].path!;
                final thumbnail = videoThumbnails[videoPath];

                if (thumbnail != null) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumVideo2(
                            videos: video.files!
                              .map((file) => file.path!)
                            .toList(),
                            thumbnails: widget.thumbnails,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(thumbnail),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.black54,
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              'videos $index',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
