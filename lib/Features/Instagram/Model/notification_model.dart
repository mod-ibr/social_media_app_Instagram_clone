import '../../../Core/Utils/Constants/k_constants.dart';

class NotificationModel {
  String postId;
  String postImageUrl;
  String likerId;
  String likerName;
  DateTime timeStamp;

  NotificationModel({
    required this.postId,
    required this.postImageUrl,
    required this.likerId,
    required this.likerName,
    required this.timeStamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      postId: json[KConstants.kPostId],
      postImageUrl: json[KConstants.kImageURL],
      likerId: json[KConstants.kLikerId],
      likerName: json[KConstants.kLikerName],
      timeStamp: DateTime.parse(json[KConstants.kTimestamp]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kPostId: postId,
      KConstants.kImageURL: postImageUrl,
      KConstants.kLikerId: likerId,
      KConstants.kLikerName: likerName,
      KConstants.kTimestamp: timeStamp.toIso8601String(),
    };
  }
}
