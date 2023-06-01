import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallary/Screens/AlbumImage2.dart';

class SecondScreen extends StatefulWidget {
  final List<String> images;
  const SecondScreen({Key? key, required this.images}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  String? selectedimage;

  @override
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
              itemCount: widget.images!.length,
              itemBuilder: (context, index) {
                final album = widget.images![index];
                print(album.toString());
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedimage = album;
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdScreen(image: selectedimage)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        ),
                    child: Image.file(File(album),fit: BoxFit.cover)
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
