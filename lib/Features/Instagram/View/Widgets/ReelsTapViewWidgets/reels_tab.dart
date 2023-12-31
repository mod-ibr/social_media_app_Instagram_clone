import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Core/Widgets/user_avatar.dart';
import 'package:video_player/video_player.dart';

class ReelsTabViewVideo extends StatefulWidget {
  const ReelsTabViewVideo({Key? key}) : super(key: key);

  @override
  State<ReelsTabViewVideo> createState() => _ReelsTabViewVideoState();
}

class _ReelsTabViewVideoState extends State<ReelsTabViewVideo> {
  late VideoPlayerController videoPlayerController;
  late Future<void> videoPlayerFuture;
  late FlickManager flickManager;
  late FlickControlManager flickControlManager;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset(
      'assets/images/cars_shorts.mp4',
    )..setLooping(true);
    flickManager = FlickManager(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    flickControlManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            const Icon(
              Icons.favorite,
              color: Colors.red,
            );
          },
          child: FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: const FlickVideoWithControls(),
          ),
        ),

        //Camera
        _camera(),
        //bottom
        _bottom()
      ],
    ));
  }

  Widget _camera() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, right: 15.0),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: _likeCommentShare()),
          _avatarFollowOptionRow(),
          _reelDiscription(),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  size: 17,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: CustomText(
                    color: Colors.white,
                    fontSize: 12,
                    text: "Original Audio",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.person_outline,
                    size: 17,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: CustomText(
                    color: Colors.white,
                    fontSize: 12,
                    text: "Mahmoud Ibrahim",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeCommentShare() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.white,
          size: 33,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 5),
          child: CustomText(
              alignment: Alignment.centerRight,
              text: "11k",
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Icon(
            Icons.message_outlined,
            color: Colors.white,
            size: 33,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, right: 6, bottom: 5),
          child: CustomText(
            color: Colors.white,
            alignment: Alignment.centerRight,
            fontSize: 15,
            text: "64",
            fontWeight: FontWeight.normal,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.0, right: 2, bottom: 10),
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 27,
          ),
        ),
      ],
    );
  }

  Widget _avatarFollowOptionRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserAvatar(
                  profileImageUrl: '',
                  iconSize: 20,
                  outerRadius: 20,
                  innerRadius: 18),
              const SizedBox(
                width: 10,
              ),
              const CustomText(
                color: Colors.white,
                fontSize: 13,
                text: "Mahmoud Ibrahim",
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  side: const BorderSide(width: 1.0, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const CustomText(
                  color: Colors.white,
                  fontSize: 13,
                  text: "Follow",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reelDiscription() {
    return const SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0),
        child: CustomText(
          color: Colors.white,
          fontSize: 12,
          text: "The powerful Mercedes Car",
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
