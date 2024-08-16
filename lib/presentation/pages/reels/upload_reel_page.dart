import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/reels/widgets/upload_reel_main_widget.dart';

class UploadReelPage extends StatelessWidget {
  final UserEntity currentUser;

  const UploadReelPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: UploadReelMainWidget(currentUser: currentUser),
    );
  }
}
