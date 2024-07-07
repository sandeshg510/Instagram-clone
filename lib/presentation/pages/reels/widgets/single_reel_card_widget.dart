import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../cubit/reel/reel_cubit.dart';
import '../../post/widgets/like_animation_widget.dart';

class SingleReelCardWidget extends StatefulWidget {
  final ReelEntity reel;
  const SingleReelCardWidget({super.key, required this.reel});

  @override
  State<SingleReelCardWidget> createState() => _SingleReelCardWidgetState();
}

class _SingleReelCardWidgetState extends State<SingleReelCardWidget> {
  VideoPlayerController? playerController;
  bool play = true;
  bool _isLikeAnimating = false;

  @override
  void initState() {
    setState(() {
      playerController = VideoPlayerController.network(widget.reel.reelUrl!);
    });
    playerController!.initialize();
    // playerController!.play();
    playerController!.setVolume(2);
    // playerController!.setLooping(true);

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
              width: size.width * 0.99,
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
                onDoubleTap: () {
                  _likePost();

                  setState(() {
                    _isLikeAnimating = true;
                  });
                },
                child: const Icon(
                  CupertinoIcons.heart,
                  color: Colors.white,
                  size: 32,
                ),
              ),
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
              const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 28,
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
}
