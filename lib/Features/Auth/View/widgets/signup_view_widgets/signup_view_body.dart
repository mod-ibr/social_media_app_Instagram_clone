import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/Utils/Constants/color_constants.dart';
import '../../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../../Core/Widgets/custom_button.dart';
import '../../../../../Core/Widgets/custom_text_form_field.dart';
import '../../../Model/auth_model.dart';
import '../../../ViewModel/cubit/auth_cubit.dart';
import '../../loginView/login_view.dart';

// ignore: must_be_immutable
class SignUpViewBody extends StatefulWidget {
  final double width, height;
  bool isPasswordVisible = false;
  SignUpViewBody({super.key, required this.width, required this.height});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
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
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(height: widget.height * 0.15),
                _profileImage(widget.width, widget.height),
                SizedBox(height: widget.height * 0.05),
                _newAccountWidget(height: widget.height, width: widget.width),
              ],
            ),
          ),
          SizedBox(height: widget.height * 0.07),
          _logInButtonWidget(
              width: widget.width, height: widget.height, context: context),
        ],
      ),
    );
  }

  Widget _profileImage(double width, double height) {
    return Container(
      width: width * 0.5,
      height: width * 0.5,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(200),
      ),
      child: Image.asset('assets/images/default_profile.png'),
    );
  }

  Widget _logInButtonWidget(
      {required double width,
      required double height,
      required BuildContext context}) {
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
              child: const Text("Already have an account? "),
            ),
            GestureDetector(
              onTap: () {
                AnimatedNavigation().navigateAndRemoveUntil(
                    widget: const LogInView(), context: context);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Log in.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  _newAccountWidget({required double height, required double width}) {
    return _formWidget(
        width: width,
        context: context,
        emailController: _emailController,
        userNameController: _userNameController,
        passwordController: _passwordController,
        emailFocusNode: _emailFocusNode,
        passwordFocusNode: _passwordFocusNode,
        formKey: _formKey);
  }

  Widget _formWidget(
      {required BuildContext context,
      required double width,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required TextEditingController userNameController,
      required FocusNode emailFocusNode,
      required FocusNode passwordFocusNode,
      required GlobalKey<FormState> formKey}) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFormField(
              isPasswordField: false,
              controller: userNameController,
              hint: 'Name',
              onSave: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Name Can\'t be Empty';
                }
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              controller: emailController,
              isPasswordField: false,
              hint: 'Email',
              onSave: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email Can\'t be Empty';
                } else if (!value!.toString().contains('@') ||
                    value!.length < 12 ||
                    value!.length > 35) {
                  return 'Invalid Email';
                }
              },
            ),
            const SizedBox(height: 15),
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
                  hint: 'Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password Can\'t be Empty';
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: 'Signup',
              color: (emailController.text.isEmpty ||
                      userNameController.text.isEmpty ||
                      passwordController.text.isEmpty)
                  ? ColorConstants.buttonDisableColor
                  : ColorConstants.buttonColor,
              onPress: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState?.save();
                  final authEntity = AuthModel(
                    userName: userNameController.text,
                    email: emailController.text,
                  );

                  BlocProvider.of<AuthCubit>(context).createAccount(
                      authEntity: authEntity,
                      password: passwordController.text);
                }
              },
              tcolor: (emailController.text.isEmpty ||
                      userNameController.text.isEmpty ||
                      passwordController.text.isEmpty)
                  ? Colors.white70
                  : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
