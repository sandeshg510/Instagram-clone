import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required this.updatePostUseCase,
    required this.likePostUseCase,
    required this.deletePostUseCase,
    required this.createPostUseCase,
    required this.readPostUseCase,
  }) : super(PostInitial());
  final UpdatePostUseCase updatePostUseCase;
  final ReadPostUseCase readPostUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final LikePostUseCase likePostUseCase;

  Future<void> createPosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await createPostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (e) {
      emit(PostFailure());
    }
  }

  Future<void> getPosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      final streamResponse = readPostUseCase.call(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await updatePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePosts({required PostEntity post}) async {
    try {
      await deletePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (e) {
      emit(PostFailure());
    }
  }

  Future<void> likePosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await likePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (e) {
      emit(PostFailure());
    }
  }
}
