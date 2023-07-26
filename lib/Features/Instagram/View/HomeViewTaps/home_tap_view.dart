import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/home_tap_view_app_bar.dart';

import '../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../Core/Widgets/loading_widget.dart';
import '../../../Auth/View/loginView/login_view.dart';
import '../../../Auth/ViewModel/cubit/auth_cubit.dart';
import '../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import '../Widgets/HomeTapViewWidgets/home_tap_view_body.dart';

class HomeTapView extends StatelessWidget {
  const HomeTapView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is SucceededAuthState) {
        AnimatedNavigation().navigateAndRemoveUntil(
            widget: const LogInView(), context: context);
      }
    }, builder: (context, state) {
      if (state is LoadingAuthState) {
        return const LoadingWidget();
      }
      return BlocConsumer<HomeViewTabCubit, HomeViewTabState>(
        listener: (context, state) {},
        builder: (context, state) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => BlocProvider.of<HomeViewTabCubit>(context)
                .disableAllDropDownLists(),
            child: Scaffold(
              appBar: _appBar(width, height),
              body: HomeTapViewBody(width: width, height: height),
            ),
          );
        },
      );
    });
  }

  PreferredSizeWidget _appBar(width, height) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0.0,
      toolbarHeight: height * 0.10,
      title: HomeTabViewAppBar(width: width),
    );
  }
}
