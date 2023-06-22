import 'package:get_it/get_it.dart';
import 'package:instagram/Core/Services/insta_remote_services.dart';
import 'package:instagram/Features/Instagram/ViewModel/ProfileViewtabModelView/profile_view_tab_cubit.dart';
import 'package:instagram/Features/Instagram/ViewModel/SearchViewTabModelView/search_view_tab_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/Services/auth_local_services.dart';
import 'Core/Services/auth_remote_services.dart';
import 'Features/Instagram/ViewModel/HomeViewTapModelView/home_view_tab_cubit.dart';
import 'core/Network/network_connection_checker.dart';
import 'Features/Auth/ViewModel/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> servicesLocator() async {
  //! Features

  // Auth Bloc

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      authLocalServices: sl(),
      authRemoteServices: sl(),
      networkConnectionChecker: sl(),
    ),
  );

//  Home View Tab Bloc
  sl.registerLazySingleton<HomeViewTabCubit>(
    () => HomeViewTabCubit(
      networkConnectionChecker: sl(),
      instaRemoteServices: sl(),
    ),
  );

  // Profile View Tab Bloc
  sl.registerLazySingleton<ProfileViewTabCubit>(
    () => ProfileViewTabCubit(
      networkConnectionChecker: sl(),
      instaRemoteServices: sl(),
    ),
  );

  // Search View Tab Bloc
  sl.registerLazySingleton<SearchViewTabCubit>(
    () => SearchViewTabCubit(
      networkConnectionChecker: sl(),
      instaRemoteServices: sl(),
    ),
  );
  //! Core

  //Auth Services
  sl.registerLazySingleton<NetworkConnectionChecker>(
      () => NetworkConnectionCheckerImpl(sl()));
  sl.registerLazySingleton<AuthLocalServices>(
      () => AuthLocalServicesSharedPrefes(sl()));
  sl.registerLazySingleton<AuthRemoteServices>(
      () => AuthRemoteServicesFireBase());
  sl.registerLazySingleton<InstaRemoteServices>(
      () => InstaRemoteServicesFireBase());
  // //Maps Services
  // sl.registerLazySingleton<InstagramLocalServices>(
  //     () => InstagramLocalServicesSharedPrefes(sl<SharedPreferences>()));
  // sl.registerLazySingleton<InstagramRemoteServices>(
  //     () => InstagramRemoteServicesGeoLocator());

  //! External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
