import '../../../Core/Utils/Constants/k_constants.dart';

class LikeModel {
  String userId;
  DateTime timestamp;

  LikeModel({
    required this.userId,
    required this.timestamp,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json[KConstants.kUserId],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kUserId: userId,
      KConstants.kTimestamp: timestamp.toIso8601String(),
    };
  }
}
