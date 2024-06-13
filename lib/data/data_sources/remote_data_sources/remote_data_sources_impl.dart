import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources.dart';
import 'package:instagram_clone/data/models/comment/comment_model.dart';
import 'package:instagram_clone/data/models/posts/post_model.dart';
import 'package:instagram_clone/data/models/user/user_model.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/comment/reply/reply_model.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseStorage,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        username: user.username,
        bio: user.bio,
        website: user.website,
        profileUrl: profileUrl,
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
      Fluttertoast.showToast(msg: 'some error occur');
    });
  }

  @override
  Future<void> createUser(UserEntity user, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        username: user.username,
        bio: user.bio,
        website: user.website,
        profileUrl: profileUrl,
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
      Fluttertoast.showToast(msg: 'some error occur');
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where('uid', isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print('fields cannot be empty');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'user not found');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Invalid email or password');
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((value) async {
        if (value.user?.uid != null) {
          if (user.imageFile != null) {
            uploadImageToStorage(user.imageFile, false, 'profileImages')
                .then((profileUrl) => createUserWithImage(user, profileUrl));
          } else {
            createUserWithImage(user, '');
          }
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = Map();

    if (user.username != '' && user.username != null)
      userInformation['username'] = user.username;

    if (user.website != '' && user.website != null)
      userInformation['website'] = user.website;

    if (user.profileUrl != '' && user.profileUrl != null)
      userInformation['profileUrl'] = user.profileUrl;

    if (user.bio != '' && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != '' && user.name != null)
      userInformation['name'] = user.name;

    if (user.totalFollowing != null)
      userInformation['totalFollowing'] = user.totalFollowing;

    if (user.totalFollowers != null)
      userInformation['totalFollowers'] = user.totalFollowers;

    if (user.totalPosts != null)
      userInformation['totalPosts'] = user.totalPosts;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final newPost = PostModel(
      postId: post.postId,
      creatorUid: post.creatorUid,
      username: post.username,
      description: post.description,
      postImageUrl: post.postImageUrl,
      likes: [],
      totalLikes: 0,
      totalComments: 0,
      createAt: post.createAt,
      userProfileUrl: post.userProfileUrl,
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost);
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      print('some error occurred $e');
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    try {
      postCollection.doc(post.postId).delete();
    } catch (e) {
      print('some error occurred $e');
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get('likes');
      final totalLikes = postRef.get('totalLikes');

      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayRemove([currentUid]),
          'totalLikes': totalLikes - 1,
        });
      } else {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayUnion([currentUid]),
          'totalLikes': totalLikes + 1,
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy('createAt', descending: true);

    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy('createAt', descending: true)
        .where('postId', isEqualTo: postId);

    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    Map<String, dynamic> postInfo = Map();

    if (post.description != '' && post.description != null)
      postInfo['description'] = post.description;
    if (post.postImageUrl != '' && post.postImageUrl != null)
      postInfo['postImageUrl'] = post.postImageUrl;

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comments);

    final newComment = CommentModel(
      commentId: comment.commentId,
      postId: comment.postId,
      description: comment.description,
      username: comment.username,
      userProfileUrl: comment.userProfileUrl,
      createAt: comment.createAt,
      likes: [],
      totalReplies: comment.totalReplies,
      creatorUid: comment.creatorUid,
    ).toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(comment.postId);
          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');

              postCollection.update({'totalComments': totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print('some error occurred $e');
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comments);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(comment.postId);
        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');

            postCollection.update({'totalComments': totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print('some error occurred $e');
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comments);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get('likes');

      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          'likes': FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          'likes': FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comments)
        .orderBy('createAt', descending: true);

    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comments);

    Map<String, dynamic> commentInfo = Map();

    if (comment.description != '' && comment.description != null) {
      commentInfo['description'] = comment.description;
    }
    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comments)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final newReply = ReplyModel(
      commentId: reply.commentId,
      postId: reply.postId,
      description: reply.description,
      username: reply.username,
      userProfileUrl: reply.userProfileUrl,
      createAt: reply.createAt,
      likes: [],
      replyId: reply.replyId,
      creatorUid: reply.creatorUid,
    ).toJson();

    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReply);
      } else {
        replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      print('Some error occurred $e');
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comments)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    try {
      replyCollection.doc(reply.replyId).delete();
    } catch (e) {
      print('Some error occurred $e');
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comments)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final currentUid = await getCurrentUid();

    final replyRef = await replyCollection.doc(reply.replyId).get();

    if (replyRef.exists) {
      List likes = replyRef.get('likes');
      if (likes.contains(currentUid)) {
        replyCollection.doc(reply.replyId).update({
          'likes': FieldValue.arrayRemove([currentUid])
        });
      } else {
        replyCollection.doc(reply.replyId).update({
          'likes': FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comments)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comments)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    Map<String, dynamic> replyInfo = Map();

    if (reply.description != '' && reply.description != null) {
      replyInfo['description'] = reply.description;
    }
    replyCollection.doc(reply.replyId).update(replyInfo);
  }
}
