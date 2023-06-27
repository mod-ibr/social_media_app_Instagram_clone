import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Core/Utils/Functions/animated_navigation.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Instagram/View/HomeViewTaps/profile_tap_view.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/show_post_page.dart';
import 'package:instagram/Features/Instagram/View/home_view.dart';
import 'package:instagram/Features/Instagram/ViewModel/SearchViewTabModelView/search_view_tab_cubit.dart';

import '../../../../../Core/Errors/failures.dart';
import '../../../../Auth/Model/auth_model.dart';
import '../../../Model/post_model.dart';
import '../../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

class SearchTabBody extends StatefulWidget {
  const SearchTabBody({Key? key}) : super(key: key);

  @override
  State<SearchTabBody> createState() => _SearchTabBodyState();
}

class _SearchTabBodyState extends State<SearchTabBody> {
  final List<String> images = [
    "https://imgflip.com/s/meme/Unpopular-Opinion-Puffin.jpg",
    "https://imgflip.com/s/meme/Grumpy-Cat.jpg",
    "https://imgflip.com/s/meme/Lazy-College-Senior.jpg",
    "https://imgflip.com/s/meme/Evil-Toddler.jpg",
    "https://imgflip.com/s/meme/College-Freshman.jpg",
    "https://imgflip.com/s/meme/confession-kid.jpg",
    "https://imgflip.com/s/meme/I-Should-Buy-A-Boat-Cat.jpg",
    "https://imgflip.com/s/meme/Unhelpful-High-School-Teacher.jpg",
    "https://imgflip.com/s/meme/Engineering-Professor.jpg",
    "https://imgflip.com/s/meme/Surprised-Koala.jpg",
    "https://imgflip.com/s/meme/Business-Cat.jpg",
    "https://imgflip.com/s/meme/Unpopular-Opinion-Puffin.jpg",
    "https://imgflip.com/s/meme/Grumpy-Cat.jpg",
    "https://imgflip.com/s/meme/Lazy-College-Senior.jpg",
    "https://imgflip.com/s/meme/Evil-Toddler.jpg",
    "https://imgflip.com/s/meme/College-Freshman.jpg",
    "https://imgflip.com/s/meme/confession-kid.jpg",
    "https://imgflip.com/s/meme/I-Should-Buy-A-Boat-Cat.jpg",
    "https://imgflip.com/s/meme/Unhelpful-High-School-Teacher.jpg",
    "https://imgflip.com/s/meme/Engineering-Professor.jpg",
    "https://imgflip.com/s/meme/Surprised-Koala.jpg",
    "https://imgflip.com/s/meme/Business-Cat.jpg",
  ];
  final TextEditingController _searchController = TextEditingController();
  List<AuthModel> users = [];
  List<PostModel> posts = [];

  @override
  void initState() {
    BlocProvider.of<HomeViewTabCubit>(context).getPostsOrderedByTimeStamp();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        _searchWidget(textEditingController: _searchController),
        Expanded(child: BlocBuilder<SearchViewTabCubit, SearchViewTabState>(
          builder: (context, state) {
            if (_searchController.text.isEmpty) {
              return _buildGridView();
            }
            // Loading Search
            else if (state is LoadingSearchState) {
              return const Center(child: CircularProgressIndicator());
            }
            // Error Search
            else if (state is ErrorSearchState) {
              String failureMessage =
                  BlocProvider.of<SearchViewTabCubit>(context)
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
              } else if (state.failure is EmptySearchFailure) {
                return failureWidget(
                    text: failureMessage, icon: Icons.search_off_outlined);
              }
            }
            // Succedded Search
            else if (state is SucceededSearchState) {
              return _usersListView(users: state.users, size: size);
            }
            return _buildGridView();
          },
        )),
      ],
    );
  }

  Widget _usersListView({required List<AuthModel> users, required Size size}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _userListTile(user: users[index], size: size);
        },
      ),
    );
  }

  Widget _item({required String imageUrl}) {
    return Card(
      elevation: 2,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
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
            child: const CircularProgressIndicator(),
          );
        },
        errorWidget: (context, url, error) => const Icon(
          Icons.person_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _searchWidget({required TextEditingController textEditingController}) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      height: 45,
      child: CupertinoSearchTextField(
        controller: textEditingController,
        onChanged: (String value) {
          BlocProvider.of<SearchViewTabCubit>(context)
              .getUserByUserNameOrName(userNameOrName: value);
          print('The text has changed to: $value');
        },
      ),
    );
  }

  Widget _buildGridView() {
    return BlocBuilder<HomeViewTabCubit, HomeViewTabState>(
      builder: (context, state) {
        if (state is LoadingGetPostsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorGetPostsState) {
          return failureWidget(
              text: state.message, icon: Icons.image_not_supported_outlined);
        } else if (state is SucceededGetPostsState) {
          posts = state.posts;
          return _gridViewWidget(posts: posts);
        }
        return _gridViewWidget(posts: posts);
      },
    );
  }

  Widget _gridViewWidget({required List<PostModel> posts}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () => AnimatedNavigation().navigateAndPush(
                widget: ShowPostPage(postModle: posts[index]),
                context: context),
            child: _item(imageUrl: posts[index].imageURL)),
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
        crossAxisSpacing: 0.0,
      ),
    );
  }

  Widget _userListTile({required AuthModel user, required Size size}) {
    return InkWell(
      onTap: () {
        bool isCurentUser = BlocProvider.of<SearchViewTabCubit>(context)
            .checkIsCurrentUser(user.userId!);
        if (isCurentUser) {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget: const HomeView(customPage: KConstants.kProfilePageNumber),
              context: context);
        } else {
          AnimatedNavigation().navigateAndPush(
              widget: ProfileTapView(userId: user.userId), context: context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        height: size.width * 0.21,
        child: Card(
          color: const Color.fromARGB(206, 255, 255, 255),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userCircleAvatar(imgUrl: user.profileImgUrl!, size: size),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomText(
                      alignment: Alignment.center,
                      text: user.name!,
                      maxLine: 1,
                      fontSize: size.width * 0.05,
                      textOverflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userCircleAvatar({required String imgUrl, required Size size}) {
    return CircleAvatar(
      radius: size.width * 0.1,
      backgroundColor: const Color(0xffdbdbdb),
      child: CircleAvatar(
        radius: size.width * 0.09,
        backgroundColor: const Color(0xfff8f7f1),
        child: CircleAvatar(
          backgroundColor: const Color(0xffdbdbdb),
          radius: size.width * 0.08,
          child: ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: imgUrl,
              fit: BoxFit.cover,
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
    );
  }

  Widget failureWidget({required String text, required IconData icon}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            maxLine: 2,
            text: text,
            fontSize: 25,
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
}
