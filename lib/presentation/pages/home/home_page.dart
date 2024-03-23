import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/post/comment/comment_page.dart';

import '../post/update_post_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/messenger.png',
                color: primaryColor,
                height: 22,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          color: secondaryColor, shape: BoxShape.circle),
                    ),
                    sizedBoxHor(size.width * 0.027),
                    const Text(
                      'username and',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _openBottomModelSheet(context);
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            sizedBoxVer(12),
            Container(
              height: size.height * 0.3,
              width: double.infinity,
              color: secondaryColor,
            ),
            sizedBoxVer(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    sizedBoxHor(15),
                    Image.asset(
                      'assets/heart.png',
                      color: secondaryColor,
                      height: 22,
                    ),
                    sizedBoxHor(15),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CommentPage()));
                      },
                      child: Image.asset(
                        'assets/chat.png',
                        color: secondaryColor,
                        height: 20,
                      ),
                    ),
                    sizedBoxHor(15),
                    Image.asset(
                      'assets/send.png',
                      color: secondaryColor,
                      height: 20,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/bookmark.png',
                  color: secondaryColor,
                  height: 20,
                ),
              ],
            ),
            sizedBoxVer(10),
            const Text(
              '1 likes',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    sizedBoxHor(10),
                    const Text(
                      'some description',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                )
              ],
            ),
            sizedBoxVer(10),
            const Text(
              'view all 10 comments',
              style: TextStyle(color: darkGreyColor),
            ),
            sizedBoxVer(10),
            const Text(
              '20/01/2024',
              style: TextStyle(color: darkGreyColor),
            ),
          ],
        ),
      ),
    );
  }

  _openBottomModelSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: backGroundColor,
        context: context,
        builder: (context) {
          backGroundColor;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: backGroundColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: secondaryColor.shade600,
                  endIndent: 173,
                  indent: 173,
                  thickness: 3,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 20),
                  child: Text(
                    'More options',
                    style: TextStyle(color: secondaryColor, fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const EditProfilePage()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Post',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdatePostPage()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update post',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }
}
