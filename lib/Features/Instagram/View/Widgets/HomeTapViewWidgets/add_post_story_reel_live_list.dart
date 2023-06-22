import 'package:flutter/material.dart';

import '../../../../../Core/Widgets/custom_text.dart';

class AddPostStoryReelLiveList extends StatelessWidget {
  final double width;

  const AddPostStoryReelLiveList({Key? key, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 28,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _listItem(
              width: width,
              title: 'Post',
              icon: Icons.grid_on_sharp,
              onTap: () {
                print('Post Button From Add Post Story Reel Live Button');
              },
            ),
            _customeDivider(),
            _listItem(
              width: width,
              title: 'Story',
              icon: Icons.add_circle_outline_rounded,
              onTap: () {
                print('Story Button From Add Post Story Reel Live Button');
              },
            ),
            _customeDivider(),
            _listItem(
              width: width,
              title: 'Reel',
              icon: Icons.video_collection_outlined,
              onTap: () {
                print('Reel Button From Add Post Story Reel Live Button');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem(
      {required double width,
      required String title,
      required IconData icon,
      required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        width: width * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontSize: width * 0.055,
            ),
            Icon(
              icon,
              size: width * 0.08,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customeDivider() {
    return Container(
      alignment: Alignment.center,
      width: width * 0.35,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.grey[300]!,
        ),
      ),
    );
  }
}
