import 'dart:io';

import 'package:instagram_clone/domain/entities/user/user_entity.dart';

import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/entities/comment/reply/reply_entity.dart';
import '../../../domain/entities/posts/post_entity.dart';
import '../../../domain/entities/reels/reels_entity.dart';

abstract class FirebaseRemoteDataSource {
  //Credential
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  //User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> createUserWithImage(UserEntity user, String profileUrl);
  Future<void> followUnfollowUser(UserEntity user);

  //Cloud Storage
  //Images
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  //Reels
  uploadReelToStorage(
      {required String descriptionText,
      required String videoFilePath,
      required context});

  Future<String> uploadReelThumbnailToStorage(String videoFilePath);

  //Reels Features
  Future<void> createReel(ReelEntity reel);

  Stream<List<ReelEntity>> getReels(ReelEntity reel);

  //Posts Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

  //Video Features

  //Comments Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  //Reply Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);
}
