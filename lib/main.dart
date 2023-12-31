import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/ViewModel/LikeDislikeFollowUnfollowFeatures/like_dislike_follow_unfollow_featurs_cubit.dart';
import 'package:instagram/Features/Instagram/ViewModel/ProfileViewtabModelView/profile_view_tab_cubit.dart';
import 'package:instagram/Features/Instagram/ViewModel/SearchViewTabModelView/search_view_tab_cubit.dart';

import 'Features/Auth/View/splashView/splash_view.dart';
import 'Features/Auth/ViewModel/cubit/auth_cubit.dart';
import 'Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import 'firebase_options.dart';
import 'services_locator.dart' as di;

Future<void> fireBaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('===================================');
  print(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.servicesLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>(),
        ),
        BlocProvider<HomeViewTabCubit>(
          create: (_) => di.sl<HomeViewTabCubit>(),
        ),
        BlocProvider<ProfileViewTabCubit>(
          create: (_) => di.sl<ProfileViewTabCubit>(),
        ),
        BlocProvider<SearchViewTabCubit>(
          create: (_) => di.sl<SearchViewTabCubit>(),
        ),
        BlocProvider<LikeDislikeFollowUnfollowFeatursCubit>(
          create: (_) => di.sl<LikeDislikeFollowUnfollowFeatursCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      title: 'Fluter FireBase Auth',
      home: const SplashScreen(), //const HomeView()
    );
  }
}
