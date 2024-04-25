import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources.dart';
import 'package:instagram_clone/data/models/user/user_model.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseFirestore, required this.firebaseAuth});

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        username: user.username,
        bio: user.bio,
        website: user.website,
        profileUrl: user.profileUrl,
        email: user.email,
        totalPosts: user.totalPosts,
        following: user.following,
        followers: user.followers,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      Fluttertoast.showToast(msg: 'some error occured');
    });
  }

  @override
  Future<String> getCurrentUid() {
    // TODO: implement getCurrentUid
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    // TODO: implement getSingleUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() {
    // TODO: implement isSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> signInUser(UserEntity user) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> signUpUser(UserEntity user) {
    // TODO: implement signUpUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
