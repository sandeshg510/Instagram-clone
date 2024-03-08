import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/widgets/form_container_widget.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: secondaryColor),
                ),
                sizedBoxHor(10),
                const Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          sizedBoxVer(10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'it is really beautiful',
              style: TextStyle(
                  fontSize: 15,
                  color: primaryColor,
                  fontWeight: FontWeight.normal),
            ),
          ),
          sizedBoxVer(10),
          const Divider(
            color: secondaryColor,
          ),
          sizedBoxVer(15),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: secondaryColor),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      sizedBoxVer(5),
                      const Text(
                        'Hi',
                        style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                      sizedBoxVer(5),
                      Row(
                        children: [
                          const Text(
                            '04/Jan/2024',
                            style: TextStyle(
                                fontSize: 14,
                                color: secondaryColor,
                                fontWeight: FontWeight.normal),
                          ),
                          sizedBoxHor(25),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserReplying = !_isUserReplying;
                              });
                            },
                            child: const Text(
                              'Reply',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          sizedBoxHor(25),
                          const Text(
                            'View Replies',
                            style: TextStyle(
                                fontSize: 13,
                                color: secondaryColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      _isUserReplying == true
                          ? sizedBoxVer(10)
                          : sizedBoxVer(0),
                      _isUserReplying == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const FormContainerWidget(
                                  hintText: 'Post your reply...',
                                  width: 290,
                                ),
                                sizedBoxVer(10),
                                const Text(
                                  'Post',
                                  style: TextStyle(color: blueColor),
                                )
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                  Image.asset(
                    'assets/heart.png',
                    color: secondaryColor,
                    height: 18,
                  ),
                  sizedBoxHor(4),
                ]),
          )),
          _commentSection()
        ],
      ),
    );
  }

  _commentSection() {
    return Container(
      width: double.infinity,
      height: 60,
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: secondaryColor),
            ),
            sizedBoxHor(10),
            Expanded(
              child: TextFormField(
                style: const TextStyle(color: primaryColor),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Post your comment...',
                    hintStyle: TextStyle(color: secondaryColor)),
              ),
            ),
            const Text(
              'Post',
              style: TextStyle(color: blueColor),
            )
          ],
        ),
      ),
    );
  }
}
