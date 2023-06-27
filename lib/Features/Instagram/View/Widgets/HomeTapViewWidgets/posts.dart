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
  List<PostModel> posts = [];

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

  Widget _postCard({required List<PostModel> posts}) {
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
    return SizedBox(
      width: double.infinity,
      height: 400,
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
}
