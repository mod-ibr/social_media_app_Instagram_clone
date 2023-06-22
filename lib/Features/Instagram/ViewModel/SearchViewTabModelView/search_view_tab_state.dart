part of 'search_view_tab_cubit.dart';

abstract class SearchViewTabState extends Equatable {
  const SearchViewTabState();

  @override
  List<Object> get props => [];
}

class SearchViewTabInitial extends SearchViewTabState {}

class LoadingGetPostsState extends SearchViewTabState {}

class SucceededGetPostsState extends SearchViewTabState {
  final List<PostModle> posts;
  const SucceededGetPostsState({required this.posts});
  @override
  List<Object> get props => [posts];
}

class ErrorGetPostsState extends SearchViewTabState {
  final Failure failure;

  const ErrorGetPostsState({required this.failure});
  @override
  List<Object> get props => [failure];
}

class LoadingSearchState extends SearchViewTabState {}

class SucceededSearchState extends SearchViewTabState {
  final List<AuthModel> users;
  const SucceededSearchState({required this.users});
  @override
  List<Object> get props => [users];
}

class ErrorSearchState extends SearchViewTabState {
  final Failure failure;

  const ErrorSearchState({required this.failure});
  @override
  List<Object> get props => [failure];
}
