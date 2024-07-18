import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({super.key, required this.currentUser});

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('no image has been selected');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'some error occurred $e');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return child();
  }

  Widget child() {
    if (_image == null) {
      return _uploadPostsWidget();
    }
    if (_image != null) {
      Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: backGroundColor,
          leading: GestureDetector(
              onTap: () {
                setState(() {
                  _image = null;
                });
              },
              child: const Icon(
                Icons.close,
                size: 28,
                color: primaryColor,
              )),
          actions: [
            GestureDetector(
              onTap: _submitPost,
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: profileWidget(
                        imageUrl: '${widget.currentUser.profileUrl}')),
              ),
              sizedBoxVer(10),
              Text(
                '${widget.currentUser.name}',
                style: const TextStyle(color: Colors.white),
              ),
              sizedBoxVer(10),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: profileWidget(image: _image),
              ),
              sizedBoxVer(10),
              ProfileFormWidget(
                  title: 'Description', controller: _descriptionController),
              sizedBoxVer(20),
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
                  : const SizedBox(
                      height: 10,
                      width: 10,
                    )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: GestureDetector(
            onTap: () {
              setState(() {
                _image = null;
              });
            },
            child: const Icon(
              Icons.close,
              size: 28,
              color: primaryColor,
            )),
        actions: [
          GestureDetector(
            onTap: _submitPost,
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Icon(
                Icons.arrow_forward,
                color: primaryColor,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: profileWidget(
                      imageUrl: '${widget.currentUser.profileUrl}')),
            ),
            sizedBoxVer(10),
            Text(
              '${widget.currentUser.username}',
              style: const TextStyle(color: Colors.white),
            ),
            sizedBoxVer(10),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: profileWidget(image: _image),
            ),
            sizedBoxVer(10),
            ProfileFormWidget(
                title: 'Description', controller: _descriptionController),
            sizedBoxVer(20),
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
                : const SizedBox(
                    height: 10,
                    width: 10,
                  )
          ],
        ),
      ),
    );
  }

  _submitPost() {
    {
      setState(() {
        _isUploading = true;
      });
    }
    di
        .sl<UploadImageToStorageUseCase>()
        .call(_image!, true, false, 'posts')
        .then((imageUrl) {
      _createPostToSubmit(image: imageUrl);
    });
  }

  _createPostToSubmit({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPosts(
            post: PostEntity(
          description: _descriptionController.text,
          postId: const Uuid().v1(),
          creatorUid: widget.currentUser.uid,
          username: widget.currentUser.name,
          postImageUrl: image,
          likes: [],
          totalLikes: 0,
          totalComments: 0,
          createAt: Timestamp.now(),
          userProfileUrl: widget.currentUser.profileUrl,
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUploading = false;
      _descriptionController.clear();
      _image = null;
      Fluttertoast.showToast(msg: 'Post uploaded successfully');
    });
  }

  _uploadPostsWidget() {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: selectImage,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.3),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.upload,
                  size: 40,
                  color: primaryColor,
                ),
              ),
            ),
            const Text(
              'Upload a post',
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
