import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/app_entity.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/pages/post/comment/widgets/single_comment_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../../widgets/profile_widget.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({super.key, required this.appEntity});

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);

    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: primaryColor),
        ),
        title: const Text('Comments', style: TextStyle(color: primaryColor)),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostLoaded) {
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: profileWidget(
                                          imageUrl: singlePost.userProfileUrl),
                                    ),
                                  ),
                                  sizedBoxHor(10),
                                  Text(
                                    '${singlePost.username}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            sizedBoxVer(10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                '${singlePost.description}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            sizedBoxVer(10),
                            const Divider(
                              color: secondaryColor,
                            ),
                            sizedBoxVer(10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: commentState.comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final singleComment =
                                      commentState.comments[index];
                                  return SingleCommentWidget(
                                      comment: singleComment,
                                      onLikeClickedListener: () {
                                        _likeComment(
                                            comment:
                                                commentState.comments[index]);
                                      },
                                      onLongPressListener: () {
                                        _openBottomModelSheet(
                                            context: context,
                                            comment:
                                                commentState.comments[index]);
                                      });
                                },
                              ),
                            ),
                            _commentSection(currentUser: singleUser)
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 60,
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: profileWidget(imageUrl: currentUser.profileUrl),
              ),
            ),
            sizedBoxHor(10),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: primaryColor),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Post your comment...',
                    hintStyle: TextStyle(color: secondaryColor)),
              ),
            ),
            GestureDetector(
              onTap: () {
                _createComment(currentUser);
              },
              child: const Text(
                'Post',
                style: TextStyle(color: blueColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComments(
            comment: CommentEntity(
          commentId: const Uuid().v1(),
          postId: widget.appEntity.postId,
          description: _descriptionController.text,
          username: currentUser.username,
          userProfileUrl: currentUser.profileUrl,
          createAt: Timestamp.now(),
          likes: [],
          totalReplies: 0,
          creatorUid: currentUser.uid,
        ))
        .then((value) => setState(() {
              _descriptionController.clear();
            }));
  }

  _openBottomModelSheet(
      {required BuildContext context, required CommentEntity comment}) {
    return showModalBottomSheet(
        backgroundColor: backGroundColor,
        context: context,
        builder: (context) {
          backGroundColor;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: backGroundColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: secondaryColor.shade600,
                  endIndent: 173,
                  indent: 173,
                  thickness: 3,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 20),
                  child: Text(
                    'More options',
                    style: TextStyle(color: secondaryColor, fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _deleteComment(comment: comment);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 150, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Comment',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.updateCommentPage,
                        arguments: comment);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 150, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update Comment',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  _deleteComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).deleteComments(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
    Fluttertoast.showToast(msg: 'Comment\'s been deleted successfully');
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComments(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }
}
