import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Auth/View/widgets/splash_view_widgets/splash_view_body.dart';
import '../../../../Core/Utils/Constants/k_constants.dart';
import '../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../ViewModel/cubit/auth_cubit.dart';
import '../../../home_view_or_auth_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<AuthCubit>(context).goToHomeViewOrLogInView();
    });

    Timer(const Duration(seconds: KConstants.kSplashScreenDurationInSecond),
        () {
      AnimatedNavigation().navigateAndRemoveUntil(
          widget: const HomeViewOrAuthView(), context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SplashViewWBody(
      width: width,
      height: height,
    ));
  }
}
