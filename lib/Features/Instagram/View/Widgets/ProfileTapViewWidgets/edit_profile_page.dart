import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Core/Utils/Functions/pick_image_from_gallery.dart';

import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Instagram/View/Widgets/ProfileTapViewWidgets/picked_image_page.dart';
import 'package:instagram/Features/Instagram/View/home_view.dart';

import '../../../../../Core/Errors/failures.dart';
import '../../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../../Core/Widgets/custom_bottom_sheet.dart';
import '../../../../../Core/Widgets/loading_widget.dart';
import '../../../../Auth/Model/auth_model.dart';
import '../../../ViewModel/ProfileViewtabModelView/profile_view_tab_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _nameFocusNode;
  late FocusNode _usernameFocusNode;
  late FocusNode _bioFocusNode;
  late AuthModel userData;

  @override
  void initState() {
    BlocProvider.of<ProfileViewTabCubit>(context).getUserDataById();
    print('*********************************');
    super.initState();
    _nameFocusNode = FocusNode();
    _bioFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _bioFocusNode.dispose();
    _usernameFocusNode.dispose();
    _nameFocusNode.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _nameController.text = BlocProvider.of<ProfileViewTabCubit>(context).name;

    _userNameController.text =
        BlocProvider.of<ProfileViewTabCubit>(context).userName;

    _bioController.text = BlocProvider.of<ProfileViewTabCubit>(context).bio;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: BlocConsumer<ProfileViewTabCubit, ProfileViewTabState>(
        listener: (context, state) {
          if (state is SucceededUpdateUserDataState) {
            AnimatedNavigation().navigateAndRemoveUntil(
                widget:
                    const HomeView(customPage: KConstants.kProfilePageNumber),
                context: context);
          }
        },
        builder: (context, state) {
          if (state is LoadingGetUserDataState ||
              state is LoadingUpdateUserDataState) {
            return const LoadingWidget();
          } else if (state is ErrorGetUserDataState) {
            String failureMessage =
                BlocProvider.of<ProfileViewTabCubit>(context)
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
          } else if (state is ErrorUpdateUserDataState) {
            String failureMessage =
                BlocProvider.of<ProfileViewTabCubit>(context)
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
          } else if (state is SucceededGetUserDataState) {
            return succeddedWidget(
                height: height, width: width, userData: state.userData);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const CustomText(
        text: 'Edit Profile',
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      leading: IconButton(
        onPressed: () {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget: const HomeView(customPage: KConstants.kProfilePageNumber),
              context: context);
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
            onPressed: () async {
              print('Save updates');
              await _updateUserData();
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

  Widget _changeImageWidget({
    required double width,
    required double height,
    required BuildContext context,
    required String img_url,
  }) {
    return SizedBox(
      height: height * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Image
          CircleAvatar(
            radius: width * 0.18,
            backgroundColor: const Color(0xffdbdbdb),
            child: CircleAvatar(
              radius: width * 0.175,
              backgroundColor: const Color(0xfff8f7f1),
              child: CircleAvatar(
                backgroundColor: const Color(0xffdbdbdb),
                radius: width * 0.165,
                child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    imageUrl: img_url,
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
          // change image Button
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: width * 0.6, // Adjust the width as needed
            child: GestureDetector(
              onTap: () {
                showBottomSheet(context);
                print('Change profile Image');
              },
              child: const CustomText(
                alignment: Alignment.center,
                text: 'Change Profile Photo',
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(
      {required String label,
      required TextEditingController controller,
      required FocusNode focusNode,
      required Function onChange}) {
    return TextFormField(
      onChanged: (val) => onChange(val),
      controller: controller,
      onEditingComplete: () {
        // Move focus to next TextFormField widget
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _updateDataForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            customTextField(
              label: 'Name',
              controller: _nameController,
              focusNode: _nameFocusNode,
              onChange: (val) {
                print("Name Data From Text Filed : ${_nameController.text}");
                BlocProvider.of<ProfileViewTabCubit>(context).name =
                    _nameController.text;
              },
            ),
            const SizedBox(height: 10),
            customTextField(
              label: 'Username',
              controller: _userNameController,
              focusNode: _usernameFocusNode,
              onChange: (val) {
                print(
                    "username Data From Text Filed : ${_userNameController.text}");

                BlocProvider.of<ProfileViewTabCubit>(context).userName =
                    _userNameController.text;
              },
            ),
            const SizedBox(height: 10),
            customTextField(
              label: 'Bio',
              controller: _bioController,
              focusNode: _bioFocusNode,
              onChange: (val) {
                print("Bio Data From Text Filed : ${_bioController.text}");

                BlocProvider.of<ProfileViewTabCubit>(context).bio =
                    _bioController.text;
              },
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
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
                  _bickImage(source: ImageSource.gallery);
                }),
            bootomSheetButton(
              title: 'From Camera',
              onTap: () {
                print('Upload Photo From Camera');
                _bickImage(source: ImageSource.camera);
              },
            ),
            bootomSheetButton(
              title: 'Remove profile Photo',
              textColor: Colors.red,
              onTap: () {
                // TODO: Remove profile photo
                print('Remove profile photo');
                Navigator.of(context).pop(); // Dismiss the bottom sheet
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
          backgroundColor:
              Colors.white, // Set the button's background color to red
        ),
        child: CustomText(
          text: title,
          color: textColor,
        ),
      ),
    );
  }

  Future<void> _bickImage({required ImageSource source}) async {
    await PickImage()
        .pickImageFromGalleryOrCamera(source: source)
        .then((value) {
      if (value.path.isNotEmpty) {
        print('Image File : ${value.path}');
        AnimatedNavigation().navigateAndPush(
            widget: PickedimagePage(imageFile: value), context: context);
      } else if (value.path.isEmpty) {
        print('No Picked Image');
      }

      // Navigator.of(context).pop(); // Dismiss the bottom sheet
    });
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
              text: text,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Icon(
              icon,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget succeddedWidget(
      {required double width,
      required double height,
      required AuthModel userData}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Change Image Container
            _changeImageWidget(
                width: width,
                height: height,
                context: context,
                img_url: userData.profileImgUrl!),
            // Update data Form
            _updateDataForm(),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    await BlocProvider.of<ProfileViewTabCubit>(context).updateUserData(
        name: _nameController.text,
        userName: _userNameController.text,
        bio: _bioController.text);
    print('User data Updated Successfully');
  }
}
