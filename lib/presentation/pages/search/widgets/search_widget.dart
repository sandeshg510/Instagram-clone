import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
          color: secondaryColor.withOpacity(.3),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: primaryColor),
        decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(color: secondaryColor, fontSize: 15)),
      ),
    );
  }
}
