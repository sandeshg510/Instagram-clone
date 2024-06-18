import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '';

class ChatsEntity extends Equatable {
  final String? chatId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final String? creatorUid;

  ChatsEntity({
    this.chatId,
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
        chatId,
        postId,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
        creatorUid,
      ];
}
