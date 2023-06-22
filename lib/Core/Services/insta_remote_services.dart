import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Core/Errors/exception.dart';
import 'package:path/path.dart' as path;
import '../../Features/Auth/Model/auth_model.dart';
import '../Utils/Constants/k_constants.dart';

abstract class InstaRemoteServices {
  Future<AuthModel> getuserDataById({required String uid});
  String getCurrentUserId();
  Future<List<AuthModel>> getUsersByUserNameOrName(String name);
  Future<String> uploadImageToStorage(
      {required File imageFile, required String storageFolder});
  Future<void> updateUserData(
      {required String userName, required String name, required String bio});
  Future<void> updateProfileImgUrlData({required String imgUrl});
  Future<void> removeImageFromStorageByUrl({required String imageURL});
}

class InstaRemoteServicesFireBase implements InstaRemoteServices {
  @override
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String getImageFileName(File imageFile) {
    String filePath = imageFile.path;
    String fileName = path.basename(filePath);
    return fileName;
  }

  @override
  Future<AuthModel> getuserDataById({required String uid}) async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the user document from Firestore using the current user ID
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(KConstants.kUsersCollection)
          .doc(uid)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Convert the document data to a User object
        AuthModel authModel = AuthModel(
          userName: documentSnapshot.data()![KConstants.kUserName],
          email: documentSnapshot.data()![KConstants.kEmail],
          phone: documentSnapshot.data()![KConstants.kPhone],
          bio: documentSnapshot.data()![KConstants.kBio],
          profileImgUrl: documentSnapshot.data()![KConstants.kProfileImageUrl],
          userId: documentSnapshot.data()![KConstants.kUserId],
          nFollowers: documentSnapshot.data()![KConstants.kNFollowers],
          nFollowing: documentSnapshot.data()![KConstants.kNFollowing],
          nPosts: documentSnapshot.data()![KConstants.kNPosts],
          name: documentSnapshot.data()![KConstants.kName],
        );
        return authModel;
      } else {
        throw NoSavedUserException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<AuthModel>> getUsersByUserNameOrName(
      String userNameOrName) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(KConstants.kUsersCollection)
        .get();

    try {
      List<AuthModel> users = [];
      for (var doc in snapshot.docs) {
        String documentUserName =
            doc.get(KConstants.kUserName).toString().toLowerCase();

        String documentName =
            doc.get(KConstants.kName).toString().toLowerCase();

        if (documentUserName.contains(userNameOrName.toLowerCase()) ||
            documentName.contains(userNameOrName.toLowerCase())) {
          AuthModel user =
              AuthModel.fromJson(doc.data() as Map<String, dynamic>);
          users.add(user);
          print('The Founded Name is : ${user.name}');
        }
      }
      print('Number of Founded users is : ${users.length}');

      return users;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<String> uploadImageToStorage(
      {required File imageFile, required String storageFolder}) async {
    try {
      // Get the current user's ID
      String userId = getCurrentUserId();
      String imageName = getImageFileName(imageFile);
      // Create a reference to the profile_img file in Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(KConstants.kStorageProfileFolder)
          .child('${userId}_$imageName.jpg');

      // Upload the image file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded image
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> updateUserData({
    required String userName,
    required String name,
    required String bio,
  }) async {
    try {
      String userId = getCurrentUserId();

      // Get the reference to the user's document
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(KConstants.kUsersCollection)
          .doc(userId);

      // Update the document data
      await userDocRef.update({
        KConstants.kUserName: userName,
        KConstants.kName: name,
        KConstants.kBio: bio,
      });

      print('User data updated successfully! from Remote Server');
    } catch (e) {
      print('Error updating user data: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> removeImageFromStorageByUrl({required String imageURL}) async {
    try {
      // Create a reference to the image file in Firebase Storage
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageURL);

      // Delete the image file from Firebase Storage
      await ref.delete();

      print('Profile image removed from Firebase Storage successfully!');
    } catch (e) {
      print('Error removing profile image from Firebase Storage: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> updateProfileImgUrlData({required String imgUrl}) async {
    try {
      String userId = getCurrentUserId();

      // Get the reference to the user's document
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(KConstants.kUsersCollection)
          .doc(userId);

      // Update the document data
      await userDocRef.update({KConstants.kProfileImageUrl: imgUrl});

      print(' Profile Img Url  data updated successfully! from Remote Server');
    } catch (e) {
      print('Error updating user data: $e');
      throw ServerException();
    }
  }
}
