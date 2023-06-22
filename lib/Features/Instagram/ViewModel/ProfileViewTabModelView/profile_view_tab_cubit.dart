import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:instagram/Core/Errors/exception.dart';
import 'package:instagram/Core/Errors/failures.dart';
import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';
import '../../../../Core/Errors/errors_strings.dart';
import '../../../../core/Network/network_connection_checker.dart';
import '../../../../Core/Services/insta_remote_services.dart';
part 'profile_view_tab_state.dart';

class ProfileViewTabCubit extends Cubit<ProfileViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;

  late String name;
  late String userName;
  late String bio;
  late bool isCurrentUser;
  ProfileViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(ProfileViewTabInitial());

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
        name = userData.name!;
        userName = userData.userName!;
        bio = userData.bio!;

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

      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  Future<void> updateUserData(
      {required String name,
      required String userName,
      required String bio}) async {
    emit(LoadingUpdateUserDataState());
    final Either<Failure, Unit> failureOrSuccess =
        await _updateUserData(bio: bio, name: name, userName: userName);

    failureOrSuccess.fold(
      (failure) => emit(ErrorUpdateUserDataState(failure: failure)),
      (success) => emit(SucceededUpdateUserDataState()),
    );
  }

  Future<Either<Failure, Unit>> _updateUserData(
      {required String name,
      required String userName,
      required String bio}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        await instaRemoteServices.updateUserData(
          userName: userName,
          name: name,
          bio: bio,
        );

        return const Right(unit);
      } on NoSavedUserException {
        return Left(NoSavedUserFailure());
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<void> uploadProfileImage({required File imageFile}) async {
    emit(LoadingUpdateUserDataState());
    final Either<Failure, Unit> failureOrSuccess =
        await _uploadProfileImage(imageFile);

    failureOrSuccess.fold(
      (failure) => emit(ErrorUpdateUserDataState(failure: failure)),
      (success) => emit(SucceededUploadedUserProfileImg()),
    );
  }

  Future<Either<Failure, Unit>> _uploadProfileImage(File imageFile) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        String imgUrl = await instaRemoteServices.uploadImageToStorage(
            imageFile: imageFile,
            storageFolder: KConstants.kStorageProfileFolder);

        await instaRemoteServices.updateProfileImgUrlData(imgUrl: imgUrl);

        return const Right(unit);
      } on NoSavedUserException {
        return Left(NoSavedUserFailure());
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
