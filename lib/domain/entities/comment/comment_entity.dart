import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplies;
  final String? creatorUid;

  CommentEntity({
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplies,
    this.creatorUid,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        commentId,
        postId,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
        totalReplies,
        creatorUid,
      ];
}
