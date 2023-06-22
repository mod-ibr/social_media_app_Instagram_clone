import 'package:instagram/Core/Utils/Constants/k_constants.dart';

class CommentModel {
  String commentId;
  String userId;
  String content;
  DateTime timestamp;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json[KConstants.kCommentId],
      userId: json[KConstants.kUserId],
      content: json[KConstants.kContent],
      timestamp: DateTime.parse(json[KConstants.kTimestamp]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kCommentId: commentId,
      KConstants.kUserId: userId,
      KConstants.kContent: content,
      KConstants.kTimestamp: timestamp.toIso8601String(),
    };
  }
}
