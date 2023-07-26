part of 'like_dislike_follow_unfollow_featurs_cubit.dart';

abstract class LikeDislikeFollowUnfollowFeatursState extends Equatable {
  const LikeDislikeFollowUnfollowFeatursState();

  @override
  List<Object> get props => [];
}

class LikeDislikeFollowUnfollowFeatursInitial
    extends LikeDislikeFollowUnfollowFeatursState {}

class StartlikeAnimationState extends LikeDislikeFollowUnfollowFeatursState {
  final bool isAnimating;
  const StartlikeAnimationState({required this.isAnimating});
  @override
  List<Object> get props => [isAnimating];
}

class SucceededLikeState extends LikeDislikeFollowUnfollowFeatursState {
  final PostModel? postModel;
  final bool isAnimating;
  const SucceededLikeState(
      {required this.postModel, required this.isAnimating});
  @override
  List<Object> get props => [postModel!, isAnimating];
}

class ErrorlikeState extends LikeDislikeFollowUnfollowFeatursState {
  final String message;
  final bool isAnimating;

  const ErrorlikeState({required this.message, required this.isAnimating});
  @override
  List<Object> get props => [message, isAnimating];
}

class LoadingGetNotificationsListState
    extends LikeDislikeFollowUnfollowFeatursState {}

class SucceededGetNotificationsListState
    extends LikeDislikeFollowUnfollowFeatursState {
  final List<NotificationModel> notifications;
  const SucceededGetNotificationsListState({required this.notifications});
  @override
  List<Object> get props => [notifications];
}

class ErrorGetNotificationsListState
    extends LikeDislikeFollowUnfollowFeatursState {
  final String message;

  const ErrorGetNotificationsListState({required this.message});
  @override
  List<Object> get props => [message];
}
