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
