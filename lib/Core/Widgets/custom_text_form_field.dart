import 'package:flutter/material.dart';

import '../Utils/Constants/color_constants.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final bool isPasswordField;
  bool isPasswordVisible = false;
  final Function onSave;
  final Function validator;
  final Function? toggelPasswordFunction;
  final FocusNode? focusNode;

  CustomTextFormField(
      {super.key,
      this.hint,
      required this.controller,
      required this.isPasswordField,
      this.isPasswordVisible = false,
      required this.onSave,
      required this.validator,
      this.toggelPasswordFunction,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: (isPasswordField) ? !isPasswordVisible : false,
      validator: (value) => validator(value),
      focusNode: focusNode,
      onEditingComplete: () {
        // Move focus to next TextFormField widget
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.grayText),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.grayText),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.grayText),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black54,
          ),
          filled: true),
    );
  }
}
