import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Features/Instagram/Model/like_model.dart';

class PostModle {
  String postId;
  String userId;
  String imageURL;
  String caption;
  DateTime timestamp;
  List<PostModle> posts;
  List<LikeModel> likes;

  PostModle({
    required this.postId,
    required this.userId,
    required this.imageURL,
    required this.caption,
    required this.timestamp,
    required this.likes,
    required this.posts,
  });

  factory PostModle.fromJson(Map<String, dynamic> json) {
    return PostModle(
      postId: json[KConstants.kPostId],
      userId: json[KConstants.kUserId],
      imageURL: json[KConstants.kImageURL],
      caption: json[KConstants.kcaption],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
      likes: json[KConstants.kLikes],
      posts: json[KConstants.kPosts],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kPostId: postId,
      KConstants.kUserId: userId,
      KConstants.kImageURL: imageURL,
      KConstants.kcaption: caption,
      KConstants.kTimestamp: timestamp.toIso8601String(),
      KConstants.kLikes: likes,
      KConstants.kPosts: posts
    };
  }
}
