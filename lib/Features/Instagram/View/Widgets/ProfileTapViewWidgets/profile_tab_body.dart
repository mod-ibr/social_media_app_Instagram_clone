import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Errors/failures.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Core/Widgets/loading_widget.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/edit_profile_page.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/show_post_page.dart';
import 'package:instagram/Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import 'package:instagram/Features/Instagram/ViewModel/ProfileViewtabModelView/profile_view_tab_cubit.dart'
    as profile;

import '../../../../../Core/Utils/Functions/animated_navigation.dart';

class ProfileTabViewBody extends StatefulWidget {
  final String? userId;
  const ProfileTabViewBody({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileTabViewBody> createState() => _ProfileTabViewBodyState();
}

class _ProfileTabViewBodyState extends State<ProfileTabViewBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<PostModel> posts;
  @override
  void initState() {
    print('From Profile bode initstate with uid : ${widget.userId} ');
    BlocProvider.of<profile.ProfileViewTabCubit>(context)
        .getUserDataById(uid: widget.userId);
    BlocProvider.of<HomeViewTabCubit>(context).getUserPosts(uid: widget.userId);
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<profile.ProfileViewTabCubit,
            profile.ProfileViewTabState>(
          builder: (context, state) {
            if (state is profile.LoadingGetUserDataState) {
              return const LoadingWidget();
            } else if (state is profile.ErrorGetUserDataState) {
              String failureMessage =
                  BlocProvider.of<profile.ProfileViewTabCubit>(context)
                      .mapFailureToMessage(state.failure);

              if (state.failure is NoSavedUserFailure) {
                return failureWidget(text: failureMessage, icon: Icons.close);
              } else if (state.failure is ServerFailure) {
                return failureWidget(
                    text: failureMessage,
                    icon: Icons.miscellaneous_services_rounded);
              } else if (state.failure is OfflineFailure) {
                return failureWidget(
                    text: failureMessage, icon: Icons.wifi_off_outlined);
              }
            } else if (state is profile.SucceededGetUserDataState) {
              return succeddedWidget(size: size, userData: state.userData);
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }

  Widget failureWidget({required String text, required IconData icon}) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            fontSize: 50,
            color: Colors.red,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 20),
          Icon(
            icon,
            color: Colors.red,
            size: 100,
          ),
        ],
      ),
    );
  }

  Widget succeddedWidget({required Size size, required AuthModel userData}) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: 300,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // User name Bar
                _usernameBar(userName: userData.userName!),
                // profile image and account detailes bar
                _profileDetailes(
                    imgUrl: userData.profileImgUrl!,
                    name: userData.name!,
                    nFollowers: userData.nFollowers!,
                    nFollowing: userData.nFollowing!,
                    nPosts: userData.nPosts!),
                // Bio Bar
                _bio(bio: userData.bio!),
                // eddite profile bar
                _edditingProfileBar(size),
                // stories and add story bar
                _addingStoryBar(size),
              ],
            ),
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on_sharp)),
                Tab(icon: Icon(Icons.play_arrow_outlined)),
                Tab(icon: Icon(Icons.person_pin_outlined)),
              ],
              controller: _tabController,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          //Posts tab
          _postsTab(size),
          // shorts tab
          Container(
            height: 1000,
          ),
          // mention tab
          Container(
            height: 1000,
          ),
        ],
      ),
    );
  }

  Widget _usernameBar({required String userName}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (widget.userId != null)
                  ? IconButton(
                      onPressed: () {
                        AnimatedNavigation().navigateAndPop(context: context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                      ),
                      color: Colors.black,
                    )
                  : const SizedBox(),
              const Icon(
                Icons.lock_outline,
                color: Colors.black,
                size: 25,
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: userName,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                maxLine: 1,
              ),
              const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.black,
                size: 20,
              )
            ],
          ),
          Row(
            children: [
              (widget.userId != null)
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_box_outlined,
                        size: 25,
                      ),
                      color: Colors.black,
                    ),
              const SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu_outlined,
                  size: 25,
                ),
                color: Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _profileDetailes({
    required String imgUrl,
    required String name,
    required String nFollowers,
    required String nFollowing,
    required int nPosts,
  }) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xffdbdbdb),
                child: CircleAvatar(
                  radius: 37,
                  backgroundColor: const Color(0xfff8f7f1),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffdbdbdb),
                    radius: 35,
                    child: ClipOval(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
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
                          Icons.person_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: CustomText(
                  text: name,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: nPosts.toString(),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    const CustomText(text: "Posts", fontSize: 15)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: nFollowers,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    const CustomText(
                      text: "Followers",
                      fontSize: 15,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: nFollowing,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    const CustomText(
                      text: "Following",
                      fontSize: 15,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _bio({required String bio}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
      child: CustomText(
        color: Colors.black,
        fontSize: 15,
        text: bio,
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _edditingProfileBar(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: size.width,
        height: 30,
        child: Row(
          children: [
            (widget.userId != null)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor:
                              const Color(0xffefefef), // background
                        ),
                        onPressed: () {
                          // TODO : Follow a User
                        },
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                alignment: Alignment.center,
                                text: "Follow",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.person_add_alt,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffefefef), // background
                      ),
                      onPressed: () {
                        AnimatedNavigation().navigateAndPush(
                            widget: const EditProfilePage(), context: context);
                      },
                      child: const CustomText(
                        alignment: Alignment.center,
                        text: "Edit profile",
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _addingStoryBar(Size size) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 15.0,
      ),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff8f8f8f),
                  radius: 23,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22,
                    child: Icon(
                      Icons.add,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CustomText(
                    text: "New",
                    fontSize: 11,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xffdbdbdb),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xfff8f7f1),
                    child: CircleAvatar(
                      backgroundColor: Color(0xffdbdbdb),
                      radius: 22,
                      child: Icon(
                        Icons.person_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: CustomText(
                    text: "HighLight",
                    fontSize: 11,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _postsTab(Size size) {
    return BlocBuilder<HomeViewTabCubit, HomeViewTabState>(
      builder: (context, state) {
        if (state is LoadingGetPostsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorGetPostsState) {
          return failureWidget(
              text: state.message, icon: Icons.image_not_supported_outlined);
        } else if (state is SucceededGetPostsState) {
          posts = state.posts;
          return _customGridView(posts, size);
        }
        return _customGridView(posts, size);
      },
    );
  }

  Widget _customGridView(List<PostModel> posts, size) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns in the grid
        crossAxisSpacing: 3, // Spacing between columns
        mainAxisSpacing: 3, // Spacing between rows
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        // Access the post at the current index
        PostModel post = posts[index];

        return GestureDetector(
          onTap: () => AnimatedNavigation().navigateAndPush(
              widget: ShowPostPage(postModle: post), context: context),
          child: SizedBox(
            width: size.width,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: post.imageURL,
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
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
