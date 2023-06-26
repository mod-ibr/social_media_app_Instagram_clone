import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Core/Utils/Functions/date_time_formater.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Core/Widgets/user_avatar.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import 'like_animtion.dart';

class PostCard extends StatelessWidget {
  final PostModle post;
  const PostCard({super.key, required this.post});
  final bool isAnimating = false;
  final int numberOfComments = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(children: [
        //headerbar
        _postHeader(context: context, name: post.name),
        //  Love post Animation Gesture And Image
        GestureDetector(
          onDoubleTap: () async {
            // FireStoreMethods().likePost(
            //     widget.snap['postId'], user.uid, widget.snap['likes']);
            // setState(() {
            //   isAnimating = true;
            // });
          },
          child: ZoomOverlay(
            modalBarrierColor: Colors.black12,
            minScale: 0.5,
            maxScale: 3.0,
            twoTouchOnly: true,
            animationDuration: const Duration(milliseconds: 100),
            animationCurve: Curves.fastOutSlowIn,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: CachedNetworkImage(
                    imageUrl: post.imageURL,
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
                      Icons.image,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {},
                    child: const Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      size: 130,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        _postTailer(),
        _postNumbers()
      ]),
    );
  }

  Widget _postHeader({required BuildContext context, required String name}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)
          .copyWith(right: 0),
      color: Colors.white,
      child: Row(
        children: [
          UserAvatar(
              profileImageUrl: post.profileImageURL,
              iconSize: 30,
              innerRadius: 35,
              outerRadius: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(textOverflow: TextOverflow.ellipsis, text: name),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    // backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: ["Delete", "edit"]
                          .map(
                            (e) => InkWell(
                              onTap: () async {
                                // String res =
                                //     await FireStoreMethods()
                                //         .deletePost(
                                //             widget.snap['postId']);
                                // showSnackBar(res, context);
                                // Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Center(child: Text(e)),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.more_vert,
              ))
        ],
      ),
    );
  }

  // Post Tailer for like comment save section
  Widget _postTailer() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          //like
          LikeAnimation(
            isAnimating: true,
            smallLike: true,
            child: IconButton(
              onPressed: () async {},
              icon: const Icon(
                CupertinoIcons.heart,
                size: 32,
              ),
            ),
          ),

          //comment
          IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.chat_bubble,
                size: 30,
              )),

          //share
          IconButton(
            icon: const Icon(
              CupertinoIcons.paperplane,
              size: 30,
            ),
            onPressed: () {},
          ),

          const Spacer(),
          //bookmark
          IconButton(
            icon: const Icon(
              CupertinoIcons.bookmark,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

//number of likes , description and number of comments
  Widget _postNumbers() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //number of likes
        Row(
          children: [
            CustomText(
              text: '${post.likes.length} likes, ',
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
            const SizedBox(width: 15),
            CustomText(
              text: '${post.comments.length} Comments, ',
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
            const Spacer(),

            //published date
            CustomText(
              text: DateTimeFormatter().formatDateTime(post.timestamp),
              fontWeight: FontWeight.w300,
              fontSize: 15,
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),

        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('show the whole text');
              },
              child: CustomText(
                textOverflow: TextOverflow.ellipsis,
                text: "${post.name} : ${post.caption}",
                maxLine: 2,
              ),
            ),
          ],
        ),

        //number of comments
        InkWell(
          onTap: () {
            print('View All Comments');
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                // 'View all ${numberOfComments} comments..',
                'View all comments...',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              )),
        )
      ]),
    );
  }
}
