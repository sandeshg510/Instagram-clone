import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../consts.dart';

class ShimmerSearchWidget extends StatelessWidget {
  const ShimmerSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade400,
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(15)),
          ),
        ),
        sizedBoxVer(10),
      ],
    );
  }
}
