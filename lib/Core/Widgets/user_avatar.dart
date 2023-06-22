import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {super.key,
      required this.iconSize,
      required this.outerRadius,
      required this.innerRadius});
  final LinearGradient linearGradient = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
    stops: [0.2, 0.4, 1.0, 0.8, 0.8, 0.4, 0.2],
    colors: [
      Color(0xFFF1B315),
      Color(0xFFF34249),
      Color(0xFFBE09A6),
      Color(0xFFCD4FBD),
      Color(0xFFF00D67),
      Color(0xFFF34249),
      Color(0xFFE38337),
    ],
  );
  final double iconSize, outerRadius, innerRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration:
          BoxDecoration(shape: BoxShape.circle, gradient: linearGradient),
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: outerRadius,
          child: CircleAvatar(
            backgroundColor: const Color(0xffdbdbdb),
            radius: innerRadius,
            child: Icon(
              Icons.person_rounded,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
