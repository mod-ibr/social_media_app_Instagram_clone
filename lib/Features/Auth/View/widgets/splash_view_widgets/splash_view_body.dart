import 'package:flutter/material.dart';
import 'package:instagram/Core/Utils/Constants/color_constants.dart';

class SplashViewWBody extends StatelessWidget {
  final double width, height;

  const SplashViewWBody({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered logo
          Container(
            padding: EdgeInsets.only(top: width * 0.70),
            child: Image.asset(
              'assets/images/instagram_logo.png',
              width: width * 0.32,
            ),
          ),
          // Bottom text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'from',
                  style: TextStyle(
                    color: ColorConstants.grayText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: width * 0.1),
                  child: Image.asset(
                    'assets/images/instagram_meta-logo.png',
                    width: width * 0.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
