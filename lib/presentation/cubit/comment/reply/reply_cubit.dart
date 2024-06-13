import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/firebase_usecases/comment/reply/create_reply_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/comment/reply/delete_reply_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/comment/reply/like_reply_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/comment/reply/read_replies_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/comment/reply/update_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit(
      {required this.createReplyUseCase,
      required this.likeReplyUseCase,
      required this.deleteReplyUseCase,
      required this.readRepliesUseCase,
      required this.updateReplyUseCase})
      : super(ReplyInitial());

  final CreateReplyUseCase createReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final ReadRepliesUseCase readRepliesUseCase;
  final UpdateReplyUseCase updateReplyUseCase;

  Future<void> createReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await createReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (e) {
      emit(ReplyFailure());
    }
  }

  Future<void> getReplies({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = readRepliesUseCase.call(reply);
      streamResponse.listen((replies) {
        emit(ReplyLoaded(replies: replies));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await updateReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (e) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await likeReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (e) {
      emit(ReplyFailure());
    }
  }
}
