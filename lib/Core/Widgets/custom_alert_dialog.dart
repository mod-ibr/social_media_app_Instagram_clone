import 'package:flutter/material.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';

class CustomAlertDialog extends StatelessWidget {
  final String header;
  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;

  const CustomAlertDialog({
    super.key,
    required this.header,
    this.onOkPressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: CustomText(
        text: header,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // Additional content can be added here
        ],
      ),
      actions: [
        TextButton(
          onPressed: onOkPressed,
          child: const CustomText(
            text: 'Ok',
          ),
        ),
        TextButton(
          onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
          child: const CustomText(
            text: 'Cancel',
          ),
        ),
      ],
    );
  }
}



/* How to use  */
/*
 void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IOSAlertDialog(
          header: 'Alert',
          onOkPressed: () {
            // Handle OK button press
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          onCancelPressed: () {
            // Handle Cancel button press
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        );
      },
    );
  }
 */