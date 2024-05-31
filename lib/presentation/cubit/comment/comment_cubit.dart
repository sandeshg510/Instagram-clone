import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';

import '../../../domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import '../../../domain/usecases/firebase_usecases/comment/delete_comment_usecase.dart';
import '../../../domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import '../../../domain/usecases/firebase_usecases/comment/read_comments_usecase.dart';
import '../../../domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit(
      {required this.createCommentUseCase,
      required this.likeCommentUseCase,
      required this.deleteCommentUseCase,
      required this.readCommentsUseCase,
      required this.updateCommentUseCase})
      : super(CommentInitial());

  final CreateCommentUseCase createCommentUseCase;
  final LikeCommentUseCase likeCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final ReadCommentsUseCase readCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;

  Future<void> createComments({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await createCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }

  Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = readCommentsUseCase.call(postId);
      streamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComments({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await updateCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComments({required CommentEntity comment}) async {
    try {
      await deleteCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComments({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await likeCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (e) {
      emit(CommentFailure());
    }
  }
}
