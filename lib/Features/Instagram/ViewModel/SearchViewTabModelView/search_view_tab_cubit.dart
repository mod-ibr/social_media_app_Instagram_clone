import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';

import '../../../../Core/Errors/errors_strings.dart';
import '../../../../Core/Errors/exception.dart';
import '../../../../Core/Errors/failures.dart';
import '../../../../core/Network/network_connection_checker.dart';
import '../../../../Core/Services/insta_remote_services.dart';

part 'search_view_tab_state.dart';

class SearchViewTabCubit extends Cubit<SearchViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  SearchViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(SearchViewTabInitial());

  void getUserByUserNameOrName({required String userNameOrName}) async {
    emit(LoadingSearchState());
    final Either<Failure, List<AuthModel>> failureOrSuccess =
        await _getUserByUsernameOrName(userNameOrName: userNameOrName);

    failureOrSuccess.fold(
      (failure) => emit(ErrorSearchState(failure: failure)),
      (success) => emit(SucceededSearchState(users: success)),
    );
  }

  Future<Either<Failure, List<AuthModel>>> _getUserByUsernameOrName(
      {required String userNameOrName}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        List<AuthModel> users =
            await instaRemoteServices.getUsersByUserNameOrName(userNameOrName);
        if (users.isEmpty) {
          return Left(EmptySearchFailure());
        }
        return Right(users);
      } on ServerException {
        return Left(ServerFailure());
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
      case EmptySearchFailure:
        return ErrorsStrings.emptySearchFailureMessage;

      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  bool checkIsCurrentUser(String uid) {
    String currentUser = instaRemoteServices.getCurrentUserId();
    bool isCurrentUser =
        currentUser.toString().toLowerCase() == uid.toString().toLowerCase();
    print('Current user : $currentUser');
    print('Requsted user: $uid');
    print("Result : $isCurrentUser");
    return isCurrentUser;
  }
}
