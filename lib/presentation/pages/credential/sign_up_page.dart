import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/presentation/pages/main_screen/main_page.dart';
import 'package:instagram_clone/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/presentation/widgets/form_container_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom;
    // SchedulerBinding.instance.addPostFrameCallback((rerun) {
    // });
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
          print('Listener is performed');
          setState(() {});
        }
        if (credentialState is CredentialFailure) {
          Fluttertoast.showToast(msg: 'Invalid email or password');
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          print('inside credential');

          return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
            if (authState is Authenticated) {
              return MainPage(uid: authState.uid);
            } else {
              return _bodyWidget();
            }
          });
        }
        return _bodyWidget();
      },
    );
  }

  _bodyWidget() {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Flexible(flex: 1, child: Container()),
            Center(
              child: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            sizedBoxVer(18),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: profileWidget(image: _image),
                      )),
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: IconButton(
                      color: blueColor,
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo_rounded),
                    ),
                  ),
                ],
              ),
            ),
            sizedBoxVer(35),
            FormContainerWidget(
              hintText: 'Enter your Username',
              controller: _usernameController,
            ),
            sizedBoxVer(15),
            FormContainerWidget(
              hintText: 'Enter your Email',
              controller: _emailController,
            ),
            sizedBoxVer(15),
            FormContainerWidget(
              hintText: 'Enter your Password',
              isPasswordField: true,
              controller: _passwordController,
            ),
            sizedBoxVer(15),
            FormContainerWidget(
              hintText: 'Enter your Bio',
              controller: _bioController,
            ),
            sizedBoxVer(15),
            ButtonContainerWidget(
              color: blueColor,
              title: 'Sign Up',
              onTapListener: () {
                _signUpUser();
              },
            ),
            sizedBoxVer(10),
            _isSigningUp == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Please wait',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      sizedBoxHor(10),
                      const CircularProgressIndicator()
                    ],
                  )
                : const SizedBox(width: 0, height: 0),
            Container(),
            Flexible(flex: 1, child: Container()),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConst.loginPage, (route) => false);
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: blueColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signUpUser() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              bio: _bioController.text.trim(),
              password: _passwordController.text.trim(),
              totalPosts: 0,
              totalFollowing: 0,
              totalFollowers: 0,
              followers: [],
              profileUrl: '',
              website: '',
              following: [],
              name: '',
              imageFile: _image),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      _isSigningUp = false;
      print('clear');
    });
  }
}
