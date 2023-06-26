import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Core/Utils/Functions/animated_navigation.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/add_post_page.dart';
import 'package:instagram/Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

import '../../../../../Core/Utils/Functions/pick_image_from_gallery.dart';
import '../../../../../Core/Widgets/custom_bottom_sheet.dart';
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
                print('Add Post from Home View Tap');

                showBottomSheet(context);
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

  void showBottomSheet(BuildContext context) {
    // Disable any opend drop down list
    BlocProvider.of<HomeViewTabCubit>(context).disableAllDropDownLists();
    // Show bottom sheet to select image from Gallery or Camera
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          header: 'Upload Photo',
          buttons: [
            bootomSheetButton(
                title: 'From Gallery',
                onTap: () {
                  print('Upload Photo From Gallery');
                  _bickImage(context, source: ImageSource.gallery);
                }),
            bootomSheetButton(
              title: 'From Camera',
              onTap: () {
                print('Upload Photo From Camera');
                _bickImage(context, source: ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Widget bootomSheetButton(
      {required VoidCallback onTap,
      required String title,
      Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        child: CustomText(
          text: title,
          color: textColor,
        ),
      ),
    );
  }

  Future<void> _bickImage(context, {required ImageSource source}) async {
    await PickImage()
        .pickImageFromGalleryOrCamera(source: source)
        .then((value) {
      if (value.path.isNotEmpty) {
        print('Image File : ${value.path}');
        //Take the image file and pass it to add post page
        AnimatedNavigation().navigateAndPush(
            widget: AddPostPage(imageFile: value), context: context);
      } else if (value.path.isEmpty) {
        print('No Picked Image');
      }

      // Navigator.of(context).pop(); // Dismiss the bottom sheet
    });
  }
}
