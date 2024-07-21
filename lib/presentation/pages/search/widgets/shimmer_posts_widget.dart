import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPostsWidget extends StatelessWidget {
  const ShimmerPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemCount: 15,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade400,
            child: Container(
              color: Colors.white70,
              width: 100,
              height: 100,
            ),
          );
        },
      ),
    );
  }
}
