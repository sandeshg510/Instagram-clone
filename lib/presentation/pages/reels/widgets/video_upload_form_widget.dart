import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_reel_to_storage_usecase.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/reel/reel_cubit.dart';
import 'package:instagram_clone/presentation/widgets/button_container_widget.dart';
import 'dart:io';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../../domain/entities/user/user_entity.dart';
import '../../profile/widgets/profile_form_widget.dart';

class VideoUploadFormWidget extends StatefulWidget {
  final File videoFile;
  //videoFile: File(videoFile.path),
  final String videoPath;
  // videoPath: videoFile.path,
  final UserEntity currentUser;

  const VideoUploadFormWidget(
      {super.key,
      required this.videoFile,
      required this.videoPath,
      required this.currentUser});

  @override
  State<VideoUploadFormWidget> createState() => _VideoUploadFormWidgetState();
}

class _VideoUploadFormWidgetState extends State<VideoUploadFormWidget> {
  VideoPlayerController? playerController;
  TextEditingController? _descriptionController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    _descriptionController = TextEditingController();
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
  }

  @override
  void dispose() {
    playerController!.dispose();
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.3,
              width: size.width,
              child: VideoPlayer(playerController!),
            ),
            sizedBoxVer(30),
            Column(
              children: [
                _isUploading == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Uploading...',
                            style: TextStyle(color: primaryColor),
                          ),
                          sizedBoxHor(10),
                          const CircularProgressIndicator()
                        ],
                      )
                    : Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        width: size.width * 0.8,
                        child: ProfileFormWidget(
                          controller: _descriptionController!,
                          title: 'Description',
                        ),
                      ),
                sizedBoxVer(10),
                SizedBox(
                    width: size.width * 0.8,
                    child: ButtonContainerWidget(
                      onTapListener: () {
                        _submitVideo();
                      },
                      title: 'Upload Now',
                      color: blueColor,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _submitVideo() {
    {
      setState(() {
        _isUploading = true;
      });
    }
    if (_descriptionController!.text.isNotEmpty) {
      di
          .sl<UploadReelToStorageUseCase>()
          .call(
              context: context,
              descriptionText: _descriptionController!.text,
              videoFilePath: widget.videoPath)
          .then((reelUrl) {
        _createReelToSubmit(reelUrl: reelUrl, videoFilePath: widget.videoPath);
      }).then((value) => _clear());
    }
  }

  _createReelToSubmit(
      {required String reelUrl, required String videoFilePath}) {
    BlocProvider.of<ReelCubit>(context)
        .createThumbnails(videoFilePath: widget.videoPath)
        .then((thumbnailUrl) {
      // BlocProvider.of<ReelCubit>(context).createReels(
      //     reel: ReelEntity(
      //   description: _descriptionController!.text,
      //   reelId: const Uuid().v1(),
      //   creatorUid: widget.currentUser.uid,
      //   username: widget.currentUser.username,
      //   reelUrl: reelUrl,
      //   thumbnailUrl: thumbnailUrl,
      //   likes: const [],
      //   totalLikes: 0,
      //   totalComments: 0,
      //   createAt: Timestamp.now(),
      //   userProfileUrl: widget.currentUser.profileUrl,
      // ));

      BlocProvider.of<PostCubit>(context).createPosts(
          post: PostEntity(
        description: _descriptionController!.text,
        postId: const Uuid().v1(),
        creatorUid: widget.currentUser.uid,
        username: widget.currentUser.username,
        reelUrl: reelUrl,
        thumbnailUrl: thumbnailUrl,
        likes: const [],
        totalLikes: 0,
        totalComments: 0,
        createAt: Timestamp.now(),
        userProfileUrl: widget.currentUser.profileUrl,
        postType: FirebaseConst.reels,
      ));
    }).whenComplete(() => _clear());
  }

  _clear() {
    Fluttertoast.showToast(msg: 'Post uploaded successfully');
    setState(() {
      _isUploading = false;
    });
  }
}
