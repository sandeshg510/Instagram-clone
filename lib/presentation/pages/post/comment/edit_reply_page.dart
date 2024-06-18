import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/presentation/cubit/comment/reply/reply_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import 'package:instagram_clone/presentation/pages/post/comment/widgets/edit_reply_main_widget.dart';

class EditReplyPage extends StatelessWidget {
  const EditReplyPage({super.key, required this.reply});

  final ReplyEntity reply;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplyCubit>(
      create: (context) => di.sl<ReplyCubit>(),
      child: EditReplyMainWidget(reply: reply),
    );
  }
}
