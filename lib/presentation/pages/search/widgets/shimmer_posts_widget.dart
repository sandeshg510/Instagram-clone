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
            baseColor: Colors.white12,
            highlightColor: Colors.white24,
            child: Container(
              color: Colors.grey.shade600,
              width: 100,
              height: 100,
            ),
          );
        },
      ),
    );
  }
}
