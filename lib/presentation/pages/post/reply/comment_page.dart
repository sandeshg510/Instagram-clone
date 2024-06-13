import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/app_entity.dart';
import 'package:instagram_clone/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/pages/post/comment/widgets/comment_main_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;

  const CommentPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleUserCubit>(
            create: (context) => di.sl<GetSingleUserCubit>()),
        BlocProvider<CommentCubit>(create: (context) => di.sl<CommentCubit>()),
        BlocProvider<GetSinglePostCubit>(
            create: (context) => di.sl<GetSinglePostCubit>()),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
