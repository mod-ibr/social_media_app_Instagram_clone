import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Errors/exception.dart';
import '../../Features/Auth/Model/auth_model.dart';
import '../Utils/Constants/k_constants.dart';

abstract class AuthLocalServices {
  Future<AuthModel> getUserData();
  Future<Unit> setUserData(AuthModel authModel);
  Future<Unit> clearUserData();
  Future<Unit> setIsUserLoggedIn({required bool isUserLoggedIn});
  bool? getIsUserLoggedIn();
}

class AuthLocalServicesSharedPrefes implements AuthLocalServices {
  final SharedPreferences sharedPreferences;

  AuthLocalServicesSharedPrefes(this.sharedPreferences);

  @override
  Future<Unit> setUserData(AuthModel authModel) async {
    Map<String, dynamic> authModelToJson = authModel.toJson();

    await sharedPreferences.setString(
        KConstants.kUserData, json.encode(authModelToJson));
    await sharedPreferences.setBool(KConstants.kIsUserLoggedIn, true);
    return Future.value(unit);
  }

  @override
  Future<AuthModel> getUserData() async {
    final jsonString = sharedPreferences.getString(KConstants.kUserData);
    if (jsonString != null) {
      Map<String, dynamic> jsonToAuthModel =
          json.decode(jsonString) as Map<String, dynamic>;

      AuthModel savedModel = AuthModel.fromJson(jsonToAuthModel);

      return savedModel;
    } else {
      throw NoSavedUserException();
    }
  }

  @override
  Future<Unit> clearUserData() async {
    await sharedPreferences.clear();
    return Future.value(unit);
  }

  @override
  Future<Unit> setIsUserLoggedIn({required bool isUserLoggedIn}) async {
    await sharedPreferences.setBool(
        KConstants.kIsUserLoggedIn, isUserLoggedIn);
    return Future.value(unit);
  }

  @override
  bool? getIsUserLoggedIn() {
    final isUserLoggedIn =
        sharedPreferences.getBool(KConstants.kIsUserLoggedIn);
    return isUserLoggedIn;
  }
}
