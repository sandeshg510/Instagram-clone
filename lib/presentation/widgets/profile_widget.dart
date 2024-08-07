import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == '') {
      return Image.asset(
        'assets/profile_default.png',
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Shimmer.fromColors(
              baseColor: Colors.white12,
              highlightColor: Colors.white24,
              child: Container(
                color: Colors.grey.shade600,
              ));
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/profile_default.png',
            fit: BoxFit.cover,
          );
        },
      );
    }
  } else {
    return Image.file(
      image,
      fit: BoxFit.cover,
    );
  }
}
