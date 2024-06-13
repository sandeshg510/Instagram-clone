import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources.dart';
import 'package:instagram_clone/data/data_sources/remote_data_sources/remote_data_sources_impl.dart';
import 'package:instagram_clone/data/repository/firebase_repository_impl.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/read_comments_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/reply/delete_reply_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/reply/like_reply_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/reply/read_replies_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/reply/update_reply_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/posts/read_single_post_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/create_user_with_image_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/presentation/cubit/comment/reply/reply_cubit.dart';
import 'package:instagram_clone/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';

import 'domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'domain/usecases/firebase_usecases/comment/reply/create_reply_usecase.dart';
import 'domain/usecases/firebase_usecases/posts/update_post_usecase.dart';

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

  sl.registerFactory(() => GetSingleUserCubit(
        getSingleUserUseCase: sl.call(),
      ));

  //PostCubit
  sl.registerFactory(() => PostCubit(
        createPostUseCase: sl.call(),
        readPostUseCase: sl.call(),
        updatePostUseCase: sl.call(),
        deletePostUseCase: sl.call(),
        likePostUseCase: sl.call(),
      ));

  //PostCubit
  sl.registerFactory(() => GetSinglePostCubit(
        readSinglePostUseCase: sl.call(),
      ));

  //CommentCubit
  sl.registerFactory(() => CommentCubit(
        createCommentUseCase: sl.call(),
        likeCommentUseCase: sl.call(),
        deleteCommentUseCase: sl.call(),
        readCommentsUseCase: sl.call(),
        updateCommentUseCase: sl.call(),
      ));

  //ReplyCubit
  sl.registerFactory(() => ReplyCubit(
        createReplyUseCase: sl.call(),
        likeReplyUseCase: sl.call(),
        deleteReplyUseCase: sl.call(),
        readRepliesUseCase: sl.call(),
        updateReplyUseCase: sl.call(),
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
  sl.registerLazySingleton(
      () => CreateUserWithImageUseCase(repository: sl.call()));

  //Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  //Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  //Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));

  //Reply
  sl.registerLazySingleton(() => CreateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadRepliesUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //RemoteDataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(
            firebaseFirestore: sl.call(),
            firebaseAuth: sl.call(),
            firebaseStorage: sl.call(),
          ));

  //Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
