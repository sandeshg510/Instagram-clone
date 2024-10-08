import 'package:flutter/material.dart';
import 'package:instagram_clone/domain/app_entity.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/pages/chats/chat_box_page.dart';
import 'package:instagram_clone/presentation/pages/chats/messenger_page.dart';
import 'package:instagram_clone/presentation/pages/credential/login_page.dart';
import 'package:instagram_clone/presentation/pages/credential/sign_up_page.dart';
import 'package:instagram_clone/presentation/pages/post/comment/comment_page.dart';
import 'package:instagram_clone/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:instagram_clone/presentation/pages/post/comment/edit_reply_page.dart';
import 'package:instagram_clone/presentation/pages/post/post_detail_page.dart';
import 'package:instagram_clone/presentation/pages/post/update_post_page.dart';
import 'package:instagram_clone/presentation/pages/post/upload_post_page.dart';
import 'package:instagram_clone/presentation/pages/profile/edit_profile_page.dart';
import 'package:instagram_clone/presentation/pages/profile/followers_page.dart';
import 'package:instagram_clone/presentation/pages/profile/following_page.dart';
import 'package:instagram_clone/presentation/pages/profile/profile_page.dart';
import 'package:instagram_clone/presentation/pages/profile/single_user_profile_page.dart';
import 'package:instagram_clone/presentation/pages/reels/upload_reel_page.dart';

import 'consts.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.profilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(ProfilePage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageConst.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(
              UpdatePostPage(post: args),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(
              EditCommentPage(comment: args),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageConst.updateReplyPage:
        {
          if (args is ReplyEntity) {
            return routeBuilder(
              EditReplyPage(reply: args),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageConst.commentPage:
        if (args is AppEntity) {
          return routeBuilder(CommentPage(
            appEntity: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.postDetailPage:
        if (args is String) {
          return routeBuilder(PostDetailPage(
            postId: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.singleUserProfilePage:
        if (args is String) {
          return routeBuilder(SingleUserProfilePage(
            otherUserId: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.followingPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowingPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageConst.followersPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowersPage(
              user: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageConst.loginPage:
        {
          return routeBuilder(const LoginPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      case PageConst.uploadPostPage:
        {
          if (args is UserEntity) {
            return routeBuilder(UploadPostPage(
              currentUser: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.uploadReelsPage:
        {
          if (args is UserEntity) {
            return routeBuilder(UploadReelPage(
              currentUser: args,
            ));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConst.messengerPage:
        {
          return routeBuilder(const MessengerPage());
        }
      case PageConst.chatBoxPage:
        {
          ChatArguments argument = args as ChatArguments;
          return routeBuilder(ChatBoxPage(
            user: argument.user,
            groupId: argument.groupId,
          ));
        }

      default:
        {
          const NoPageFound();
        }
    }
  }
}

class ChatArguments {
  final UserEntity user;
  final String groupId;

  ChatArguments({required this.user, required this.groupId});
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page not found'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
