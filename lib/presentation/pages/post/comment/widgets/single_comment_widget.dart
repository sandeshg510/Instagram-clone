import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/pages/post/comment/widgets/single_reply_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../consts.dart';
import '../../../../../domain/entities/comment/reply/reply_entity.dart';
import '../../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../cubit/comment/reply/reply_cubit.dart';
import '../../../../widgets/form_container_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickedListener;
  final UserEntity? currentUser;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListener,
    this.onLikeClickedListener,
    this.currentUser,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplying = false;
  String _currentUid = '';
  final TextEditingController _replyDescriptionController =
      TextEditingController();

  @override
  void initState() {
    setState(() {
      di.sl<GetCurrentUidUseCase>().call().then((value) {
        setState(() {
          _currentUid = value;
        });
      });

      BlocProvider.of<ReplyCubit>(context).getReplies(
          reply: ReplyEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0, right: 10),
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: profileWidget(
                              imageUrl: widget.comment.userProfileUrl),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.comment.username}',
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              sizedBoxHor(10),
                              Text(
                                DateFormat('dd/MMM/yyy ')
                                    .format(widget.comment.createAt!.toDate()),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.comment.description}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          sizedBoxVer(5),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isUserReplying = !_isUserReplying;
                                  });
                                },
                                child: Text(
                                  'Reply',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.comment.totalReplies == 0
                                  ? Fluttertoast.showToast(msg: 'No replies')
                                  : BlocProvider.of<ReplyCubit>(context)
                                      .getReplies(
                                      reply: ReplyEntity(
                                        postId: widget.comment.postId,
                                        commentId: widget.comment.commentId,
                                      ),
                                    );
                            },
                            child: widget.comment.totalReplies == 0
                                ? const SizedBox()
                                : Text(
                                    '             View Replies',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      widget.comment.likes!.contains(_currentUid)
                          ? GestureDetector(
                              onTap: widget.onLikeClickedListener,
                              child: const Icon(
                                CupertinoIcons.heart_fill,
                                size: 18,
                                color: Colors.red,
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.onLikeClickedListener,
                              child: Icon(
                                CupertinoIcons.heart,
                                size: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                      sizedBoxHor(20)
                    ],
                  )
                ]),
            _isUserReplying == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FormContainerWidget(
                        controller: _replyDescriptionController,
                        hintText: 'Post your reply...',
                        width: 290,
                      ),
                      sizedBoxVer(10),
                      GestureDetector(
                        onTap: _createReply,
                        child: const Text(
                          'Post',
                          style: TextStyle(color: blueColor),
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
            widget.comment.totalReplies == 0
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: BlocBuilder<ReplyCubit, ReplyState>(
                      builder: (context, replyState) {
                        if (replyState is ReplyLoading ||
                            replyState is ReplyInitial) {
                          return const SizedBox();
                        }
                        if (replyState is ReplyLoaded) {
                          final replies = replyState.replies
                              .where((element) =>
                                  element.commentId == widget.comment.commentId)
                              .toList();
                          print(replies.length);
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              reverse: true,
                              itemCount: replies.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleReplyWidget(
                                  reply: replies[index],
                                  onLongPressListener: () {
                                    _openBottomModelSheet(
                                        context: context,
                                        reply: replies[index]);
                                  },
                                  onLikePressListener: () {
                                    _likeReply(reply: replies[index]);
                                  },
                                );
                              });
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _createReply() {
    if (_replyDescriptionController.text.isEmpty) {
      return;
    }
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
          reply: ReplyEntity(
              replyId: const Uuid().v1(),
              createAt: Timestamp.now(),
              likes: const [],
              username: widget.currentUser!.username,
              userProfileUrl: widget.currentUser!.profileUrl,
              creatorUid: widget.currentUser!.uid,
              postId: widget.comment.postId,
              commentId: widget.comment.commentId,
              description: _replyDescriptionController.text),
        )
        .then((value) => {
              setState(() {
                _replyDescriptionController.clear();
                _isUserReplying = false;
              })
            });
  }

  _openBottomModelSheet(
      {required BuildContext context, required ReplyEntity reply}) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context) {
          Theme.of(context).colorScheme.tertiary;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  endIndent: 173,
                  indent: 173,
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 20),
                  child: Text(
                    'More options',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _deleteReply(replyEntity: reply);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 150, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Reply',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.updateReplyPage,
                        arguments: reply);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 150, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update Reply',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  _deleteReply({required ReplyEntity replyEntity}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(
        reply: ReplyEntity(
            postId: replyEntity.postId,
            commentId: replyEntity.commentId,
            replyId: replyEntity.replyId));
  }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }
}
