import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Core/Utils/Functions/awesome_dialog_message.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Instagram/View/home_view.dart';
import 'package:instagram/Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';

import '../../../../../Core/Utils/Functions/animated_navigation.dart';
import '../../../../../Core/Widgets/loading_widget.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({
    super.key,
    required this.imageFile,
  });
  final File imageFile;
  final TextEditingController _captionController = TextEditingController();

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
        text: 'Add Post',
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      leading: IconButton(
        onPressed: () {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget:
                  const HomeView(customPage: KConstants.kHomeViewPageNumber),
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
            onPressed: () => post(context),
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
    return BlocConsumer<HomeViewTabCubit, HomeViewTabState>(
      listener: (context, state) {
        if (state is SucceededAddPostState) {
          AnimatedNavigation().navigateAndRemoveUntil(
              widget:
                  const HomeView(customPage: KConstants.kHomeViewPageNumber),
              context: context);
        }
      },
      builder: (context, state) {
        if (state is LoadingAddPostState) {
          return const LoadingWidget();
        } else if (state is ErrorAddPostState) {
          AwesomeDialogMessage()
              .showErrorAwesomeDialog(message: state.message, context: context);
        }
        return _postData(width, height, context);
      },
    );
  }

  Widget _postData(width, height, context) {
    return SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Post Image
            _imageContainer(imageFile),

            const SizedBox(height: 20),
            _captionTextFiled(),
            const SizedBox(height: 20),
            // post button
            _postButton(context)
          ],
        ),
      ),
    );
  }

  Widget _imageContainer(File imageFile) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: const Color.fromARGB(50, 255, 255, 255),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Image.file(imageFile),
        ),
      ),
    );
  }

  Widget _captionTextFiled() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _captionController,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          hintText: 'Write a caption...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }

  Widget _postButton(context) {
    return ElevatedButton(
      onPressed: () => post(context),
      child: const Text('Post'),
    );
  }

  void post(context) async {
    print(_captionController.text);
    BlocProvider.of<HomeViewTabCubit>(context)
        .addPost(imageFile: imageFile, description: _captionController.text);
  }
}
