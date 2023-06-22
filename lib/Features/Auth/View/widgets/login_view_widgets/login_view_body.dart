import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/Core/Widgets/custom_button_social_and_logo.dart';

import '../../../../../Core/Utils/Constants/color_constants.dart';
import '../../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../Model/auth_model.dart';
import '../../../ViewModel/cubit/auth_cubit.dart';
import '../../signUpView/signup_view.dart';
import '../../../../../Core/Widgets/custom_button.dart';

import '../../../../../Core/Widgets/custom_text_form_field.dart';

// ignore: must_be_immutable
class LogInViewBody extends StatefulWidget {
  final double width, height;
  LogInViewBody({super.key, required this.width, required this.height});
  bool isPasswordVisible = false;
  @override
  State<LogInViewBody> createState() => _LogInViewBodyState();
}

class _LogInViewBodyState extends State<LogInViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _formWidget(
        width: width,
        height: height,
        context: context,
        emailController: _emailController,
        passwordController: _passwordController,
        emailFocusNode: _emailFocusNode,
        passwordFocusNode: _passwordFocusNode,
        formKey: _formKey);
  }

  Widget _formWidget(
      {required BuildContext context,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required FocusNode emailFocusNode,
      required FocusNode passwordFocusNode,
      required GlobalKey<FormState> formKey,
      required double width,
      required double height}) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    _logoWidget(width, height),
                    _textFieldsWidgets(
                        width: width,
                        height: height,
                        emailController: emailController,
                        passwordController: passwordController),
                    //login button
                    _logInButtonsWidgets(
                        width: width,
                        height: height,
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey),
                  ],
                ),
              ),
              SizedBox(height: height * 0.09),
              //dont have and account ? signup
              _signUpButtonWidget(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoWidget(width, height) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.15,
        ),
        //app logo
        SvgPicture.asset(
          'assets/images/instagram.svg',
          color: ColorConstants.instagramTextLogo,
          height: width * 0.23,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _textFieldsWidgets(
      {required double width,
      required double height,
      required TextEditingController emailController,
      required TextEditingController passwordController}) {
    return Column(
      children: [
        //username text input
        CustomTextFormField(
          focusNode: _emailFocusNode,
          onSave: (value) {},
          controller: emailController,
          isPasswordField: false,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email Can\'t be Empty';
            } else if (value.length > 100) {
              return 'Too Long Email';
            }
          },
          hint: 'enter your email id',
        ),

        const SizedBox(
          height: 15,
        ),
        //password text input

        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ShowPasswordState) {
              widget.isPasswordVisible = state.isPasswordVisible;
            } else if (state is HidePasswordState) {
              widget.isPasswordVisible = state.isPasswordVisible;
            }
          },
          builder: (context, state) {
            return CustomTextFormField(
              onSave: (value) {},
              controller: passwordController,
              toggelPasswordFunction: () {
                BlocProvider.of<AuthCubit>(context).toggelPassword();
              },
              isPasswordVisible: widget.isPasswordVisible,
              isPasswordField: true,
              focusNode: _passwordFocusNode,
              hint: 'enter your password',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password Can\'t be Empty';
                }
              },
            );
          },
        ),

        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _orWidget(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logInButtonsWidgets({
    required double width,
    required double height,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return Column(
      children: [
        CustomButton(
          text: 'login',
          color:
              (emailController.text.isEmpty || passwordController.text.isEmpty)
                  ? ColorConstants.buttonDisableColor
                  : ColorConstants.buttonColor,
          tcolor:
              (emailController.text.isEmpty || passwordController.text.isEmpty)
                  ? Colors.white70
                  : Colors.white,
          onPress: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState?.save();

              final authEntity = AuthModel(
                email: emailController.text,
              );

              BlocProvider.of<AuthCubit>(context).emailAndPasswordLogIn(
                  authEntity: authEntity, password: passwordController.text);
            }
          },
        ),
        _orWidget(width, height),
        CustomButtonSocial(
          text: 'Continue with Google',
          imageName: 'google.png',
          onPress: () {
            BlocProvider.of<AuthCubit>(context).googleLogIn();
          },
          bckcolor: Colors.white,
          tColor: Colors.black,
        ),
        const SizedBox(height: 15),
        CustomButtonSocial(
          onPress: () {
            BlocProvider.of<AuthCubit>(context).faceBookLogIn();
          },
          bckcolor: Colors.blue[600]!,
          tColor: Colors.white,
          imageName: 'facebook.png',
          text: 'Continue with Facebook',
        ),
      ],
    );
  }

  Widget _signUpButtonWidget(double width, double height) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
          color: ColorConstants.grayText,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text("Don't have an account? "),
            ),
            GestureDetector(
              onTap: () {
                AnimatedNavigation().navigateAndRemoveUntil(
                    widget: const SignUpView(), context: context);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue[900]),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
