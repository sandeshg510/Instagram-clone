import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../../consts.dart';
import '../../../../domain/app_entity.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../../../cubit/post/post_cubit.dart';
import '../../../widgets/profile_widget.dart';
import '../../post/widgets/like_animation_widget.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.singleUserProfilePage,
                      arguments: widget.post.creatorUid);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: profileWidget(
                            imageUrl: "${widget.post.userProfileUrl}"),
                      ),
                    ),
                    sizedBoxHor(10),
                    Text(
                      "${widget.post.username}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModelSheet(context, widget.post);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ))
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
          sizedBoxVer(10),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                      duration: const Duration(milliseconds: 300),
                      isLikeAnimating: _isLikeAnimating,
                      onLikeFinish: () {
                        setState(() {
                          _isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.suit_heart_fill,
                        size: 100,
                        color: primaryColor,
                      )),
                ),
              ],
            ),
          ),
          sizedBoxVer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  sizedBoxHor(6),
                  widget.post.likes!.contains(_currentUid)
                      ? GestureDetector(
                          onTap: _likePost,
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            size: 26,
                            color: Colors.red,
                          )
                          // Image.asset(
                          //   'assets/instagram_red_heart.png',
                          //   height: 22,
                          // ),
                          )
                      : GestureDetector(
                          onTap: _likePost,
                          child: const Icon(
                            CupertinoIcons.heart,
                            size: 26,
                            color: secondaryColor,
                          )
                          // Image.asset(
                          //   'assets/heart.png',
                          //   color: secondaryColor,
                          //   height: 22,
                          // ),
                          ),
                  sizedBoxHor(15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage,
                          arguments: AppEntity(
                              uid: _currentUid, postId: widget.post.postId));
                    },
                    child: Image.asset(
                      'assets/chat.png',
                      color: secondaryColor,
                      height: 20,
                    ),
                  ),
                  sizedBoxHor(15),
                  Image.asset(
                    'assets/send.png',
                    color: secondaryColor,
                    height: 20,
                  ),
                ],
              ),
              Image.asset(
                'assets/bookmark.png',
                color: secondaryColor,
                height: 20,
              ),
            ],
          ),
          sizedBoxVer(10),
          Text(
            '${widget.post.totalLikes} likes',
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '${widget.post.username}',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizedBoxHor(10),
                  Text(
                    '${widget.post.description}',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              )
            ],
          ),
          sizedBoxVer(10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.commentPage,
                  arguments:
                      AppEntity(uid: _currentUid, postId: widget.post.postId));
            },
            child: Text(
              'view all ${widget.post.totalComments} comments',
              style: const TextStyle(color: darkGreyColor),
            ),
          ),
          sizedBoxVer(10),
          Text(
            DateFormat('dd/MMM/yyy ').format(widget.post.createAt!.toDate()),
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }

  _openBottomModelSheet(BuildContext context, PostEntity post) {
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
                  onTap: _deletePost,
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Post',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.updatePostPage,
                        arguments: post);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update post',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePosts(post: PostEntity(postId: widget.post.postId));

    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'Post deleted successfully');
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePosts(post: PostEntity(postId: widget.post.postId));
  }
}

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                       onTap: _likePost,
//                       child: Icon(
//                         widget.post.likes!.contains(_currentUid)
//                             ? Icons.favorite
//                             : Icons.favorite_outline,
//                         color: widget.post.likes!.contains(_currentUid)
//                             ? Colors.red
//                             : primaryColor,
//                       )),
//                   sizedBoxHor(10),
//                   GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, PageConst.commentPage,
//                             arguments: AppEntity(
//                                 uid: _currentUid, postId: widget.post.postId));
//                         //Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()));
//                       },
//                       child: const Icon(
//                         Icons.message,
//                         color: primaryColor,
//                       )),
//                   sizedBoxHor(10),
//                   const Icon(
//                     Icons.send,
//                     color: primaryColor,
//                   ),
//                 ],
//               ),
//               const Icon(
//                 Icons.bookmark_border,
//                 color: primaryColor,
//               )
//             ],
//           ),
//           sizedBoxVer(10),
//           Text(
//             "${widget.post.totalLikes} likes",
//             style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
//           ),
//           sizedBoxVer(10),
//           Row(
//             children: [
//               Text(
//                 "${widget.post.username}",
//                 style:
//                     TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
//               ),
//               sizedBoxVer(10),
//               Text(
//                 "${widget.post.description}",
//                 style: TextStyle(color: primaryColor),
//               ),
//             ],
//           ),
//           sizedBoxVer(10),
//           GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(context, PageConst.commentPage,
//                     arguments: AppEntity(
//                         uid: _currentUid, postId: widget.post.postId));
//               },
//               child: Text(
//                 "View all ${widget.post.totalComments} comments",
//                 style: TextStyle(color: darkGreyColor),
//               )),
//           sizedBoxVer(10),
//           Text(
//             "${DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate())}",
//             style: TextStyle(color: darkGreyColor),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _openBottomModalSheet(BuildContext context, PostEntity post) {
//     return showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Container(
//             height: 150,
//             decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
//             child: SingleChildScrollView(
//               child: Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: Text(
//                         "More Options",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: primaryColor),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Divider(
//                       thickness: 1,
//                       color: secondaryColor,
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: GestureDetector(
//                         onTap: _deletePost,
//                         child: Text(
//                           "Delete Post",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: primaryColor),
//                         ),
//                       ),
//                     ),
//                     sizedBoxVer(7),
//                     Divider(
//                       thickness: 1,
//                       color: secondaryColor,
//                     ),
//                     sizedBoxVer(7),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, PageConst.updatePostPage,
//                               arguments: post);
//
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
//                         },
//                         child: Text(
//                           "Update Post",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: primaryColor),
//                         ),
//                       ),
//                     ),
//                     sizedBoxVer(7),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   _deletePost() {
//     BlocProvider.of<PostCubit>(context)
//         .deletePosts(post: PostEntity(postId: widget.post.postId));
//   }
//
//   _likePost() {
//     BlocProvider.of<PostCubit>(context)
//         .likePosts(post: PostEntity(postId: widget.post.postId));
//   }
// }
