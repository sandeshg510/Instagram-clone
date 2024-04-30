import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources_impl.dart';
import 'package:instagram_clone/data/repository/firebase_repository_impl.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Cubits
  sl.registerFactory(() => AuthCubit(
        signOutUserUseCase: sl.call(),
        isSignInUseCase: sl.call(),
        getCurrentUidUseCase: sl.call(),
      ));

  sl.registerFactory(() => CredentialCubit(
        signInUserUseCase: sl.call(),
        signUpUserUseCase: sl.call(),
      ));

  sl.registerFactory(() => UserCubit(
        updateUserUseCase: sl.call(),
        getUsersUseCase: sl.call(),
      ));

  //UseCases
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignOutUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //RemoteDataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(), firebaseAuth: sl.call()));

  //Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
}
