import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget(
      {super.key, required this.title, required this.controller});
  final String title;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: primaryColor, fontSize: 16),
        ),
        // sizedBoxVer(10),
        TextFormField(
          style: const TextStyle(color: secondaryColor),
          controller: controller,
          decoration:
              const InputDecoration(labelStyle: TextStyle(color: primaryColor)),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: secondaryColor,
        )
      ],
    );
  }
}
