import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/presentation/cubit/chats/chats_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/chats/widgets/chat_box_main_widget.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';

class ChatBoxPage extends StatelessWidget {
  UserEntity? user;
  String? groupId;
  ChatBoxPage({
    super.key,
    this.user,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatsCubit>(
      create: (context) => di.sl<ChatsCubit>(),
      child: ChatBoxMainWidget(user: user!, groupId: groupId!),
    );
  }
}
