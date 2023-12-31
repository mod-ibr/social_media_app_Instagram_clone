import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoSavedUserFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailAlreadyInUseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class FaceBookLogInFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class SearchFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptySearchFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoRetrievedPostsFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class RetrievingPostsFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class PostNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class EmptyNotiicationFailure extends Failure {
  @override
  List<Object?> get props => [];
}
