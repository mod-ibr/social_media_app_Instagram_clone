import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Features/Instagram/Model/comment_model.dart';
import 'package:instagram/Features/Instagram/Model/like_model.dart';

class PostModle {
  final String postId;
  final String userId;
  final String name;
  final String profileImageURL;
  final String imageURL;
  final String caption;
  final DateTime timestamp;
  final List<CommentModel> comments;
  final List<LikeModel> likes;

  PostModle({
    required this.postId,
    required this.userId,
    required this.name,
    required this.profileImageURL,
    required this.imageURL,
    required this.caption,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  factory PostModle.fromJson(Map<String, dynamic> json) {
    List<dynamic> likesData = json[KConstants.kLikes];
    List<LikeModel> likes = likesData.map((likeJson) {
      return LikeModel.fromJson(likeJson);
    }).toList();

    List<dynamic> commentsData = json[KConstants.kComments];
    List<CommentModel> comments = commentsData.map((commentJson) {
      return CommentModel.fromJson(commentJson);
    }).toList();
    return PostModle(
      postId: json[KConstants.kPostId],
      userId: json[KConstants.kUserId],
      name: json[KConstants.kName],
      profileImageURL: json[KConstants.kProfileImageUrl],
      imageURL: json[KConstants.kImageURL],
      caption: json[KConstants.kcaption],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
      likes: likes,
      comments: comments,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> likesData = likes.map((like) {
      return like.toJson();
    }).toList();

    List<Map<String, dynamic>> commentsData = comments.map((comment) {
      return comment.toJson();
    }).toList();
    return {
      KConstants.kPostId: postId,
      KConstants.kUserId: userId,
      KConstants.kName: name,
      KConstants.kProfileImageUrl: profileImageURL,
      KConstants.kImageURL: imageURL,
      KConstants.kcaption: caption,
      KConstants.kTimestamp: timestamp.toIso8601String(),
      KConstants.kLikes: likesData,
      KConstants.kComments: commentsData,
    };
  }
}
