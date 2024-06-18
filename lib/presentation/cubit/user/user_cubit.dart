import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final FollowUnfollowUserUseCase followUnfollowUserUseCase;
  UserCubit(
      {required this.followUnfollowUserUseCase,
      required this.updateUserUseCase,
      required this.getUsersUseCase})
      : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      await updateUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUnfollowUser({required UserEntity user}) async {
    emit(UserLoading());
    try {
      await followUnfollowUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
