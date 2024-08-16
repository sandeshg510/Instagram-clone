import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:intl/intl.dart';
import '../../../../consts.dart';
import '../../../../domain/app_entity.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../cubit/post/get_single_post/get_single_post_cubit.dart';
import '../../../cubit/post/post_cubit.dart';
import '../../../widgets/profile_widget.dart';
import 'like_animation_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class PostDetailMainWidget extends StatefulWidget {
  const PostDetailMainWidget({super.key, required this.postId});
  final String postId;

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  String _currentUid = '';
  UserEntity? _currentUser;

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId);

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

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.back,
            )),
        title: const Text(
          'Post Detail',
        ),
      ),
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, getSinglePostState) {
          if (getSinglePostState is GetSinglePostLoaded) {
            final singlePost = getSinglePostState.post;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: profileWidget(
                                  imageUrl: singlePost.userProfileUrl),
                            ),
                          ),
                          sizedBoxHor(size.width * 0.027),
                          Text(
                            '${singlePost.username}',
                          ),
                        ],
                      ),
                      singlePost.creatorUid == _currentUid
                          ? GestureDetector(
                              onTap: () {
                                _openBottomModelSheet(context, singlePost);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                // _openBottomModelSheetForOtherUser(context, singlePost);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).colorScheme.primary,
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
                        SizedBox(
                          height: size.height * 0.3,
                          width: double.infinity,
                          child:
                              profileWidget(imageUrl: singlePost.postImageUrl),
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
                                color: AppColors.red,
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
                          singlePost.likes!.contains(_currentUid)
                              ? GestureDetector(
                                  onTap: () {
                                    _likePost();
                                  },
                                  child: const Icon(
                                    CupertinoIcons.heart_fill,
                                    size: 26,
                                    color: Colors.red,
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    _likePost();
                                  },
                                  child: Icon(
                                    CupertinoIcons.heart,
                                    size: 26,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )),
                          sizedBoxHor(15),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.commentPage,
                                  arguments: AppEntity(
                                      uid: _currentUid,
                                      postId: singlePost.postId));
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
                    '${singlePost.totalLikes} likes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${singlePost.username}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          sizedBoxHor(10),
                          Text(
                            '${singlePost.description}',
                          ),
                        ],
                      )
                    ],
                  ),
                  sizedBoxVer(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage,
                          arguments: AppEntity(
                              uid: _currentUid, postId: singlePost.postId));
                    },
                    child: Text(
                      'view all ${singlePost.totalComments} comments',
                      style: const TextStyle(color: darkGreyColor),
                    ),
                  ),
                  sizedBoxVer(10),
                  Text(
                    DateFormat('dd/MMM/yyy ')
                        .format(singlePost.createAt!.toDate()),
                    style: const TextStyle(color: darkGreyColor),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _openBottomModelSheet(BuildContext context, PostEntity post) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context) {
          Theme.of(context).colorScheme.tertiary;
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
                  color: Theme.of(context).colorScheme.secondary,
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
        .deletePosts(post: PostEntity(postId: widget.postId));

    Fluttertoast.showToast(msg: 'Post deleted successfully');
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePosts(post: PostEntity(postId: widget.postId));
  }
}
