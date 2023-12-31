import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/posts.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/story.dart';

import '../../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import 'add_post_story_reel_live_list.dart';
import 'drop_down_button_list.dart';

class HomeTapViewBody extends StatelessWidget {
  final double width, height;
  const HomeTapViewBody({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: _homeViewBody(),
        ),
        ..._dropDownLists(context)
      ],
    );
  }

  Widget _homeViewBody() {
    return Column(
      children: [Story(), const Posts()],
    );
  }

  List<Widget> _dropDownLists(BuildContext context) {
    return [
      (BlocProvider.of<HomeViewTabCubit>(context).showDropdownList)
          ? CustomDropDownButtonList(width: width)
          : const SizedBox(),
      (BlocProvider.of<HomeViewTabCubit>(context).showAddPostStoryReelLiveList)
          ? AddPostStoryReelLiveList(width: width)
          : const SizedBox(),
    ];
  }
}
