import '../../../Core/Utils/Constants/k_constants.dart';

class LikeModel {
  String likeId;
  String userId;
  String postId;
  String userName;
  String profileimageUrl;
  DateTime timestamp;

  LikeModel({
    required this.userId,
    required this.likeId,
    required this.postId,
    required this.timestamp,
    required this.userName,
    required this.profileimageUrl,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json[KConstants.kUserId],
      likeId: json[KConstants.kLikeId],
      postId: json[KConstants.kPostId],
      userName: json[KConstants.kUserName],
      profileimageUrl: json[KConstants.kProfileImageUrl],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kUserId: userId,
      KConstants.kTimestamp: timestamp.toIso8601String(),
      KConstants.kLikeId: likeId,
      KConstants.kPostId: postId,
      KConstants.kUserName: userName,
      KConstants.kProfileImageUrl: profileimageUrl
    };
  }
}
