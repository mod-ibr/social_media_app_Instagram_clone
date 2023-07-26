import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Core/Errors/exception.dart';
import 'package:instagram/Features/Instagram/Model/post_model.dart';
import 'package:path/path.dart' as path;
import '../../Features/Auth/Model/auth_model.dart';
import '../../Features/Instagram/Model/comment_model.dart';
import '../../Features/Instagram/Model/like_model.dart';
import '../../Features/Instagram/Model/notification_model.dart';
import '../Utils/Constants/k_constants.dart';
import 'package:http/http.dart' as http;

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
  Future<void> addPost({required File imageFile, required String description});
  Future<void> deletePost({required PostModel post});
  Future<void> updatePost(
      {required PostModel post, File? imageFile, String? description});
  Future<List<PostModel>> getUserPosts({required String userId});
  Future<List<PostModel>> getPostsOrderedByTimeStamp();
  Future<void> likePost({required String postId});
  Future<void> addComment({required String postId, required String content});
  Future<PostModel> getPostById({required String postId});
  Future<void> sendNotification({
    required String receiverId,
    required String type,
    required String title,
    required String body,
  });
  Future<void> saveNotification(
      String userId, NotificationModel notificationModel);
  Future<List<NotificationModel>> getUserNotifications();
}

class InstaRemoteServicesFireBase implements InstaRemoteServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
        }
      }

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
          .child(storageFolder)
          .child('${userId}_$imageName.jpg');

      // Upload the image file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded image
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
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

      print('Image removed from Firebase Storage successfully!');
    } catch (e) {
      print('Error removing image from Firebase Storage: $e');
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

  @override
  Future<void> addPost(
      {required File imageFile, required String description}) async {
    try {
      // Get the current user Id.
      String userId = getCurrentUserId();

      // Get user data by Id to save its name with the post model data.
      AuthModel authModel = await getuserDataById(uid: userId);

      // Upload the Image to Storage and get its URL.
      String imgUrl = await uploadImageToStorage(
        imageFile: imageFile,
        storageFolder: KConstants.kStoragePostFolder,
      );

      // Generate Random Post Id, then prepare the Post Model.
      String postId =
          "${Random().nextInt(10000)}-${DateTime.now().millisecondsSinceEpoch}";

      PostModel post = PostModel(
        postId: postId,
        userId: userId,
        name: authModel.name!,
        profileImageURL: authModel.profileImgUrl!,
        imageURL: imgUrl,
        caption: description,
        timestamp: DateTime.now(),
        likedPostIds: [], // Initialize likedPostIds as an empty list
        commentedPostIds: [], // Initialize commentedPostIds as an empty list
      );

      // Upload the Post Model to Firestore.
      DocumentReference postDocRef = FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(postId);
      await postDocRef.set(post.toJson());

      // update user data to increae number of posts
      AuthModel userData = await getuserDataById(uid: userId);
      int newNPosts = userData.nPosts! + 1;
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(KConstants.kUsersCollection)
          .doc(userId);
      await userDocRef.update({KConstants.kNPosts: newNPosts});
      // Create the nested collections for likes and comments
      await postDocRef.collection(KConstants.kLikesCollection).add({});
      await postDocRef.collection(KConstants.kCommentsCollection).add({});

      print('Successfully Added the Post');
    } catch (e) {
      print('Error When Adding the Post: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> deletePost({required PostModel post}) async {
    try {
      //*Delete the image from storage
      await removeImageFromStorageByUrl(imageURL: post.imageURL);

      //*Delete the post document fro Firestore
      // Making a reference to the Post document
      DocumentReference postDocumentRef = FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(post.postId);

      // Deleting the document
      postDocumentRef.delete();

      print(' Successfully Deleted the Post ');
    } catch (e) {
      print('Error When Adding the Post: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> updatePost(
      {required PostModel post, File? imageFile, String? description}) async {
    try {
      Map<String, dynamic> finalPost = {};

      //*Upload the new Image to Storage, get its URL,and Remove the old Image . If new image not Null
      late String newImgUrl;
      if (imageFile != null) {
        newImgUrl = await uploadImageToStorage(
            imageFile: imageFile, storageFolder: KConstants.kStoragePostFolder);
        finalPost[KConstants.kImageURL] = newImgUrl;
        //* Remove the old img
        await removeImageFromStorageByUrl(imageURL: post.imageURL);
      }
      //* check if the dscription empty or not
      if (description != null) {
        finalPost[KConstants.kcaption] = description;
      }

      //*Uplaod the Post Model to firestore
      // Get the reference to the post's document
      DocumentReference postDocRef = FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(post.postId);
      // Update the document data
      if (finalPost.isNotEmpty) {
        await postDocRef.update({});
      }

      print('Post updated Successfully !');
    } catch (e) {
      print('Error When Updateing the Post: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getUserPosts({required String userId}) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(KConstants.kpostsCollection)
          .where(KConstants.kUserId, isEqualTo: userId)
          .get();

      List<PostModel> userPosts = querySnapshot.docs.map((doc) {
        PostModel postModel =
            PostModel.fromJson(doc.data() as Map<String, dynamic>);
        if (postModel.likedPostIds.contains(userId)) {
          postModel.isiked = true;
        } else {
          postModel.isiked = false;
        }
        postModel.nLikes = postModel.likedPostIds.length;
        postModel.nComments = postModel.commentedPostIds.length;
        return postModel;
      }).toList();
      if (userPosts.isEmpty) {
        return [];
      }
      return userPosts;
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving user posts: $e');
      throw RetrievingPostsException();
    }
  }

  @override
  Future<List<PostModel>> getPostsOrderedByTimeStamp() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(KConstants.kpostsCollection)
          .orderBy(KConstants.kTimestamp, descending: true)
          .get();
      print('**********************');
      List<PostModel> posts = querySnapshot.docs.map((doc) {
        String currentUserId = getCurrentUserId();
        PostModel postModel =
            PostModel.fromJson(doc.data() as Map<String, dynamic>);
        if (postModel.likedPostIds.contains(currentUserId)) {
          postModel.isiked = true;
        } else {
          postModel.isiked = false;
        }
        postModel.nLikes = postModel.likedPostIds.length;
        postModel.nComments = postModel.commentedPostIds.length;
        return postModel;
      }).toList();
      print(posts);
      print('Posts lenght :${posts.length} ');
      if (posts.isEmpty) {
        return [];
      }
      return posts;
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving posts: $e');
      throw RetrievingPostsException();
    }
  }

  @override
  Future<PostModel> getPostById({required String postId}) async {
    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        PostModel postModel =
            PostModel.fromJson(postSnapshot.data() as Map<String, dynamic>);
        postModel.nLikes = postModel.likedPostIds.length;
        postModel.nComments = postModel.commentedPostIds.length;
        return postModel;
      } else {
        throw PostNotFoundException();
      }
    } catch (e) {
      print('Error when getting the post: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> likePost({required String postId}) async {
    try {
      // Get the current user Id.
      String userId = getCurrentUserId();
      AuthModel userData = await getuserDataById(uid: userId);
      // Get the post document reference.
      DocumentReference postDocRef = FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(postId);

      // Check if the user has already liked the post.
      DocumentSnapshot postSnapshot = await postDocRef.get();
      PostModel post =
          PostModel.fromJson(postSnapshot.data() as Map<String, dynamic>);
      // List<String> likedPostIds = post.likedPostIds ?? [];
      List<String> likedPostIds = List<String>.from(post.likedPostIds);

      if (likedPostIds.contains(userId)) {
        // User already liked the post, so we need to unlike it.
        likedPostIds.remove(userId);

        // Delete the like document from the nested like collection.
        await postDocRef
            .collection(KConstants.kLikesCollection)
            .doc(userId)
            .delete();
      } else {
        // User hasn't liked the post yet, so we need to like it.
        likedPostIds.add(userId);
        AuthModel likerUser = await getuserDataById(uid: userId);

        // Create the like document in the nested like collection.
        LikeModel like = LikeModel(
          userId: userId,
          postId: postId,
          profileimageUrl: likerUser.profileImgUrl ?? " ",
          userName: likerUser.userName!,
          likeId: postId, // Use the same ID as the post ID for simplicity
          timestamp: DateTime.now(),
        );
        await postDocRef
            .collection(KConstants.kLikesCollection)
            .doc(userId)
            .set(like.toJson());
        if (userId != post.userId) {
          // Notify the post owner
          AuthModel postOwner = await getuserDataById(uid: post.userId);
          sendNotification(
            type: KConstants.kFCMLikeType,
            receiverId: postOwner.userId!,
            title: 'Instagram',
            body: 'New like for your post.',
          );
          NotificationModel notificationModel = NotificationModel(
              postId: postId,
              postImageUrl: post.imageURL,
              likerId: userId,
              likerName: userData.name!,
              timeStamp: DateTime.now());
          saveNotification(userId, notificationModel);
        }
      }

      // Update the post document with the new likedPostIds list.
      await postDocRef.update({
        KConstants.kLikedPostIds: likedPostIds,
      });

      print('Successfully liked/unliked the post');
    } catch (e) {
      print('Error when liking/unliking the post: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> sendNotification({
    required String receiverId,
    required String type,
    required String title,
    required String body,
  }) async {
    try {
      // Get the FCM token for the receiver
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection(KConstants.kUsersCollection)
              .doc(receiverId)
              .get();
      if (userSnapshot.exists) {
        String fcmToken = userSnapshot.data()![KConstants.kFCMToken];

        // Configure the FirebaseMessaging instance
        // FirebaseMessaging messaging = FirebaseMessaging.instance;

        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=${KConstants.kFCMServerToken}', //  Server key is equql to server Token, server Key -> project settings -> Cloud messaging
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': body.toString(),
                'title': title.toString()
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'type': type.toString(),
                'receiverId': receiverId
              },
              'to': fcmToken
            },
          ),
        );

        print('Notification sent successfully');
      }
    } catch (e) {
      print('Error sending notification: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> addComment(
      {required String postId, required String content}) async {
    try {
      // Get the current user Id.
      String userId = getCurrentUserId();

      // Get the post document reference.
      DocumentReference postDocRef = FirebaseFirestore.instance
          .collection(KConstants.kpostsCollection)
          .doc(postId);

      // Create the comment document in the nested comment collection.
      CommentModel comment = CommentModel(
        commentId: userId + DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        content: content,
        timestamp: DateTime.now(),
      );
      await postDocRef
          .collection(KConstants.kCommentsCollection)
          .doc(comment.commentId)
          .set(comment.toJson());

      // Increment the number of comments in the post document.
      postDocRef.update({
        KConstants.kNComments: FieldValue.increment(1),
      });

      print('Successfully added the comment');
    } catch (e) {
      print('Error when adding the comment: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> saveNotification(
      String userId, NotificationModel notificationModel) async {
    try {
      // Create a new document in the 'Notifications' sub-collection of the user's document
      DocumentReference notificationDocRef = firestore
          .collection(KConstants.kUsersCollection)
          .doc(userId)
          .collection(KConstants.kNotificationsCollection)
          .doc();

      // Set the notification data in the new document
      await notificationDocRef.set(notificationModel.toJson());

      print('Notification added successfully');
    } catch (e) {
      print('Error adding notification: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<NotificationModel>> getUserNotifications() async {
    try {
      // Get the current user Id.
      String userId = getCurrentUserId();
      // Get the 'Notifications' sub-collection of the user's document
      QuerySnapshot querySnapshot = await firestore
          .collection(KConstants.kUsersCollection)
          .doc(userId)
          .collection(KConstants.kNotificationsCollection)
          .orderBy(KConstants.kTimestamp,
              descending:
                  true) // Order by timestamp in descending order (most recent to oldest)
          .get();

      // Convert the query snapshot to a list of NotificationModel
      List<NotificationModel> notifications = querySnapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      
      return notifications;
    } catch (e) {
      print('Error getting notifications: $e');
      throw ServerException();
    }
  }
}
