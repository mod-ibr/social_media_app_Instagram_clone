import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Services/insta_remote_services.dart';

import '../../../../core/Network/network_connection_checker.dart';

part 'home_view_tab_state.dart';

class HomeViewTabCubit extends Cubit<HomeViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  HomeViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(HomeTapViewInitial());

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
}
