import 'package:flutter/material.dart';

import '../../../../Core/Utils/Constants/color_constants.dart';
import '../widgets/login_view_widgets/login_view_body.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstants.backGroundColor1,
      body: LogInViewBody(width: width, height: height),
    );
  }
}
