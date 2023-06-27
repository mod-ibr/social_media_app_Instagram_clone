part of 'home_view_tab_cubit.dart';

abstract class HomeViewTabState extends Equatable {
  const HomeViewTabState();

  @override
  List<Object> get props => [];
}

class HomeTapViewInitial extends HomeViewTabState {}

class DropDownButtonState extends HomeViewTabState {
  final bool showDropdownList;
  const DropDownButtonState({required this.showDropdownList});
  @override
  List<Object> get props => [showDropdownList];
}

class AddPostStoryReelLiveState extends HomeViewTabState {
  final bool showAddPostStoryReelLiveList;
  const AddPostStoryReelLiveState({required this.showAddPostStoryReelLiveList});
  @override
  List<Object> get props => [showAddPostStoryReelLiveList];
}

// --------------
class LoadingGetPostsState extends HomeViewTabState {}

class SucceededGetPostsState extends HomeViewTabState {
  final List<PostModel> posts;
  const SucceededGetPostsState({required this.posts});
  @override
  List<Object> get props => [posts];
}

class ErrorGetPostsState extends HomeViewTabState {
  final String message;
  const ErrorGetPostsState({required this.message});

  @override
  List<Object> get props => [message];
}

//-------------
class LoadingAddPostState extends HomeViewTabState {}

class SucceededAddPostState extends HomeViewTabState {}

class ErrorAddPostState extends HomeViewTabState {
  final String message;

  const ErrorAddPostState({required this.message});
  @override
  List<Object> get props => [message];
}

//----------------------
class LoadingGetUserDataState extends HomeViewTabState {}

class SucceededGetUserDataState extends HomeViewTabState {
  final AuthModel userData;
  const SucceededGetUserDataState({required this.userData});
  @override
  List<Object> get props => [userData];
}

class ErrorGetUserDataState extends HomeViewTabState {
  final Failure failure;

  const ErrorGetUserDataState({required this.failure});
  @override
  List<Object> get props => [failure];
}
