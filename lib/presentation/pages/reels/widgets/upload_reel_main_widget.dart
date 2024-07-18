import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:video_compress/video_compress.dart';

import 'video_upload_form_widget.dart';

class UploadReelMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadReelMainWidget({super.key, required this.currentUser});

  @override
  State<UploadReelMainWidget> createState() => _UploadReelMainWidgetState();
}

class _UploadReelMainWidgetState extends State<UploadReelMainWidget> {
  File? _videoFile;
  String? _videoPath;
  @override
  Widget build(BuildContext context) {
    return _videoFile == null
        ? _uploadReelWidget()
        : VideoUploadFormWidget(
            videoFile: _videoFile!,
            videoPath: _videoPath!,
            currentUser: widget.currentUser);
  }

  _uploadReelWidget() {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: GestureDetector(
        onTap: () {
          getVideoFile();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/reels_logo.png',
                  color: Colors.white60,
                ),
              ),
              sizedBoxVer(20),
              Container(
                height: 50,
                width: 150,
                decoration: const BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: const Text(
                  'Upload reel',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getVideoFile() async {
    try {
      final pickedVideoFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      // final thumbnail = await getThumbnailImage(_videoPath!);

      setState(() {
        if (pickedVideoFile != null) {
          _videoFile = File(pickedVideoFile.path);
          _videoPath = pickedVideoFile.path;
        } else {
          Fluttertoast.showToast(msg: 'no image has been selected');
        }
      });

      // return thumbnail;
    } catch (e) {
      Fluttertoast.showToast(msg: 'some error occurred $e');
    }
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);

    return thumbnailImage;
  }
}
