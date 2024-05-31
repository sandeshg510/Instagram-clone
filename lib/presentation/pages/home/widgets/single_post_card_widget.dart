import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/domain/app_entity.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/post/widgets/like_animation_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../../consts.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = '';

  @override
  void initState() {
    setState(() {
      di.sl<GetCurrentUidUseCase>().call().then((value) {
        setState(() {
          _currentUid = value;
        });
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;

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
                      child:
                          profileWidget(imageUrl: widget.post.userProfileUrl),
                    ),
                  ),
                  sizedBoxHor(size.width * 0.027),
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _openBottomModelSheet(context, widget.post);
                },
                child: const Icon(
                  Icons.more_vert,
                  color: primaryColor,
                ),
              )
            ],
          ),
          sizedBoxVer(12),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: size.height * 0.3,
                  width: double.infinity,
                  child: profileWidget(imageUrl: widget.post.postImageUrl),
                ),
                AnimatedOpacity(
                  opacity: _isLikeAnimating ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: LikeAnimationWidget(
                      duration: const Duration(milliseconds: 300),
                      isLikeAnimating: _isLikeAnimating,
                      onLikeFinish: () {
                        setState(() {
                          _isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.suit_heart_fill,
                        size: 100,
                        color: primaryColor,
                      )),
                ),
              ],
            ),
          ),
          sizedBoxVer(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  sizedBoxHor(5),
                  widget.post.likes!.contains(_currentUid)
                      ? GestureDetector(
                          onTap: _likePost,
                          child: Image.asset(
                            'assets/red-heart-11121.png',
                            height: 22,
                          ),
                        )
                      : GestureDetector(
                          onTap: _likePost,
                          child: Image.asset(
                            'assets/heart.png',
                            color: secondaryColor,
                            height: 22,
                          ),
                        ),
                  sizedBoxHor(15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage,
                          arguments: AppEntity(
                              uid: _currentUid, postId: widget.post.postId));
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
            '${widget.post.totalLikes} likes',
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizedBoxHor(10),
                  Text(
                    '${widget.post.description}',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              )
            ],
          ),
          sizedBoxVer(10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.commentPage,
                  arguments:
                      AppEntity(uid: _currentUid, postId: widget.post.postId));
            },
            child: Text(
              'view all ${widget.post.totalComments} comments',
              style: const TextStyle(color: darkGreyColor),
            ),
          ),
          sizedBoxVer(10),
          Text(
            DateFormat('dd/MMM/yyy ').format(widget.post.createAt!.toDate()),
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
                  onTap: _deletePost,
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

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePosts(post: PostEntity(postId: widget.post.postId));

    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'Post deleted successfully');
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePosts(post: PostEntity(postId: widget.post.postId));
  }
}
