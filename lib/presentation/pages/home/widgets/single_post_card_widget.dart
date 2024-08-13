import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../../consts.dart';
import '../../../../domain/app_entity.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../cubit/post/post_cubit.dart';
import '../../../widgets/profile_widget.dart';
import '../../post/widgets/like_animation_widget.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.singleUserProfilePage,
                      arguments: widget.post.creatorUid);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: profileWidget(
                            imageUrl: "${widget.post.userProfileUrl}"),
                      ),
                    ),
                    sizedBoxHor(10),
                    Text(
                      "${widget.post.username}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModelSheet(context, widget.post);
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
          sizedBoxVer(10),
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
                SizedBox(
                  width: double.infinity,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
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
          sizedBoxVer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  sizedBoxHor(6),
                  widget.post.likes!.contains(_currentUid)
                      ? GestureDetector(
                          onTap: _likePost,
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            size: 26,
                            color: Colors.red,
                          ))
                      : GestureDetector(
                          onTap: _likePost,
                          child: Icon(
                            CupertinoIcons.heart,
                            size: 26,
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                  sizedBoxHor(15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage,
                          arguments: AppEntity(
                              uid: _currentUid, postId: widget.post.postId));
                    },
                    child: Image.asset(
                      'assets/chat.png',
                      color: Theme.of(context).colorScheme.secondary,
                      height: 20,
                    ),
                  ),
                  sizedBoxHor(15),
                  Image.asset(
                    'assets/send.png',
                    color: Theme.of(context).colorScheme.secondary,
                    height: 20,
                  ),
                ],
              ),
              Image.asset(
                'assets/bookmark.png',
                color: Theme.of(context).colorScheme.secondary,
                height: 20,
              ),
            ],
          ),
          sizedBoxVer(10),
          Text(
            '${widget.post.totalLikes} likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  sizedBoxHor(10),
                  Text(
                    '${widget.post.description}',
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
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context) {
          backGroundColor;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 20),
                  child: Text(
                    'More options',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: _deletePost,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Post',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.updatePostPage,
                        arguments: post);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update post',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
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
