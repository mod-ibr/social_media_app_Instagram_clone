import 'package:flutter/material.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/post_card.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: PostCard(),
              );
            },
          ),
        ),
      ],
    );
  }
}
