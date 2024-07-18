import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUpdating = false;
  File? _image;

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
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: secondaryColor,
            size: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
                onTap: _updateUserProfileData,
                child: const Icon(Icons.check, color: blueColor, size: 32)),
          )
        ],
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: profileWidget(
                        imageUrl: widget.currentUser.profileUrl, image: _image),
                  ),
                ),
              ),
              sizedBoxVer(15),
              Center(
                child: GestureDetector(
                  onTap: selectImage,
                  child: const Text(
                    'Change Profile Photo',
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              sizedBoxVer(30),
              ProfileFormWidget(title: 'Name', controller: _nameController!),
              sizedBoxVer(15),
              ProfileFormWidget(
                  title: 'user name', controller: _usernameController!),
              sizedBoxVer(15),
              ProfileFormWidget(title: 'Bio', controller: _bioController!),
              sizedBoxVer(15),
              ProfileFormWidget(
                  title: 'website', controller: _websiteController!),
              sizedBoxVer(15),
              _isUpdating == true
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

  _updateUserProfileData() {
    if (_image == null) {
      _updateUserProfile('');
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, false, 'profileImages')
          .then(
            (profileUrl) => _updateUserProfile(profileUrl),
          );
    }
  }

  _updateUserProfile(String profileUrl) {
    setState(() {
      _isUpdating = true;
    });

    BlocProvider.of<UserCubit>(context)
        .updateUsers(
          user: UserEntity(
              uid: widget.currentUser.uid,
              name: _nameController!.text,
              username: _usernameController!.text,
              bio: _bioController!.text,
              website: _websiteController!.text,
              profileUrl: profileUrl),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _nameController!.clear();
      _usernameController!.clear();
      _bioController!.clear();
      _websiteController!.clear();
    });
    Navigator.pop(context);
  }
}
