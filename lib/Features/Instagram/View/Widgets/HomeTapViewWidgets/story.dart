import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Widgets/user_avatar.dart';

import '../../../../../Core/Utils/Constants/color_constants.dart';
import '../../../../../Core/Widgets/custom_text.dart';
import '../../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

class Story extends StatelessWidget {
  Story({super.key});
  final double circleAvatarRadius = 30;
  final LinearGradient linearGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
    stops: const [0.2, 0.4, 1.0, 0.8, 0.8, 0.4, 0.2],
    colors: ColorConstants.statusColorGradient,
  );
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<HomeViewTabCubit, HomeViewTabState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 100,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _accountOwnerAvater(
                    width: width,
                    height: height,
                    onTap: () {
                      print('Add Story Avatar button pressed');
                    });
              }
              return Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: _usersAvatar(width, height),
              );
            },
          ),
        );
      },
    );
  }

  Widget _accountOwnerAvater(
      {required double width,
      required double height,
      required Function onTap}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: () => onTap(),
              child: CircleAvatar(
                backgroundColor: const Color(0xffdbdbdb),
                radius: circleAvatarRadius,
                child: const Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 40,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: CustomText(
              text: "Your Story",
              color: ColorConstants.instagramTextLogo,
              fontSize: 13),
        ),
      ],
    );
  }

  Widget _usersAvatar(double width, double height) {
    return Column(
      children: [
        UserAvatar(
            profileImageUrl: '',
            iconSize: 40,
            innerRadius: circleAvatarRadius,
            outerRadius: circleAvatarRadius * 1.05),
        const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: CustomText(
              text: "Mahmoud Ibr",
              fontSize: 13,
              color: ColorConstants.instagramTextLogo),
        )
      ],
    );
  }
}
