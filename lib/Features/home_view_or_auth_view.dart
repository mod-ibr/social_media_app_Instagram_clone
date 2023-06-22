import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/View/home_view.dart';

import '../Core/Utils/Functions/animated_navigation.dart';
import '../Core/Widgets/loading_widget.dart';
import 'Auth/ViewModel/cubit/auth_cubit.dart';
import 'Auth/View/loginView/login_view.dart';

class HomeViewOrAuthView extends StatelessWidget {
  const HomeViewOrAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LoadingAuthState) {
          return const LoadingWidget();
        } else if (state is LoggedInState) {
          // Schedule navigation to occur after the widget tree has finished building
          Future.delayed(
            Duration.zero,
            () {
              AnimatedNavigation().navigateAndRemoveUntil(
                  widget: const HomeView(), context: context);
            },
          );
        } else if (state is NotLoggedInState) {
          // Schedule navigation to occur after the widget tree has finished building
          Future.delayed(Duration.zero, () {
            AnimatedNavigation().navigateAndRemoveUntil(
                widget: const LogInView(), context: context);
          });
        }
        return const LoadingWidget();
      },
    );
  }
}
