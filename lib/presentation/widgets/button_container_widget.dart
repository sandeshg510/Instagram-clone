import 'package:flutter/material.dart';
import '../../../consts.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? color;
  final String title;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget(
      {super.key, this.color, required this.title, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
