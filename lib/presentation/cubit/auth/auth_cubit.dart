import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignOutUserUseCase signOutUserUseCase;
  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;

  AuthCubit({
    required this.signOutUserUseCase,
    required this.isSignInUseCase,
    required this.getCurrentUidUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUseCase.call();

      if (isSignIn == true) {
        final uid = await getCurrentUidUseCase.call();
        emit(Authenticated(uid: uid));
        print('App started function was performed');
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUseCase.call();
      emit(Authenticated(uid: uid));
      print('uid');
      print('Logged in was performed');
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUserUseCase.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
