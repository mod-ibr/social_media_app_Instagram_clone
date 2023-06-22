import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../Core/Widgets/loading_widget.dart';
import '../../Auth/View/loginView/login_view.dart';
import '../../Auth/ViewModel/cubit/auth_cubit.dart';
import '../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SucceededAuthState) {
            AnimatedNavigation().navigateAndRemoveUntil(
                widget: const LogInView(), context: context);
          }
        },
        builder: (context, state) {
          if (state is LoadingAuthState) {
            return const LoadingWidget();
          }
          return BlocConsumer<HomeViewTabCubit, HomeViewTabState>(
            listener: (context, state) {
              // if (state is SucceededSearchByUserNameState) {
              //   print('################# ${state.users.length}');
              // } else if (state is ErrorSearchByUserNameState) {
              //   print('################# ${state.message}');
              // }
            },
            builder: (context, state) {
              // if (state is LoadingSearchByUserNameState) {
              //   return const Center(
              //     child: CircularProgressIndicator(
              //       color: Colors.red,
              //     ),
              //   );
              // }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).logOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 50),
                    IconButton(
                      onPressed: () {
                        // BlocProvider.of<HomeViewTabCubit>(context)
                        //     .getUserByUserName('%');
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
