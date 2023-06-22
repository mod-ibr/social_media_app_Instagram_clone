import 'package:flutter/material.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/profile_tab_body.dart';

class ProfileTapView extends StatelessWidget {
  final String? userId;
  const ProfileTapView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileTabViewBody(userId: userId),
    );
  }
}
