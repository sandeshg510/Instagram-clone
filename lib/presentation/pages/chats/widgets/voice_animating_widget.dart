import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class VoiceAnimatingWidget extends StatefulWidget {
  const VoiceAnimatingWidget(
      {super.key, this.deleteCallback, this.sendCallback, this.stopCallback});
  final void Function()? deleteCallback;
  final void Function()? stopCallback;
  final void Function()? sendCallback;

  @override
  State<VoiceAnimatingWidget> createState() => _VoiceAnimatingWidgetState();
}

class _VoiceAnimatingWidgetState extends State<VoiceAnimatingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int currentIndex = 0;
  bool isRecorded = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _controller!.addListener(() {
      if (currentIndex == 6) {
        currentIndex = 0;
      } else {
        currentIndex++;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.all(Radius.circular(22))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 3),
            height: 42,
            width: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(21))),
            child: IconButton(
                onPressed: widget.deleteCallback,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 25,
                  color: secondaryColor,
                )),
          ),
          sizedBoxHor(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(10, (index) {
                  int currentAnimation = (_controller!.value * 10).floor();
                  return AnimatedBuilder(
                      animation: _controller!.view,
                      builder: (context, animation) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.decelerate,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          constraints: BoxConstraints(
                              maxWidth: 4,
                              minHeight: currentAnimation == index ? 40 : 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            color: primaryColor,
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
          sizedBoxHor(30),
          isRecorded
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: widget.sendCallback,
                      icon: const Icon(
                        Icons.arrow_upward_sharp,
                        size: 32,
                        color: primaryColor,
                      )),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 3),
                  height: 42,
                  width: 42,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(21))),
                  child: IconButton(
                      onPressed: () {
                        widget.stopCallback!();
                        setState(() {
                          isRecorded = true;
                        });
                      },
                      icon: const Icon(
                        Icons.stop,
                        size: 25,
                        color: Colors.red,
                      )),
                ),
        ],
      ),
    );
  }
}
