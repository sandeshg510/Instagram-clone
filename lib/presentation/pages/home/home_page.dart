import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/consts.dart';

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
                    sizeBoxHor(size.width * 0.027),
                    const Text(
                      'username',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
                const Icon(
                  Icons.more_vert,
                  color: primaryColor,
                )
              ],
            ),
            sizedBoxVer(12),
            Container(
              height: size.height * 0.3,
              width: double.infinity,
              color: secondaryColor,
            ),
            sizedBoxVer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/heart.png',
                      color: primaryColor,
                      height: 22,
                    ),
                    sizeBoxHor(10),
                    Image.asset(
                      'assets/chat.png',
                      color: primaryColor,
                      height: 20,
                    ),
                    sizeBoxHor(10),
                    Image.asset(
                      'assets/send.png',
                      color: primaryColor,
                      height: 20,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/bookmark.png',
                  color: primaryColor,
                  height: 20,
                ),
              ],
            ),
            sizedBoxVer(10),
            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    sizeBoxHor(10),
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
}
