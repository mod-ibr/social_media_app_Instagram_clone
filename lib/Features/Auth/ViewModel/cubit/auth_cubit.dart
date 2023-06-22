import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Errors/errors_strings.dart';
import '../../../../Core/Errors/exception.dart';
import '../../../../Core/Services/auth_local_services.dart';
import '../../../../Core/Services/auth_remote_services.dart';
import '../../../../core/Errors/failures.dart';
import '../../../../core/Network/network_connection_checker.dart';
import '../../Model/auth_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthLocalServices authLocalServices;
  final AuthRemoteServices authRemoteServices;
  final NetworkConnectionChecker networkConnectionChecker;
  bool isPasswordVisible = false;
  String completePhoneNumber = '';
  String countryCode = '';
  String phoneNumber = '';
  String otpCode = '';
  bool isLoggedIn = false;
  AuthCubit(
      {required this.authLocalServices,
      required this.authRemoteServices,
      required this.networkConnectionChecker})
      : super(AuthInitial());

  void goToHomeViewOrLogInView() async {
    emit(LoadingAuthState());
    isLoggedIn = _goToHomeViewOrLogInViewLogic();
    if (isLoggedIn) {
      emit(LoggedInState());
    } else {
      emit(NotLoggedInState());
    }
  }

  void toggelPassword() {
    isPasswordVisible = !isPasswordVisible;

    if (isPasswordVisible) {
      emit(ShowPasswordState(isPasswordVisible: isPasswordVisible));
    } else {
      emit(HidePasswordState(isPasswordVisible: isPasswordVisible));
    }
  }

  void emailAndPasswordLogIn(
      {required AuthModel authEntity, required String password}) async {
    emit(LoadingAuthState());
    final Either<Failure, Unit> failureOrSuccess =
        await _emailAndPasswordLogInLogic(
            authEntity: authEntity, password: password);

    failureOrSuccess.fold(
      (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededAuthState()),
    );
  }

  void createAccount(
      {required AuthModel authEntity, required String password}) async {
    emit(LoadingAuthState());
    final Either<Failure, Unit> failureOrSuccess =
        (await _createAccountLogic(authEntity: authEntity, password: password));

    failureOrSuccess.fold(
      (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededAuthState()),
    );
  }

  void googleLogIn() async {
    emit(LoadingAuthState());
    final Either<Failure, Unit> failureOrSuccess = await _googleLogInLogic();

    failureOrSuccess.fold(
      (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededAuthState()),
    );
  }

  void faceBookLogIn() async {
    emit(LoadingAuthState());
    final Either<Failure, Unit> failureOrSuccess = await _faceBookLogInLogic();

    failureOrSuccess.fold(
      (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededAuthState()),
    );
  }

  void logOut() async {
    emit(LoadingAuthState());
    final Either<Failure, Unit> failureOrSuccess = (await _logOutLogic());
    failureOrSuccess.fold(
      (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededAuthState()),
    );
  }

  Future<Either<Failure, Unit>> _createAccountLogic(
      {required AuthModel authEntity, required String password}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        AuthModel authModel = AuthModel(
            userName: authEntity.userName ?? '',
            email: authEntity.email,
            phone: authEntity.phone ?? '');

        await authRemoteServices.createAccount(
            email: authModel.email, password: password);

        await authRemoteServices.setUserData(authModel);
        await authLocalServices.setUserData(authModel);
        await authLocalServices.setIsUserLoggedIn(isUserLoggedIn: true);

        return const Right(unit);
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> _emailAndPasswordLogInLogic(
      {required AuthModel authEntity, required String password}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        AuthModel authModel = AuthModel(
            userName: authEntity.userName ?? '',
            email: authEntity.email,
            phone: authEntity.phone ?? '');

        await authRemoteServices
            .emailAndPasswordLogIn(email: authModel.email, password: password)
            .then((value) async {
          await authLocalServices.setUserData(authModel);
          await authLocalServices.setIsUserLoggedIn(isUserLoggedIn: true);
        });

        return const Right(unit);
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> _faceBookLogInLogic() async {
    if (await networkConnectionChecker.isConnected) {
      try {
        UserCredential userCredential =
            await authRemoteServices.faceBookLogIn();
        AuthModel authModel = AuthModel(
          userName: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email!,
          phone: userCredential.user!.phoneNumber ?? '',
        );
        await authRemoteServices.setUserData(authModel);
        await authLocalServices.setUserData(authModel);
        await authLocalServices.setIsUserLoggedIn(isUserLoggedIn: true);

        return const Right(unit);
      } on FaceBookLogInException {
        return Left(FaceBookLogInFailure());
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(OfflineFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> _googleLogInLogic() async {
    if (await networkConnectionChecker.isConnected) {
      try {
        UserCredential userCredential = await authRemoteServices.googleLogIn();
        AuthModel authModel = AuthModel(
            userName: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? '',
            phone: userCredential.user!.phoneNumber ?? '');
        await authRemoteServices.setUserData(authModel);
        await authLocalServices.setUserData(authModel);
        await authLocalServices.setIsUserLoggedIn(isUserLoggedIn: true);

        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(OfflineFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> _logOutLogic() async {
    if (await networkConnectionChecker.isConnected) {
      try {
        await authLocalServices.clearUserData();
        await authLocalServices.setIsUserLoggedIn(isUserLoggedIn: false);
        await authRemoteServices.logOut();

        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  bool _goToHomeViewOrLogInViewLogic() {
    bool isUserLoggedIn = authLocalServices.getIsUserLoggedIn() ?? false;
    return isUserLoggedIn;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ErrorsStrings.serverFailureMessage;
      case OfflineFailure:
        return ErrorsStrings.offlineFailureMessage;
      case NoSavedUserFailure:
        return ErrorsStrings.noSavedUserFailureeMessage;
      case WeakPasswordFailure:
        return ErrorsStrings.weakPasswordFailureMessage;
      case EmailAlreadyInUseFailure:
        return ErrorsStrings.emailAlreadyInUseFailureMessage;
      case UserNotFoundFailure:
        return ErrorsStrings.userNotFoundFailureMessage;
      case WrongPasswordFailure:
        return ErrorsStrings.wrongPasswordFailureMessage;
      case FaceBookLogInFailure:
        return ErrorsStrings.faceBookLogInFailureMessage;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
