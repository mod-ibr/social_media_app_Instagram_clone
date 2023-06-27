import 'package:instagram/Core/Utils/Constants/k_constants.dart';

class PostModel {
  final String postId;
  final String userId;
  final String name;
  final String profileImageURL;
  final String imageURL;
  final String caption;
  final DateTime timestamp;
  final List<String> likedPostIds;
  final List<String> commentedPostIds;
// to make the like icon red if the current user liked and vice versa.
  bool isiked = false;
  int nLikes = 0;
  int nComments = 0;

  PostModel({
    required this.postId,
    required this.userId,
    required this.name,
    required this.profileImageURL,
    required this.imageURL,
    required this.caption,
    required this.timestamp,
    required this.likedPostIds,
    required this.commentedPostIds,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json[KConstants.kPostId],
      userId: json[KConstants.kUserId],
      name: json[KConstants.kName],
      profileImageURL: json[KConstants.kProfileImageUrl],
      imageURL: json[KConstants.kImageURL],
      caption: json[KConstants.kcaption],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
      likedPostIds: List<String>.from(json[KConstants.kLikedPostIds] ?? []),
      commentedPostIds:
          List<String>.from(json[KConstants.kCommentedPostIds] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kPostId: postId,
      KConstants.kUserId: userId,
      KConstants.kName: name,
      KConstants.kProfileImageUrl: profileImageURL,
      KConstants.kImageURL: imageURL,
      KConstants.kcaption: caption,
      KConstants.kTimestamp: timestamp.toIso8601String(),
      KConstants.kLikedPostIds: likedPostIds,
      KConstants.kCommentedPostIds: commentedPostIds,
    };
  }
}
