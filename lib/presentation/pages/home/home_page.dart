import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/home/widgets/post_shimmer.dart';
import 'package:instagram_clone/presentation/pages/home/widgets/single_post_card_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/home/widgets/single_reel_card_widget_for_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: Theme.of(context).colorScheme.primary,
          height: 32,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, PageConst.messengerPage);
              },
              icon: Image.asset(
                'assets/messenger.png',
                color: Theme.of(context).colorScheme.primary,
                height: 22,
              ),
            ),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return const PostShimmer();
            }
            if (postState is PostFailure) {
              Fluttertoast.showToast(
                  msg: 'some failure occurred while creating the post');
            }
            if (postState is PostLoaded) {
              return postState.posts.isEmpty
                  ? _noPostsYetWidget()
                  : ListView.builder(
                      itemCount: postState.posts.length,
                      itemBuilder: (context, index) {
                        final post = postState.posts[index];
                        switch (post.postType) {
                          case FirebaseConst.posts:
                            {
                              return BlocProvider(
                                create: (context) => di.sl<PostCubit>(),
                                child: SinglePostCardWidget(post: post),
                              );
                            }
                          case FirebaseConst.reels:
                            {
                              return BlocProvider(
                                create: (context) => di.sl<PostCubit>(),
                                child: SingleReelCardWidgetForHome(
                                  reel: post,
                                  reelId: post.postId!,
                                ),
                              );
                            }
                        }
                      });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  _openBottomModelSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context) {
          backGroundColor;
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
                  color: secondaryColor.shade600,
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Delete Post',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.updatePostPage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Update post',
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

  _noPostsYetWidget() {
    return const Center(
      child: Text(
        'No posts yet',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }
}
