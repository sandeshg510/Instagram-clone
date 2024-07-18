import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/home/home_page.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostMainWidget({super.key, required this.post});

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;
  File? _image;
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
      Fluttertoast.showToast(msg: 'some error occur $e');
    }
  }

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Edit Post',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: _updatePost,
              child: const Icon(
                Icons.done,
                color: blueColor,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizedBoxVer(10),
              Text(
                '${widget.post.username}',
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizedBoxVer(10),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      child: profileWidget(
                        imageUrl: widget.post.postImageUrl,
                        image: _image,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.edit,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              sizedBoxVer(10),
              ProfileFormWidget(
                  title: 'Description', controller: _descriptionController!),
              sizedBoxVer(20),
              _isUploading == true
                  ? Row(
                      children: [
                        const Text(
                          'please wait',
                          style: TextStyle(fontSize: 16),
                        ),
                        sizedBoxHor(10),
                        const CircularProgressIndicator()
                      ],
                    )
                  : sizedBoxVer(10)
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _isUploading = true;
    });
    if (_image == null) {
      _submitUpdatedPost(image: widget.post.postImageUrl!);
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, true, false, 'posts')
          .then((imageUrl) => _submitUpdatedPost(image: imageUrl));
    }
  }

  _submitUpdatedPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .updatePosts(
          post: PostEntity(
            creatorUid: widget.post.creatorUid,
            postId: widget.post.postId,
            postImageUrl: image,
            description: _descriptionController!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _image = null;
      _descriptionController!.clear();
      _isUploading = false;

      Fluttertoast.showToast(msg: 'Post updated successfully');
    });
  }
}
