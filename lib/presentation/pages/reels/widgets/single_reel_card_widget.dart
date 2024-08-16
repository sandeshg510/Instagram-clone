import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../domain/app_entity.dart';
import '../../../cubit/post/post_cubit.dart';
import '../../post/widgets/like_animation_widget.dart';

class SingleReelCardWidget extends StatefulWidget {
  final PostEntity reel;
  final String reelId;

  const SingleReelCardWidget(
      {super.key, required this.reel, required this.reelId});

  @override
  State<SingleReelCardWidget> createState() => _SingleReelCardWidgetState();
}

class _SingleReelCardWidgetState extends State<SingleReelCardWidget> {
  VideoPlayerController? playerController;
  bool play = true;
  bool _isLikeAnimating = false;
  bool _isLiked = false;
  String _currentUid = '';

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.reelId);
    setState(() {
      di.sl<GetCurrentUidUseCase>().call().then((value) {
        setState(() {
          _currentUid = value;
          print('This is current UID $_currentUid');
        });
        widget.reel.likes!.contains(_currentUid)
            ? _isLiked = true
            : _isLiked = false;
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
    double height = size.height;
    double width = size.width;

    return SafeArea(
      child: Stack(alignment: Alignment.bottomRight, children: [
        GestureDetector(
          onDoubleTap: () {
            _likePost();
            setState(() {
              _isLiked = !_isLiked;
              _isLikeAnimating = true;
            });
          },
          onLongPress: onTap,
          child: Center(
            child: SizedBox(
              height: size.height * 0.9,
              width: size.width * 1,
              child: VideoPlayer(playerController!),
            ),
          ),
        ),
        if (!play)
          const Center(
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 35,
              child: Icon(
                Icons.play_arrow_rounded,
                color: primaryColor,
                size: 35,
              ),
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
        Positioned(
          top: height * 0.6,
          right: width * 0.05,
          child: Column(
            children: [
              _isLiked
                  ? GestureDetector(
                      onTap: () {
                        _likePost();
                        setState(() {
                          _isLiked = false;
                        });
                      },
                      child: const Icon(CupertinoIcons.heart_fill,
                          color: AppColors.red, size: 28))
                  : GestureDetector(
                      onTap: () {
                        _likePost();
                        setState(() {
                          _isLiked = true;
                        });
                      },
                      child: const Icon(CupertinoIcons.heart, size: 28)),
              sizedBoxVer(22),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.commentPage,
                      arguments: AppEntity(
                          uid: _currentUid, postId: widget.reel.postId));
                },
                child: Image.asset(
                  'assets/chat.png',
                  color: Colors.white,
                  height: 20,
                ),
              ),
              sizedBoxVer(22),
              Image.asset(
                'assets/send.png',
                color: Colors.white,
                height: 20,
              ),
              sizedBoxVer(3),
              sizedBoxVer(22),
              _currentUid == widget.reel.creatorUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModelSheet(context, widget.reel);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          bottom: 70,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: profileWidget(
                          imageUrl: "${widget.reel.userProfileUrl}"),
                    ),
                  ),
                  sizedBoxHor(10),
                  Text(
                    "${widget.reel.username}",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizedBoxHor(15),
                  Container(
                    height: 25,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      'Follow',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                ],
              ),
              sizedBoxVer(10),
              Text(
                "${widget.reel.description}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ]),
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
                    setState(() {});
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
