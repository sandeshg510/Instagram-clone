import 'dart:io';

import 'package:instagram_clone/domain/entities/user/user_entity.dart';

import '../../../domain/entities/posts/post_entity.dart';

abstract class FirebaseRemoteDataSource {
  //Credential
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  //User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> createUserWithImage(UserEntity user, String profileUrl);

  //Cloud Storage
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  //Posts Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
}
