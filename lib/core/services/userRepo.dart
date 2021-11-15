import 'package:audiobook/core/utils/appFunctions.dart';
import 'package:audiobook/ui/shared/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../global.dart';
import '../../main.dart';

CollectionReference collectionReferenceUsers =
    FirebaseFirestore.instance.collection('users');

class UserRepo {
  static Future<void> updateBookmark() async {
    try {
      User? user = FirebaseInstance.firebaseAuth!.currentUser;
      collectionReferenceUsers.doc(user!.uid).update({
        'bookmark': userController.userInformation.bookmark,
      });
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<void> addHistory() async {
    try {
      if (FirebaseInstance.firebaseAuth!.currentUser != null) {
        User? user = FirebaseInstance.firebaseAuth!.currentUser;
        collectionReferenceUsers
            .doc(user!.uid)
            .update({'history': userController.userInformation.history});
      }
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<void> addUser() async {
    try {
      User? user = FirebaseInstance.firebaseAuth!.currentUser;
      collectionReferenceUsers
          .doc(user!.uid)
          .set(userController.userInformation.toJson());
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<UserModel> getUserDetail() async {
    try {
      final snap = await collectionReferenceUsers
          .doc(FirebaseInstance.firebaseAuth!.currentUser!.uid)
          .get();

      return UserModel.fromJson(snap.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
      print("FirebaseException $e");
      return UserModel();
    } catch (e) {
      flutterToast(e.toString());
      print("Error $e");
      return UserModel();
    }
  }
}
