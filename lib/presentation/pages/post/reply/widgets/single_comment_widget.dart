import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import '../../../../../consts.dart';
import '../../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../widgets/form_container_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickedListener;
  const SingleCommentWidget(
      {super.key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickedListener});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplying = false;
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
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileWidget(imageUrl: widget.comment.userProfileUrl),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.comment.username}',
                    style: const TextStyle(
                        fontSize: 15,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  sizedBoxVer(5),
                  Text(
                    '${widget.comment.description}',
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
                            .format(widget.comment.createAt!.toDate()),
                        style: const TextStyle(
                            fontSize: 14,
                            color: secondaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                      sizedBoxHor(25),
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
                      sizedBoxHor(25),
                      const Text(
                        'View Replies',
                        style: TextStyle(
                            fontSize: 13,
                            color: secondaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  sizedBoxVer(5),
                  _isUserReplying == true ? sizedBoxVer(10) : sizedBoxVer(0),
                  _isUserReplying == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const FormContainerWidget(
                              hintText: 'Post your reply...',
                              width: 290,
                            ),
                            sizedBoxVer(10),
                            const Text(
                              'Post',
                              style: TextStyle(color: blueColor),
                            )
                          ],
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        )
                ],
              ),
              GestureDetector(
                onTap: widget.onLikeClickedListener,
                child: widget.comment.likes!.contains(_currentUid)
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
              sizedBoxHor(4),
            ]),
      ),
    );
  }
}
