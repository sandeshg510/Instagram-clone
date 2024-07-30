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
          baseColor: Colors.white12,
          highlightColor: Colors.white24,
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(15)),
          ),
        ),
        sizedBoxVer(10),
      ],
    );
  }
}
