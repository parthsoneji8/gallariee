//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:gallary/Model/class.dart';
import 'package:gallary/Screens/AlbumImage1.dart';
import 'package:gallary/Screens/AlbumVideo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<AlbumModel> albums;
  int selectedIndex = 0;
  List<VideoFIles> videos;
  int index = 0;
  bool isSelected = true;
  List<String> preloadedThumbnails = [];
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      getAlbums();
      videoPath();
      getImage(preloadedThumbnails);
    } else {
      return Text("Get A Permission");
    }
  }

  Future<void> getAlbums() async {
    String response = await StoragePath.imagesPath;
    List<dynamic> albumsJson = jsonDecode(response);
    setState(() {
      albums = albumsJson.map((album) => AlbumModel.fromJson(album)).toList();
    });
  }


  Future<String> videoPath() async {
    String videoPath = '';
    try {
      videoPath = (await StoragePath.videoPath);
      final videoJson = jsonDecode(videoPath) as List<dynamic>;
      videos = videoJson
          .map((video) => VideoFIles.fromJson(video))
          .where((video) => video.files[index].path.endsWith('.mp4'))
          .toList();
      setState(() {});
    } on PlatformException {
      videoPath = "Failed to path Load";
    }
    setState(() {

    });
    return videoPath;
  }

  Future<String> getImage(thumbnail) {
    final thumb = VideoThumbnail.thumbnailFile(video: thumbnail);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallary", style: ThemeData.light().textTheme.labelSmall),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = true;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: isSelected
                            ? Colors.blue.shade100
                            : const Color(0xFFF5F4F8),
                      ),
                      child: Center(
                          child: Text("Photos",
                              style: ThemeData.light()
                                  .textTheme
                                  .labelLarge
                                  .copyWith(
                                      color: isSelected
                                          ? const Color(0xFF234F68)
                                          : const Color(0xFFA1A5C1)))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = false;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: !isSelected
                            ? Colors.blue.shade100
                            : const Color(0xFFF5F4F8),
                      ),
                      child: Center(
                        child: Text(
                          "Videos",
                          style:
                              ThemeData.light().textTheme.labelLarge.copyWith(
                                    color: !isSelected
                                        ? const Color(0xFF234F68)
                                        : const Color(0xFFA1A5C1),
                                  ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            isSelected == true ? PhotoAlbum() : VideosFiles()
          ],
        ),
      ),
    );
  }

  Widget PhotoAlbum() {
    return Expanded(
        child: albums == null || albums.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  itemCount: albums.length,
                  itemBuilder: (BuildContext context, int index) {
                    final album = albums[index]; // Retrieve the current album
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SecondScreen(images: album.files);
                          },
                        ));
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
                                  File(album.files[0]),
                                  // Use the correct index to access files
                                  fit: BoxFit.cover,
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
                                album.folderName,
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
                  },
                ),
              ));
  }
  Widget VideosFiles() {
    List<Widget> validWidgets = [];

    for (int index = 0; index < videos.length; index++) {
      final video = videos[index];
      if (video.files != null && video.files.isNotEmpty) {
        int thumbnailIndex = -1;
        for (int i = 0; i < video.files.length; i++) {
          if (video.files[i].path != null && video.files[i].path != null) {
            thumbnailIndex = i;
            break;
          }
        }

        if (thumbnailIndex != -1) {
          final videoPath = video.files[thumbnailIndex].path;

          validWidgets.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumVideo1(
                      videos: video, thumbnails: preloadedThumbnails,
                    ),
                  ),
                );
              },
              child: FutureBuilder<String>(
                future: getImage(videoPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      preloadedThumbnails.add(snapshot.data);
                      return Hero(
                        tag: videoPath,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                        File(snapshot.data),
                                        fit: BoxFit.fill)),
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
                                  video.folderName,
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
                    }
                  }
                  return Container();
                },
              ),
            ),
          );
        }
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Visibility(
            visible: videos == null || videos.isEmpty,
            // Show progress indicator if videos list is null or empty
            child: Center(
              child: CircularProgressIndicator(),
            ),
            replacement: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: validWidgets,
            ),
          ),
        ),
      ),
    );
  }
}



