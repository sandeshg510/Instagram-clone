import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:video_player/video_player.dart';

class SingleReelCardWidget extends StatefulWidget {
  final ReelEntity reel;
  const SingleReelCardWidget({super.key, required this.reel});

  @override
  State<SingleReelCardWidget> createState() => _SingleReelCardWidgetState();
}

class _SingleReelCardWidgetState extends State<SingleReelCardWidget> {
  VideoPlayerController? playerController;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController();
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

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.9,
            width: size.width * 0.99,
            child: VideoPlayer(playerController!),
          ),
          sizedBoxVer(30)
        ],
      ),
    );
  }
}
