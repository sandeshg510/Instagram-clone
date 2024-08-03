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
          color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 15)),
      ),
    );
  }
}
