import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_main_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.currentUser});

  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostCubit>(),
      child: ProfileMainWidget(currentUser: currentUser),
    );
  }
}
