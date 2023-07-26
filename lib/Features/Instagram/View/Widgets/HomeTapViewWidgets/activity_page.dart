import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Utils/Functions/animated_navigation.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Features/Instagram/ViewModel/LikeDislikeFollowUnfollowFeatures/like_dislike_follow_unfollow_featurs_cubit.dart';

import '../../../../../Core/Utils/Functions/date_time_formater.dart';
import '../../../Model/notification_model.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    BlocProvider.of<LikeDislikeFollowUnfollowFeatursCubit>(context)
        .getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _activityAppBar(width),
      body: _activityBody(width),
    );
  }

  Widget customeListtile(
      {required NotificationModel notificationModel, required double width}) {
    return Column(
      children: [
        ListTile(
          leading: postImageWidget(
            imageUrl: notificationModel.postImageUrl,
            width: width,
          ),
          title: CustomText(
            text: '${notificationModel.likerName} liked Your Post',
            textOverflow: TextOverflow.ellipsis,
            fontSize: width * 0.05,
            alignment: Alignment.centerLeft,
          ),
          subtitle: CustomText(
            text:
                'at ${DateTimeFormatter().formatDateTime(notificationModel.timeStamp)}',
            fontSize: width * 0.04,
            color: const Color.fromARGB(255, 113, 112, 112),
            alignment: Alignment.centerLeft,
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget postImageWidget({required String imageUrl, required double width}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: width * 0.15,
      height: width * 0.15,
      placeholder: (context, url) {
        if (url.isEmpty) {
          return const Icon(
            Icons.image,
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
        Icons.person,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  _activityAppBar(width) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
          onPressed: () =>
              AnimatedNavigation().navigateAndPop(context: context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          )),
      title: CustomText(
        text: 'Activity',
        fontSize: width * 0.06,
      ),
    );
  }

  _activityBody(width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LikeDislikeFollowUnfollowFeatursCubit,
          LikeDislikeFollowUnfollowFeatursState>(
        builder: (context, state) {
          if (state is LoadingGetNotificationsListState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorGetNotificationsListState) {
            return failureWidget(
                text: state.message, icon: Icons.notifications_off);
          } else if (state is SucceededGetNotificationsListState) {
            return successWidget(state.notifications, width);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
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

  Widget successWidget(List<NotificationModel> notifications, width) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) => customeListtile(
          width: width, notificationModel: notifications[index]),
    );
  }
}
