import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class ProfileOptionButton extends StatelessWidget {
  const ProfileOptionButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 178,
      decoration: BoxDecoration(
        color: darkGreyColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
          child: Text(
        title,
        style:
            const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      )),
    );
  }
}
