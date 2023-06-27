import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Utils/Constants/color_constants.dart';

class UserAvatar extends StatelessWidget {
  final String? profileImageUrl;

  UserAvatar(
      {super.key,
      required this.profileImageUrl,
      required this.iconSize,
      required this.outerRadius,
      required this.innerRadius});
  final LinearGradient linearGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
    stops: const [0.2, 0.4, 1.0, 0.8, 0.8, 0.4, 0.2],
    colors: ColorConstants.statusColorGradient,
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
            child: ClipOval(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                imageUrl: profileImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) {
                  if (url.isEmpty) {
                    return const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.white,
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
