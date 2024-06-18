import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/domain/entities/chats/chats_entity.dart';

class ChatsModel extends ChatsEntity {
  final String? chatId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final String? creatorUid;

  ChatsModel({
    this.chatId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.creatorUid,
  }) : super(
          chatId: chatId,
          postId: postId,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          creatorUid: creatorUid,
        );

  factory ChatsModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatsModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: List.from(snap.get('likes')),
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
      chatId: snapshot['commentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'postId': postId,
        'description': description,
        'username': username,
        'userProfileUrl': userProfileUrl,
        'createAt': createAt,
        'likes': likes,
        'creatorUid': creatorUid,
      };
}
