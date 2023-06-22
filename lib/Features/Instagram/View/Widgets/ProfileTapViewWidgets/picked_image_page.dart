import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Widgets/loading_widget.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/edit_profile_page.dart';
import 'package:instagram/Features/Instagram/ViewModel/ProfileViewtabModelView/profile_view_tab_cubit.dart';
import '../../../../../Core/Errors/failures.dart';
import '../../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../../Core/Widgets/custom_text.dart';

class PickedimagePage extends StatelessWidget {
  const PickedimagePage({super.key, required this.imageFile});
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: pickedimagePageBody(
        imageFile: imageFile,
        height: height,
        width: width,
        context: context,
      ),
    );
  }

  PreferredSizeWidget _appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const CustomText(
        text: 'Edit Photo',
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      leading: IconButton(
        onPressed: () {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget: const EditProfilePage(), context: context);
        },
        icon: Icon(
          Icons.close,
          color: Colors.grey[600],
          size: 35,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              BlocProvider.of<ProfileViewTabCubit>(context)
                  .uploadProfileImage(imageFile: imageFile);
              print('Save updates');
            },
            icon: const Icon(
              Icons.check,
              color: Colors.blue,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget pickedimagePageBody(
      {required File imageFile,
      required double width,
      required double height,
      required BuildContext context}) {
    return BlocConsumer<ProfileViewTabCubit, ProfileViewTabState>(
      listener: (context, state) {
        if (state is SucceededUploadedUserProfileImg) {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget: const EditProfilePage(), context: context);
        }
      },
      builder: (context, state) {
        if (state is LoadingUpdateUserDataState) {
          return const LoadingWidget();
        } else if (state is ErrorUpdateUserDataState) {
          String failureMessage = BlocProvider.of<ProfileViewTabCubit>(context)
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
        }
        return SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile Image
              CircleAvatar(
                radius: width * 0.45,
                backgroundColor: const Color(0xffdbdbdb),
                child: CircleAvatar(
                  radius: width * 0.435,
                  backgroundColor: const Color(0xfff8f7f1),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffdbdbdb),
                    radius: width * 0.43,
                    backgroundImage: FileImage(imageFile),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ProfileViewTabCubit>(context)
                      .uploadProfileImage(imageFile: imageFile);
                  print('Save updates');
                  // Handle save changes button press
                  // Perform desired operations
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget failureWidget({required String text, required IconData icon}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            color: Colors.red,
          ),
          Icon(
            icon,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
