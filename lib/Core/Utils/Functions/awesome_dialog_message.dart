import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AwesomeDialogMessage {
  Future showSuccessAwesomeDialog(
      {required String message, required BuildContext context}) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Done',
      desc: message,
      autoHide: const Duration(seconds: 2),
    ).show();
  }

  Future showErrorAwesomeDialog(
      {required String message, required BuildContext context}) {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: message,
            btnOkOnPress: () {},
            btnOkColor: Colors.red)
        .show();
  }
}/*

AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            body: Center(child: Text(
                    'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'This is Ignored',
            desc:   'This is also Ignored',
            btnOkOnPress: () {},
            )..show();
 */

