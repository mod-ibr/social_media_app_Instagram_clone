import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Services/insta_remote_services.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';

import '../../../../Core/Errors/errors_strings.dart';
import '../../../../Core/Errors/exception.dart';
import '../../../../Core/Errors/failures.dart';
import '../../../../core/Network/network_connection_checker.dart';
import '../../../Auth/Model/auth_model.dart';

part 'home_view_tab_state.dart';

class HomeViewTabCubit extends Cubit<HomeViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  HomeViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(HomeTapViewInitial());
  late bool isCurrentUser;

  bool showDropdownList = false;
  bool showAddPostStoryReelLiveList = false;

  void instaLogoDropDownButton() {
    showDropdownList = !showDropdownList;
    showAddPostStoryReelLiveList = false;
    emit(DropDownButtonState(showDropdownList: showDropdownList));
  }

  void addPostStoryReelLiveButton() {
    showAddPostStoryReelLiveList = !showAddPostStoryReelLiveList;
    showDropdownList = false;
    emit(AddPostStoryReelLiveState(
        showAddPostStoryReelLiveList: showAddPostStoryReelLiveList));
  }

  void disableAllDropDownLists() {
    showDropdownList = false;
    showAddPostStoryReelLiveList = false;
    emit(DropDownButtonState(showDropdownList: showDropdownList));
  }

  Future<void> addPost(
      {required File imageFile, required String description}) async {
    emit(LoadingAddPostState());
    final Either<Failure, Unit> failureOrSuccess =
        await _addPost(imageFile: imageFile, description: description);

    failureOrSuccess.fold(
      (failure) =>
          emit(ErrorAddPostState(message: mapFailureToMessage(failure))),
      (success) => emit(SucceededAddPostState()),
    );
  }

  Future<void> getUserPosts({String? uid}) async {
    print("Get user post from  getuserpost with id :$uid");

    emit(LoadingGetPostsState());
    final Either<Failure, List<PostModel>> failureOrSuccess =
        await _getUserPosts(uid: uid);

    failureOrSuccess.fold(
      (failure) =>
          emit(ErrorGetPostsState(message: mapFailureToMessage(failure))),
      (success) => emit(SucceededGetPostsState(posts: success)),
    );
  }

  Future<void> getPostsOrderedByTimeStamp() async {
    emit(LoadingGetPostsState());
    final Either<Failure, List<PostModel>> failureOrSuccess =
        await _getPostsOrderedByTimeStamp();

    failureOrSuccess.fold(
      (failure) =>
          emit(ErrorGetPostsState(message: mapFailureToMessage(failure))),
      (success) => emit(SucceededGetPostsState(posts: success)),
    );
  }

  Future<Either<Failure, Unit>> _addPost(
      {required File imageFile, required String description}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        await instaRemoteServices.addPost(
            imageFile: imageFile, description: description);

        return const Right(unit);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, List<PostModel>>> _getUserPosts({String? uid}) async {
    print("Get user post from _getuserpost with id :$uid");
    if (await networkConnectionChecker.isConnected) {
      try {
        String currentUserId = instaRemoteServices.getCurrentUserId();
        String userId;
        if (uid != null) {
          userId = uid;
          isCurrentUser = false;
        } else {
          userId = currentUserId;
          isCurrentUser = true;
        }
        List<PostModel> posts =
            await instaRemoteServices.getUserPosts(userId: userId);
        if (posts.isEmpty) {
          return left(NoRetrievedPostsFailure());
        }
        return Right(posts);
      } on RetrievingPostsException {
        return left(RetrievingPostsFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, List<PostModel>>> _getPostsOrderedByTimeStamp() async {
    if (await networkConnectionChecker.isConnected) {
      try {
        List<PostModel> posts =
            await instaRemoteServices.getPostsOrderedByTimeStamp();
        if (posts.isEmpty) {
          return left(NoRetrievedPostsFailure());
        }
        return Right(posts);
      } on RetrievingPostsException {
        return left(RetrievingPostsFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<void> getUserDataById({String? uid}) async {
    emit(LoadingGetUserDataState());
    final Either<Failure, AuthModel> failureOrSuccess =
        await _getUserData(uid: uid);

    failureOrSuccess.fold(
      (failure) => emit(ErrorGetUserDataState(failure: failure)),
      (success) => emit(SucceededGetUserDataState(userData: success)),
    );
  }

  Future<Either<Failure, AuthModel>> _getUserData({String? uid}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        String currentUserId = instaRemoteServices.getCurrentUserId();
        String userId;
        if (uid != null) {
          userId = uid;
          isCurrentUser = false;
        } else {
          userId = currentUserId;
          isCurrentUser = true;
        }
        AuthModel userData =
            await instaRemoteServices.getuserDataById(uid: userId);

        return Right(userData);
      } on NoSavedUserException {
        return Left(NoSavedUserFailure());
      } on ServerException {
        return left(ServerFailure());
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
      case NoSavedUserFailure:
        return ErrorsStrings.noSavedUserFailureeMessage;
      case NoRetrievedPostsFailure:
        return ErrorsStrings.noRetrievedPostsFailureMessage;
      case RetrievingPostsFailure:
        return ErrorsStrings.retrievingPostsFailureMessage;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
