import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Core/Utils/Constants/color_constants.dart';
import '../../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

class HomeTabViewAppBar extends StatelessWidget {
  final double width;
  const HomeTabViewAppBar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return //App Bar
        Padding(
      padding: const EdgeInsets.only(right: 8, top: 25, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //app logo
              SvgPicture.asset(
                'assets/images/instagram.svg',
                color: ColorConstants.instagramTextLogo,
                height: width * 0.13,
              ),

              // dropDown Button
              InkWell(
                child: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 25,
                ),
                onTap: () => BlocProvider.of<HomeViewTabCubit>(context)
                    .instaLogoDropDownButton(),
              )
            ],
          ),
          Row(
            children: [
              _appBarLeadingIconButton(
                  onTap: () {
                    print(' Add Post, Story Reel or Live  ');
                    BlocProvider.of<HomeViewTabCubit>(context)
                        .addPostStoryReelLiveButton();
                  },
                  icon: Icons.add_box_outlined,
                  context: context),
              const SizedBox(
                width: 5,
              ),
              _appBarLeadingIconButton(
                  onTap: () {
                    print(' Loves Buttons to show Notification Page ');
                  },
                  icon: Icons.favorite_border,
                  context: context),
              const SizedBox(
                width: 5,
              ),
              _appBarLeadingIconButton(
                  onTap: () {
                    print(' Loves Buttons to show Notification Page ');
                  },
                  icon: Icons.messenger_outline,
                  context: context),
            ],
          )
        ],
      ),
    );
  }

  Widget _appBarLeadingIconButton(
      {required Function onTap,
      required IconData icon,
      required BuildContext context}) {
    return IconButton(
      onPressed: () => onTap(),
      icon: Icon(
        icon,
        size: 35,
        color: Colors.black,
      ),
    );
  }
}
