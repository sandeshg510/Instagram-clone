import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/reels/upload_reel_page.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/post/post_cubit.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key, required this.currentUser});
  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
        create: (context) => di.sl<PostCubit>(),
        child: Scaffold(
          backgroundColor: backGroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageConst.uploadPostPage,
                        arguments: currentUser);
                  },
                  child: const Text(
                    'Upload a post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
                sizedBoxVer(15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadReelPage(currentUser: currentUser)));
                  },
                  child: const Text(
                    'Upload a reel',
                    style: TextStyle(color: blueColor),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
