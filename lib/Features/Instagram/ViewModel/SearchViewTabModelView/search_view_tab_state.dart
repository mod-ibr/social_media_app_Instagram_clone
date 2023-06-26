part of 'search_view_tab_cubit.dart';

abstract class SearchViewTabState extends Equatable {
  const SearchViewTabState();

  @override
  List<Object> get props => [];
}

class SearchViewTabInitial extends SearchViewTabState {}

// class LoadingGetPostsState extends SearchViewTabState {}

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
