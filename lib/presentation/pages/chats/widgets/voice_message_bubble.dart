import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class VoiceMessageBubble extends StatefulWidget {
  const VoiceMessageBubble({super.key, required this.url, required this.isMe});

  final String url;
  final bool isMe;

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble>
    with TickerProviderStateMixin {
  late AnimationController controller;
  AudioPlayer? player;
  bool isPlayerPlaying = false;

  @override
  void initState() {
    player = AudioPlayer();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    player!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: 60,
      width: size.width * 0.7,
      child: Container(
        height: 50,
        margin: widget.isMe
            ? const EdgeInsets.only(left: 100, bottom: 5, right: 5, top: 5)
            : const EdgeInsets.only(left: 5, bottom: 5, right: 100, top: 5),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: blueColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isPlayerPlaying == false
                ? IconButton(
                    onPressed: () {
                      _playAudio();
                      setState(() {
                        isPlayerPlaying = !isPlayerPlaying;
                      });
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: primaryColor,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      _stopPlaying();
                    },
                    icon: const Icon(
                      Icons.pause,
                      size: 32,
                      color: primaryColor,
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LinearProgressIndicator(
                  // color: primaryColor,
                  value: isPlayerPlaying ? controller!.value : 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _playAudio() async {
    await player!.play(UrlSource(widget.url));
    setState(() {
      isPlayerPlaying = true;
    });
    print('audio is playing');
  }

  _stopPlaying() async {
    await player!.stop();
    setState(() {
      isPlayerPlaying = false;
    });
    print('audio is stopped');
  }
}
