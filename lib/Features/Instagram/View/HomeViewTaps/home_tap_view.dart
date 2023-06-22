import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/home_tap_view_app_bar.dart';

 import '../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import '../Widgets/HomeTapViewWidgets/home_tap_view_body.dart';

class HomeTapView extends StatelessWidget {
  const HomeTapView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
