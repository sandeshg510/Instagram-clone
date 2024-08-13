import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/cubit/reel/get_single_reel/get_single_reel_cubit.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../domain/app_entity.dart';
import '../../../cubit/post/post_cubit.dart';
import '../../post/widgets/like_animation_widget.dart';

class SingleReelCardWidgetForHome extends StatefulWidget {
  final PostEntity reel;
  final String reelId;

  const SingleReelCardWidgetForHome(
      {super.key, required this.reel, required this.reelId});

  @override
  State<SingleReelCardWidgetForHome> createState() =>
      _SingleReelCardWidgetForHomeState();
}

class _SingleReelCardWidgetForHomeState
    extends State<SingleReelCardWidgetForHome> {
  VideoPlayerController? playerController;
  bool play = true;
  bool _isLikeAnimating = false;
  String _currentUid = '';

  @override
  void initState() {
    BlocProvider.of<GetSingleReelCubit>(context)
        .getSingleReel(reelId: widget.reelId);
    setState(() {
      di.sl<GetCurrentUidUseCase>().call().then((value) {
        setState(() {
          _currentUid = value;
          print('This is current UID $_currentUid');
        });
      });
      playerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.reel.reelUrl!));
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    playerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    _likePost();
                    setState(() {
                      _isLikeAnimating = true;
                    });
                  },
                  onLongPress: onTap,
                  child: Center(
                    child: SizedBox(
                      height: size.height * 0.8,
                      width: size.width * 1,
                      child: VideoPlayer(playerController!),
                    ),
                  ),
                ),
                if (!play)
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          radius: 35,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: primaryColor,
                            size: 35,
                          ),
                        ),
                        sizedBoxVer(300)
                      ],
                    ),
                  ),
                Positioned(
                  top: 15,
                  left: 15,
                  right: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageConst.singleUserProfilePage,
                              arguments: widget.reel.creatorUid);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: profileWidget(
                                    imageUrl: "${widget.reel.userProfileUrl}"),
                              ),
                            ),
                            sizedBoxHor(10),
                            Text(
                              "${widget.reel.username}",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      widget.reel.creatorUid == _currentUid
                          ? GestureDetector(
                              onTap: () {
                                _openBottomModelSheet(context, widget.reel);
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
                ),
                Positioned(
                  top: 200,
                  right: 143,
                  bottom: 200,
                  child: AnimatedOpacity(
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
                ),
              ],
            ),
            sizedBoxVer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    sizedBoxHor(6),
                    widget.reel.likes!.contains(_currentUid)
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
                                uid: _currentUid, postId: widget.reel.postId));
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
              '${widget.reel.totalLikes} likes',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.reel.username}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    sizedBoxHor(10),
                    Text(
                      '${widget.reel.description}',
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
                        uid: _currentUid, postId: widget.reel.postId));
              },
              child: Text(
                'view all ${widget.reel.totalComments} comments',
                style: const TextStyle(color: darkGreyColor),
              ),
            ),
            sizedBoxVer(10),
            Text(
              DateFormat('dd/MMM/yyy ').format(widget.reel.createAt!.toDate()),
              style: const TextStyle(color: darkGreyColor),
            ),
          ],
        ),
      ),
    );
  }

  onTap() {
    setState(() {
      play = !play;
    });
    if (play) {
      playerController!.play();
    } else {
      playerController!.pause();
    }
  }

  _openBottomModelSheet(BuildContext context, PostEntity reel) {
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
                  onTap: () {
                    _deletePost();
                  },
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 10),
                  child: Text(
                    'Update post',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePosts(post: PostEntity(postId: widget.reel.postId));

    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'Post deleted successfully');
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePosts(post: PostEntity(postId: widget.reel.postId));
  }
}
