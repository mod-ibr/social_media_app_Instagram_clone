import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';

import '../../../../Core/Errors/errors_strings.dart';
import '../../../../Core/Errors/exception.dart';
import '../../../../Core/Errors/failures.dart';
import '../../../../Core/Services/insta_remote_services.dart';
import '../../../../core/Network/network_connection_checker.dart';

part 'like_dislike_follow_unfollow_featurs_state.dart';

class LikeDislikeFollowUnfollowFeatursCubit
    extends Cubit<LikeDislikeFollowUnfollowFeatursState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  PostModel? postModel;
  bool isAnimating = false;
  LikeDislikeFollowUnfollowFeatursCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(LikeDislikeFollowUnfollowFeatursInitial());

  Future<void> likePost({required String postId}) async {
    isAnimating = true;
    emit(StartlikeAnimationState(isAnimating: isAnimating));
    // await Future.delayed(const Duration(milliseconds: 100));
    final Either<Failure, PostModel> failureOrSuccess =
        await _likePost(postId: postId);

    failureOrSuccess.fold(
      (failure) {
        print('Failure in like Cubit');
        isAnimating = false;
        emit(ErrorlikeState(
            message: mapFailureToMessage(failure), isAnimating: isAnimating));
      },
      (success) {
        print('Success in like cubit');
        isAnimating = false;
        print('is iked :${success.isiked} From Cubit');
        emit(SucceededLikeState(postModel: success, isAnimating: isAnimating));
      },
    );
  }

  Future<Either<Failure, PostModel>> _likePost({required String postId}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        await instaRemoteServices.likePost(postId: postId).then((value) async {
          String currentUserId = instaRemoteServices.getCurrentUserId();
          print('current user id : $currentUserId From Cubit');
          postModel = await instaRemoteServices.getPostById(postId: postId);

          if (postModel!.likedPostIds.contains(currentUserId)) {
            postModel!.isiked = true;
            print('is iked :${postModel!.isiked} From Cubit _likePost');
          } else {
            postModel!.isiked = false;
            print('is iked :${postModel!.isiked} From Cubit _likePost');
          }
          return Right(postModel);
        });

        return Right(postModel!);
      } on ServerException {
        return left(ServerFailure());
      } on PostNotFoundException {
        return left(PostNotFoundFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ErrorsStrings.serverFailureMessage;
      case OfflineFailure:
        return ErrorsStrings.offlineFailureMessage;
      case PostNotFoundFailure:
        return ErrorsStrings.postNotFoundFailureMessage;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
