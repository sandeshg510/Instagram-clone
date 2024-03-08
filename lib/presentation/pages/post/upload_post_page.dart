import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class UploadPostPage extends StatelessWidget {
  const UploadPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.3), shape: BoxShape.circle),
          child: const Icon(
            Icons.upload,
            size: 40,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
