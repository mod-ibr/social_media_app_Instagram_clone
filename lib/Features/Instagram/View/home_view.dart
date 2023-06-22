import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Core/Utils/Constants/color_constants.dart';
import 'package:instagram/Features/Instagram/View/HomeViewTaps/home_tap_view.dart';
import 'package:instagram/Features/Instagram/View/HomeViewTaps/profile_tap_view.dart';
import 'package:instagram/Features/Instagram/View/HomeViewTaps/reels_tap_view.dart';
import 'package:instagram/Features/Instagram/View/HomeViewTaps/search_tap_view.dart';

import 'log_out.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.customPage});
  final int? customPage;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        initialPage: (widget.customPage != null) ? widget.customPage! : _page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationPageSelected(int page) {
    pageController.jumpToPage(page);
  }

  List<Widget> pagesView = [
    const LogOut(),
    const HomeTapView(),
    const SearchTapView(),
    const ReelsTapView(),
    const Center(child: Text('Store')),
    const ProfileTapView()
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavigationBarItemsList = [
      _bottomNavBar(
        sicon: Icons.logout,
        dicon: Icons.logout_outlined,
        pageNumber: 0,
      ),
      _bottomNavBar(
          sicon: CupertinoIcons.house_fill,
          dicon: CupertinoIcons.house,
          pageNumber: 1),
      _bottomNavBar(
        sicon: CupertinoIcons.search,
        dicon: Icons.search,
        pageNumber: 2,
      ),
      _bottomNavBar(
          sicon: CupertinoIcons.add_circled_solid,
          dicon: CupertinoIcons.add_circled,
          pageNumber: 3),
      _bottomNavBar(
          sicon: CupertinoIcons.bag_fill,
          dicon: CupertinoIcons.bag,
          pageNumber: 4),
      _bottomNavBar(
          sicon: CupertinoIcons.person_circle_fill,
          dicon: CupertinoIcons.person_circle,
          pageNumber: 5),
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backGroundColor1,
      body: _homeViewBody(),
      bottomNavigationBar: _bottomnavBaWidget(bottomNavigationBarItemsList),
    );
  }

  Widget _homeViewBody() {
    return PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: pagesView);
  }

  Widget _bottomnavBaWidget(
      List<BottomNavigationBarItem> bottomNavigationBarItemsList) {
    return CupertinoTabBar(
      backgroundColor: ColorConstants.backGroundColor1,
      items: bottomNavigationBarItemsList,
      onTap: navigationPageSelected,
    );
  }

  BottomNavigationBarItem _bottomNavBar({
    required IconData sicon,
    required IconData dicon,
    required int pageNumber,
  }) {
    return BottomNavigationBarItem(
      icon: _page == pageNumber
          ? Icon(
              sicon,
              color: ColorConstants.instagramTextLogo,
            )
          : Icon(
              dicon,
              color: ColorConstants.instagramTextLogo,
            ),
    );
  }
}
