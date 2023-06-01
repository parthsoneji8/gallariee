import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:gallary/Model/class.dart';
import 'package:gallary/Screens/AlbumImage1.dart';
import 'package:gallary/Screens/AlbumVideo.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<AlbumModel> albums = [];
  int selectedIndex = 0;
  List<VideoFIles> videos = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    getAlbums();
    videoPath();
  }

  Future<void> getAlbums() async {
    final response = await StoragePath.imagesPath;
    final albumsJson = jsonDecode(response!) as List<dynamic>;
    albums = albumsJson.map((album) => AlbumModel.fromJson(album)).toList();
    setState(() {});
  }

  Future<String> videoPath() async {
    String videoPath = '';
    try {
      videoPath = (await StoragePath.videoPath)!;
      final videoJson = jsonDecode(videoPath) as List<dynamic>;
      videos = videoJson
          .map((video) => VideoFIles.fromJson(video))
          .where((video) => video.files![index].path!.endsWith('.mp4'))
          .toList();
      setState(() {});
    } on PlatformException {
      videoPath = "Failed to path Load";
    }
    return videoPath;
  }

  Future<String?> getImage(thumbnail) async {
    final thumb = await VideoThumbnail.thumbnailFile(video: thumbnail);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gallary", style: ThemeData.light().textTheme.labelSmall),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.photo),
                child: Text("Photos File"),
              ),
              Tab(
                icon: Icon(Icons.videocam_sharp),
                child: Text("Photos File"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            albums.isEmpty
                ? const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()))
                : PhotosFiles(),
            videos.isEmpty
                ? const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()))
                : VideosFiles()
          ],
        ),
      ),
    );
  }


  Widget VideosFiles() {
    return Padding(
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
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            if (video != null) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AlbumVideo1(videos: video.files!.map((file) => file.path!).toList());
                    },
                  ));
                },
                child: FutureBuilder<String?>(
                  future: getImage(video.files![0].path),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Hero(
                          tag: video.files![0].path!,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Image.file(File(snapshot.data!),fit: BoxFit.cover)),
                                Text(
                                  video.folderName ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${video.files?.length ?? 0} videos',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
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
                    } else {
                      print("File not found");
                      return Container(); // Add a return statement here
                    }
                  },
                ),
              );
            }
            else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget PhotosFiles() {
    return Padding(
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
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SecondScreen(images: album.files!);
                  },
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: FileImage(File(album.files![0])),
                        fit: BoxFit.cover)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      album.folderName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${album.files?.length ?? 0} images',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
