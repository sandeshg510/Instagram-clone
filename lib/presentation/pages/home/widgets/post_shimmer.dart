import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../consts.dart';

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Shimmer.fromColors(
                  baseColor: Colors.white12,
                  highlightColor: Colors.white24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                      ),
                      sizedBoxVer(10),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                      ),
                      sizedBoxVer(10),
                      Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                      ),
                      sizedBoxVer(10),
                      Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                      ),
                      sizedBoxVer(2),
                      Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                      ),
                    ],
                  )));
        });
  }
}
