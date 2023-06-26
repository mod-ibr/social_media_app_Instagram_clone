import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/post_card.dart';
import 'package:instagram/Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

import '../../../../../Core/Widgets/custom_text.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<PostModle> posts = [];

  @override
  void initState() {
    BlocProvider.of<HomeViewTabCubit>(context).getPostsOrderedByTimeStamp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewTabCubit, HomeViewTabState>(
      builder: (context, state) {
        if (state is LoadingGetPostsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorGetPostsState) {
          return failureWidget(
              text: state.message, icon: Icons.image_not_supported_outlined);
        } else if (state is SucceededGetPostsState) {
          posts = state.posts;
          return _postCard(posts: state.posts);
        }
        return _postCard(posts: posts);
      },
    );
  }

  Widget _postCard({required List<PostModle> posts}) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: PostCard(post: posts[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget failureWidget({required String text, required IconData icon}) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              alignment: Alignment.center,
              text: text,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Icon(
              icon,
              size: 30,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
