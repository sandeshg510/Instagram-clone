import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/presentation/cubit/chats/chats_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/chats/widgets/chat_box_main_widget.dart';
import '../../../domain/entities/user/user_entity.dart';

class ChatBoxPage extends StatelessWidget {
  final UserEntity user;
  final String groupId;
  const ChatBoxPage({
    super.key,
    required this.user,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatsCubit>(
      create: (context) => di.sl<ChatsCubit>(),
      child: ChatBoxMainWidget(user: user, groupId: groupId),
    );
  }
}
