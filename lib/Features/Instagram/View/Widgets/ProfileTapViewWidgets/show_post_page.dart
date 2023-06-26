import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Utils/Functions/animated_navigation.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';
import 'package:instagram/Core/Errors/failures.dart';

import '../../../../../Core/Widgets/loading_widget.dart';
import '../../../ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import '../HomeTapViewWidgets/post_card.dart';

class ShowPostPage extends StatefulWidget {
  const ShowPostPage({super.key, required this.postModle});
  final PostModle postModle;

  @override
  State<ShowPostPage> createState() => _ShowPostPageState();
}

class _ShowPostPageState extends State<ShowPostPage> {
  @override
  void initState() {
    BlocProvider.of<HomeViewTabCubit>(context)
        .getUserDataById(uid: widget.postModle.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewTabCubit, HomeViewTabState>(
      builder: (context, state) {
        if (state is LoadingGetUserDataState) {
          return const LoadingWidget();
        } else if (state is ErrorGetUserDataState) {
          String failureMessage = BlocProvider.of<HomeViewTabCubit>(context)
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
          return _postWidget(state.userData);
        }
        return const LoadingWidget();
      },
    );
  }

  Widget _postWidget(AuthModel userData) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: CustomText(
              textOverflow: TextOverflow.ellipsis, text: widget.postModle.name),
          leading: IconButton(
            onPressed: () =>
                AnimatedNavigation().navigateAndPop(context: context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey[800],
            ),
          ),
        ),
        body: Center(
            child: PostCard(
          post: widget.postModle,
        )),
      ),
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
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
