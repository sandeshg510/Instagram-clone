import 'package:flutter/material.dart';

class MuteAnimationWidget extends StatefulWidget {
  const MuteAnimationWidget(
      {super.key,
      required this.child,
      required this.duration,
      required this.isMuteAnimating,
      this.onLikeFinish});
  final Widget child;
  final Duration duration;
  final bool isMuteAnimating;
  final VoidCallback? onLikeFinish;

  @override
  State<MuteAnimationWidget> createState() => _MuteAnimationWidgetState();
}

class _MuteAnimationWidgetState extends State<MuteAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MuteAnimationWidget oldWidget) {
    if (widget.isMuteAnimating != oldWidget.isMuteAnimating) {
      beginLikeAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  beginLikeAnimation() async {
    if (widget.isMuteAnimating) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onLikeFinish != null) {
        widget.onLikeFinish!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
