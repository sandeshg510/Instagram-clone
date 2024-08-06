import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../../../consts.dart';
import '../../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../widgets/form_container_widget.dart';
import '../../../../widgets/profile_widget.dart';

class SingleReplyWidget extends StatefulWidget {
  const SingleReplyWidget(
      {super.key,
      required this.reply,
      required this.onLongPressListener,
      required this.onLikePressListener});

  final ReplyEntity reply;
  final VoidCallback onLongPressListener;
  final VoidCallback onLikePressListener;

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  bool _isUserReplying = false;
  final TextEditingController _replyDescriptionController =
      TextEditingController();

  String _currentUid = '';

  @override
  void initState() {
    setState(() {
      di.sl<GetCurrentUidUseCase>().call().then((value) {
        setState(() {
          _currentUid = value;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _replyDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: widget.reply.creatorUid == _currentUid
              ? widget.onLongPressListener
              : null,
          child: Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: profileWidget(
                              imageUrl: widget.reply.userProfileUrl),
                        ),
                      ),
                      sizedBoxHor(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.reply.username}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  )),
                              sizedBoxHor(10),
                              Text(
                                DateFormat('yyyy-MM-dd hh:mm')
                                    .format(widget.reply.createAt!.toDate()),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          sizedBoxVer(5),
                          Text(
                            '${widget.reply.description}',
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
                              sizedBoxHor(22),
                              // Text(
                              //   ' View\nReplies',
                              //   style: TextStyle(
                              //       fontSize: 13,
                              //       color: Theme.of(context).colorScheme.secondary,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ],
                          ),
                          sizedBoxVer(5),
                          _isUserReplying == true
                              ? sizedBoxVer(10)
                              : sizedBoxVer(0),
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
                                      // onTap: _createReply,
                                      child: const Text(
                                        'Post',
                                        style: TextStyle(color: blueColor),
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.reply.likes!.contains(_currentUid)
                          ? GestureDetector(
                              onTap: widget.onLikePressListener,
                              child: const Icon(
                                CupertinoIcons.heart_fill,
                                size: 18,
                                color: Colors.red,
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.onLikePressListener,
                              child: Icon(
                                CupertinoIcons.heart,
                                size: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                      sizedBoxVer(40),
                      sizedBoxHor(60)
                    ],
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
