import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clone/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/reel/get_single_reel/get_single_reel_cubit.dart';
import 'package:instagram_clone/presentation/cubit/reel/reel_cubit.dart';
import 'package:instagram_clone/presentation/cubit/theme/theme_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/presentation/global/theme/app_theme.dart';
import 'package:instagram_clone/presentation/pages/credential/login_page.dart';
import 'package:instagram_clone/presentation/pages/main_screen/main_page.dart';
import 'injection_container.dart' as di;
import 'on_generate_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
          BlocProvider(create: (_) => di.sl<ThemeCubit>()..setInitialTheme()),
          BlocProvider(create: (_) => di.sl<CredentialCubit>()),
          BlocProvider(create: (_) => di.sl<UserCubit>()),
          BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
          BlocProvider(create: (_) => di.sl<GetSinglePostCubit>()),
          BlocProvider(create: (_) => di.sl<GetSingleReelCubit>()),
          BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
          BlocProvider(create: (_) => di.sl<ReelCubit>()),
          BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              darkTheme: AppTheme.darkTheme,
              theme: AppTheme.lightTheme,
              themeMode: themeState.themeData == AppTheme.darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: OnGenerateRoute.route,
              initialRoute: '/',
              routes: {
                '/': (context) {
                  return BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                    if (authState is Authenticated) {
                      return MainPage(uid: authState.uid);
                    } else {
                      return const LoginPage();
                    }
                  });
                }
              },
            );
          },
        ));
  }
}
