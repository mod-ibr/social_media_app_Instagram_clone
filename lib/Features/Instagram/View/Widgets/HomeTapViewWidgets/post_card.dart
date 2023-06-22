import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Core/Widgets/custom_text.dart';
import 'package:instagram/Core/Widgets/user_avatar.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import 'like_animtion.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});
  final bool isAnimating = false;
  final int numberOfComments = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(children: [
        //headerbar
        _postHeader(context),
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
            modalBarrierColor: Colors.black12, // optional
            minScale: 0.5, // optional
            maxScale: 3.0, // optional
            twoTouchOnly: true,
            animationDuration: const Duration(milliseconds: 100),
            animationCurve: Curves.fastOutSlowIn,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: const Image(
                    image: AssetImage('assets/images/instagram_logo.png'),

                    // image: NetworkImage(widget.snap['postURL']),
                    fit: BoxFit.cover,
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
                    onEnd: () {
                      // setState(() {
                      //   isAnimating = false;
                      // });
                    },
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

  Widget _postHeader(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)
          .copyWith(right: 0),
      color: Colors.white,
      child: Row(
        children: [
          const UserAvatar(iconSize: 30, innerRadius: 35, outerRadius: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    // widget.snap['username'],
                    'Mahmoud',
                    style: TextStyle(fontSize: 15),
                  ),
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
            isAnimating: true, //widget.snap['likes'].contains(user.uid),
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                // await FireStoreMethods().likePost(
                //     widget.snap['postId'], user.uid, widget.snap['likes']);
                // setState(() {
                //   isAnimating = true;
                // });
              },
              icon:
                  // widget.snap['likes'].contains(user.uid)
                  //     ? const Icon(
                  //         Icons.favorite,
                  //         color: Colors.red,
                  //         size: 32,
                  //       )
                  //     :
                  const Icon(
                CupertinoIcons.heart,
                size: 32,
              ),
            ),
          ),

          //comment
          IconButton(
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => CommentScreen(snap: widget.snap)));
              },
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
          children: const [
            CustomText(
              // '${widget.snap['likes'].length} likes',
              text: '2.032 likes',
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),

            Spacer(),

            //published date
            CustomText(
              // DateFormat.yMMMd().format(
              //   widget.snap['datePublished'].toDate(),
              // ),
              text: '8 ours ago', fontWeight: FontWeight.w300,
              fontSize: 15,
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),

        // Column(
        //   children: <Widget>[
        //     ExpandableText(
        //       widget.snap['discription'],
        //       prefixText: widget.snap['username'],
        //       prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
        //       expandText: 'show more',
        //       collapseText: 'show less',
        //       maxLines: 3,
        //       linkColor: Colors.blue,
        //     ),
        //   ],
        // ),

        //number of comments
        InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => CommentScreen(snap: widget.snap)));
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                // 'View all ${numberOfComments} comments..',
                'View all <numberOfComments> comments..',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              )),
        )
      ]),
    );
  }
}
