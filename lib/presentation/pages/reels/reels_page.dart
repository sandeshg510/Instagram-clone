import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/reels/widgets/single_reel_card_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class ReelsPage extends StatefulWidget {
  const ReelsPage({
    super.key,
  });

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  PostEntity? reel;
  List<PostEntity>? reels = [];
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
      body: BlocProvider(
        create: (context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
          if (postState is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (postState is PostFailure) {
            Fluttertoast.showToast(
                msg: 'some failure occurred while getting the reel');
          }

          if (postState is PostLoaded) {
            for (PostEntity post in postState.posts) {
              if (post.postType == FirebaseConst.reels) {
                reel = post;
                reels!.add(reel!);
              }
            }

            return reel != null
                ? PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: pageController,
                    itemCount: reels!.length,
                    padEnds: true,
                    itemBuilder: (context, index) {
                      final playingReel = reels![index];

                      return BlocProvider(
                        create: (context) => di.sl<PostCubit>(),
                        child: SingleReelCardWidget(
                          reel: playingReel,
                          reelId: playingReel.postId!,
                        ),
                      );
                    })
                : _noReelsYetWidget();
          }

          return const Center(
            child: Text('No reel'),
          );
        }),
      ),
    );
  }

  _noReelsYetWidget() {
    return const Center(
      child: Text(
        'No reels yet',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }
}
