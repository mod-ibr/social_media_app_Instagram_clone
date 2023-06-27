import '../../../Core/Utils/Constants/k_constants.dart';

class LikeModel {
  String likeId;
  String userId;
  DateTime timestamp;

  LikeModel({
    required this.userId,
    required this.likeId,
    required this.timestamp,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json[KConstants.kUserId],
      likeId:  json[KConstants.kLikeId],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kUserId: userId,
      KConstants.kTimestamp: timestamp.toIso8601String(),
      KConstants.kLikeId: likeId,
    };
  }
}
