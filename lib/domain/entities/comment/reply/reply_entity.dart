import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? commentId;
  final String? postId;
  final String? replyId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;

  ReplyEntity({
    this.replyId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.creatorUid,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        replyId,
        commentId,
        postId,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
        creatorUid,
      ];
}
