import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Auth/ViewModel/cubit/auth_cubit.dart';
import 'package:instagram/Features/Instagram/View/home_view.dart';

import '../Utils/Constants/color_constants.dart';
import '../Utils/Functions/animated_navigation.dart';
import '../Utils/Functions/awesome_dialog_message.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color tcolor;
  final Function onPress;

  const CustomButton({
    super.key,
    required this.onPress,
    this.color = ColorConstants.buttonColor,
    this.tcolor = ColorConstants.instagramTextLogo,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(10),
      onPressed: () => onPress(),
      color: color,
      child: SizedBox(
        height: 30,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SucceededAuthState) {
              AwesomeDialogMessage()
                  .showSuccessAwesomeDialog(
                      message: 'logged in successfully', context: context)
                  .then((value) {
                AnimatedNavigation().navigateAndRemoveUntil(
                    widget: const HomeView(), context: context);
              });
            } else if (state is ErrorAuthState) {
              AwesomeDialogMessage().showErrorAwesomeDialog(
                  message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is LoadingAuthState) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (state is ErrorAuthState) {
              return CustomText(
                alignment: Alignment.center,
                text: text,
                color: tcolor,
              );
            }
            return CustomText(
              alignment: Alignment.center,
              text: text,
              color: tcolor,
            );
          },
        ),
      ),
    );
  }
}
