import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/cubit/reel/get_single_reel/get_single_reel_cubit.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../cubit/reel/reel_cubit.dart';
import '../../post/widgets/like_animation_widget.dart';

class SingleReelCardWidget extends StatefulWidget {
  final ReelEntity reel;
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
      playerController = VideoPlayerController.network(widget.reel.reelUrl!);
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
      child: Stack(alignment: Alignment.bottomRight, children: [
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
          top: 430,
          right: 20,
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    _likePost();

                    setState(() {
                      _isLikeAnimating = true;
                    });
                  },
                  child: widget.reel.likes!.contains(_currentUid)
                      ? Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red.shade600,
                          size: 32,
                        )
                      : const Icon(
                          CupertinoIcons.heart,
                          color: Colors.white,
                          size: 32,
                        )),
              sizedBoxVer(3),
              Text(
                "${widget.reel.totalLikes}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              sizedBoxVer(22),
              Image.asset(
                'assets/chat.png',
                color: Colors.white,
                height: 24,
              ),
              sizedBoxVer(3),
              Text(
                "${widget.reel.totalComments}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              sizedBoxVer(22),
              Image.asset(
                'assets/send.png',
                color: Colors.white,
                height: 24,
              ),
              sizedBoxVer(3),
              const Text(
                '0',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
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
          bottom: 100,
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

  _likePost() {
    BlocProvider.of<ReelCubit>(context)
        .likeReels(reel: ReelEntity(reelId: widget.reel.reelId));
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

  _openBottomModelSheet(BuildContext context, ReelEntity reel) {
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
                  // onTap: _deletePost,
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
                    // Navigator.pushNamed(context, PageConst.updatePostPage,
                    //     arguments: post);
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
