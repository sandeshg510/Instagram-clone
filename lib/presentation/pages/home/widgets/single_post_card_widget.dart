import 'package:flutter/material.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';

import '../../../../consts.dart';

class SinglePostCardWidget extends StatelessWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Padding(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: profileWidget(imageUrl: post.userProfileUrl),
                    ),
                  ),
                  sizedBoxHor(size.width * 0.027),
                  Text(
                    '${post.username}',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _openBottomModelSheet(context, post);
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
            child: profileWidget(imageUrl: post.postImageUrl),
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
                      Navigator.pushNamed(context, PageConst.commentPage);
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
          Text(
            '${post.totalLikes} likes',
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '${post.username}',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizedBoxHor(10),
                  Text(
                    '${post.description}',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              )
            ],
          ),
          sizedBoxVer(10),
          Text(
            'view all ${post.totalComments} comments',
            style: const TextStyle(color: darkGreyColor),
          ),
          sizedBoxVer(10),
          Text(
            DateFormat('dd/MMM/yyy ').format(post.createAt!.toDate()),
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }

  _openBottomModelSheet(BuildContext context, PostEntity post) {
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
                  onTap: () {},
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
                    Navigator.pushNamed(context, PageConst.updatePostPage,
                        arguments: post);
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
