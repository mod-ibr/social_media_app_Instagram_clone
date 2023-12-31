import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Core/Errors/exception.dart';
import '../../Features/Auth/Model/auth_model.dart';
import '../Utils/Constants/k_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class AuthRemoteServices {
  Future<Unit> setUserData({required AuthModel authModel, bool isupdate});
  Future<UserCredential> createAccount(
      {required String email, required String password});
  Future<UserCredential> emailAndPasswordLogIn(
      {required String email, required String password});
  Future<UserCredential> faceBookLogIn();

  Future<UserCredential> googleLogIn();
  Future<Unit> logOut();
}

class AuthRemoteServicesFireBase implements AuthRemoteServices {
  late String verificationId;
  @override
  Future<UserCredential> createAccount(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<UserCredential> emailAndPasswordLogIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<UserCredential> googleLogIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserCredential> faceBookLogIn() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the login was successful
      if (result.accessToken != null) {
        // Exchange the Facebook access token for a Firebase credential
        AuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Sign in to Firebase with the Facebook credential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      } else {
        throw FaceBookLogInException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<String> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token ?? '';
  }

  @override
  Future<Unit> setUserData(
      {required AuthModel authModel, bool isupdate = false}) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve the FCM token
      String fcmToken = await getFCMToken();

      // Convert AuthModel object to a map using toJson() method
      Map<String, dynamic> authData = authModel.toJson();

      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String username = authData[KConstants.kEmail].toString().split('@')[0];

// check if its for updating user data after log in or for setting user data after sign in
      if (isupdate) {
        // Update the user FCM token after log in
        await firestore
            .collection(KConstants.kUsersCollection)
            .doc(userId)
            .update({
          KConstants.kFCMToken: fcmToken, // Save the FCM token
        });
      } else {
        // Set the authData map to a document with the current user ID in a 'users' collection
        await firestore
            .collection(KConstants.kUsersCollection)
            .doc(userId)
            .set({
          KConstants.kUserName: username,
          KConstants.kName: authData[KConstants.kUserName],
          KConstants.kEmail: authData[KConstants.kEmail],
          KConstants.kPhone: '',
          KConstants.kProfileImageUrl: '',
          KConstants.kBio: '',
          KConstants.kUserId: userId,
          KConstants.kNFollowers: '0',
          KConstants.kNFollowing: '0',
          KConstants.kNPosts: 0,
          KConstants.kFCMToken: fcmToken, // Save the FCM token
        });
      }

      return Future.value(unit);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> logOut() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // // Retrieve the FCM token
      // String fcmToken = await getFCMToken();

      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Remove the FCM token from the user document
      await firestore
          .collection(KConstants.kUsersCollection)
          .doc(userId)
          .update({
        KConstants.kFCMToken: FieldValue.delete(),
      });

      // Sign out the current user using FirebaseAuth
      await FirebaseAuth.instance.signOut();

      // Unsubscribe from FCM topic using the FCM token
      await FirebaseMessaging.instance.unsubscribeFromTopic(userId);

      return Future.value(unit);
    } catch (e) {
      throw ServerException();
    }
  }
}
