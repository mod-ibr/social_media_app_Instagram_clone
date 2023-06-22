import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AnimatedNavigation {
  void navigateAndRemoveUntil(
      {required Widget widget, required BuildContext context}) {
    Navigator.of(context).pushAndRemoveUntil(
      PageTransition(
        type: PageTransitionType.topToBottom,
        child: widget,
      ),
      (route) => false,
    );
  }

  void navigateAndPush(
      {required Widget widget, required BuildContext context}) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.topToBottom,
        child: widget,
      ),
    );
  }

  void navigateAndPop({required BuildContext context}) {
    Navigator.of(context).pop();
  }
}
