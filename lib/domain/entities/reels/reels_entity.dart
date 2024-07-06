import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReelEntity extends Equatable {
  final String? reelId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? reelUrl;
  final String? thumbnailUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  ReelEntity({
    this.reelId,
    this.creatorUid,
    this.username,
    this.description,
    this.reelUrl,
    this.thumbnailUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        reelId,
        creatorUid,
        username,
        description,
        reelUrl,
        thumbnailUrl,
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
