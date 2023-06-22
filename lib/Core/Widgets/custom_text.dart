import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Alignment alignment;
  final int? maxLine;
  final double height;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextOverflow? textOverflow;

  const CustomText(
      {super.key,
      this.text = '',
      this.fontSize = 16,
      this.color = Colors.black,
      this.alignment = Alignment.topLeft,
      this.fontWeight = FontWeight.normal,
      this.fontFamily = 'Ubuntu',
      this.maxLine,
      this.height = 1,
      this.textOverflow = TextOverflow.visible});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        overflow: textOverflow,
        style: TextStyle(
            fontWeight: fontWeight,
            color: color,
            height: height,
            fontSize: fontSize,
            fontFamily: fontFamily),
        maxLines: maxLine,
      ),
    );
  }
}
