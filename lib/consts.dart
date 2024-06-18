import 'package:flutter/material.dart';

const backGroundColor = Color.fromRGBO(0, 0, 0, 1.0);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1);

Widget sizedBoxVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizedBoxHor(double width) {
  return SizedBox(width: width);
}

class PageConst {
  static const String editProfilePage = 'editProfilePage';
  static const String updatePostPage = 'updatePostPage';
  static const String commentPage = 'commentPage';
  static const String loginPage = 'loginPage';
  static const String signUpPage = 'signUpPage';
  static const String updateCommentPage = 'updateCommentPage';
  static const String updateReplyPage = 'updateReplyPage';
  static const String postDetailPage = 'postDetailPage';
  static const String singleUserProfilePage = 'singleUserProfilePage';
  static const String followingPage = 'followingPage';
  static const String followersPage = 'followersPage';
}

class FirebaseConst {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String comments = 'comments';
  static const String replies = 'replies';
  static const String reply = 'reply';
}
