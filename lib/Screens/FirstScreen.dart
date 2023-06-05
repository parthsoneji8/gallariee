import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:gallary/Model/class.dart';
import 'package:gallary/Screens/AlbumImage1.dart';
import 'package:gallary/Screens/AlbumVideo.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as Img;

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
  bool isAlbumsLoaded = false;
  bool isSelected = true;

  @override
  void initState() {
    super.initState();
    if (!isAlbumsLoaded) {
      getAlbums();
    }
    videoPath();
  }

  Future<String?> getAlbums() async {
    if (!isAlbumsLoaded) {
      final response = await StoragePath.imagesPath;
      final albumsJson = jsonDecode(response!) as List<dynamic>;
      albums = albumsJson.map((album) => AlbumModel.fromJson(album)).toList();
      if (albums != null && albums.isNotEmpty) {
        final album = albums[0]; // Assuming you want to use the first album
        final imageFiles = album.files; // Assuming the 'files' property is a list of 'String' paths

        if (imageFiles != null && imageFiles.isNotEmpty) {
          final imagePath = imageFiles[0]; // Assuming 'files' property contains 'String' paths
          final image = Img.decodeImage(File(imagePath).readAsBytesSync());

          if (image != null) {
            final blurHash = BlurHash.encode(image, numCompX: 4, numCompY: 3);
            return blurHash.hash;
          }
        }
      }
    }
    return null;
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
          title: Text("Gallery", style: ThemeData.light().textTheme.labelSmall),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                              : Color(0xFFF5F4F8),
                        ),
                        child: Center(
                            child: Text("Photos",
                                style: ThemeData.light()
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                    color: isSelected
                                        ? Color(0xFF234F68)
                                        : Color(0xFFA1A5C1)))),
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
                              : Color(0xFFF5F4F8),
                        ),
                        child: Center(
                          child: Text(
                            "Videos",
                            style: ThemeData.light()
                                .textTheme
                                .labelLarge!
                                .copyWith(
                              color: !isSelected
                                  ? Color(0xFF234F68)
                                  : Color(0xFFA1A5C1),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              isSelected ? PhotoAlbum() : VideoAlbum(),
            ],
          ),
        ),
      ),
    );
  }

  Widget PhotoAlbum() {
    return albums.isEmpty
        ? const SizedBox(
      height: 50,
      width: 50,
      child: Center(child: CircularProgressIndicator()),
    )
        : Padding(
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
                    fit: BoxFit.cover,
                  ),
                ),
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

  Widget VideoAlbum() {
    return videos.isEmpty
        ? const SizedBox(
      height: 50,
      width: 50,
      child: Center(child: CircularProgressIndicator()),
    )
        : Padding(
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
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumVideo1(videos: video),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: FileImage(File(video.files![index].path!)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      video.folderName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${video.files?.length ?? 0} videos',
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
