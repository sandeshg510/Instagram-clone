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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          profileWidget(imageUrl: widget.reply.userProfileUrl),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.reply.username}',
                        style: const TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      sizedBoxVer(5),
                      Text(
                        '${widget.reply.description}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                      sizedBoxVer(5),
                      Row(
                        children: [
                          Text(
                            DateFormat('dd/MMM/yyy ')
                                .format(widget.reply.createAt!.toDate()),
                            style: const TextStyle(
                                fontSize: 14,
                                color: secondaryColor,
                                fontWeight: FontWeight.normal),
                          ),
                          sizedBoxHor(20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserReplying = !_isUserReplying;
                              });
                            },
                            child: const Text(
                              'Reply',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          sizedBoxHor(22),
                          const Text(
                            ' View\nReplies',
                            style: TextStyle(
                                fontSize: 13,
                                color: secondaryColor,
                                fontWeight: FontWeight.normal),
                          ),
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
                          : Container(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                  sizedBoxHor(9),
                  GestureDetector(
                    onTap: widget.onLikePressListener,
                    child: widget.reply.likes!.contains(_currentUid)
                        ? Image.asset(
                            'assets/red-heart-11121.png',
                            color: Colors.red,
                            height: 18,
                          )
                        : Image.asset(
                            'assets/heart.png',
                            color: secondaryColor,
                            height: 18,
                          ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
