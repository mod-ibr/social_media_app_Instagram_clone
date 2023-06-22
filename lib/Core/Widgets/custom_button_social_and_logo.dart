import 'package:flutter/material.dart';

class CustomButtonSocial extends StatelessWidget {
  final String text;
  final String imageName;
  final Function onPress;
  final Color bckcolor;
  final Color tColor;

  const CustomButtonSocial({
    super.key,
    required this.text,
    required this.imageName,
    required this.onPress,
    required this.bckcolor,
    required this.tColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPress(),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 35),
        backgroundColor: bckcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/$imageName',
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: tColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomButtonLogo extends StatelessWidget {
  String imageName;
  final Function onPressed;
  final IconData? iconData;
  CustomButtonLogo({
    super.key,
    this.iconData,
    this.imageName = '',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.black12, width: 1),
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Container(
          width: width * 0.15,
          height: width * 0.15,
          padding: const EdgeInsets.all(12),
          child: (imageName.isNotEmpty)
              ? Image.asset(
                  imageName,
                  fit: BoxFit.contain,
                )
              : Icon(
                  iconData,
                  size: width * 0.08,
                ),
        ),
      ),
    );
  }
}
