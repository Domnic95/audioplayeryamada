import 'package:audiobook/core/services/userRepo.dart';
import 'package:audiobook/core/utils/appFunctions.dart';
import 'package:audiobook/global.dart';
import 'package:audiobook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepo {
  static Future<void> createEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseInstance.firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous && user.emailVerified == false) {
        userController.onRegisterUser();
        UserRepo.addUser();
        await user.sendEmailVerification();
        signOut();
        flutterToast('verification_link'.tr);
      }
    } on FirebaseAuthException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<void> signWithEmailAndPassword({
    required String email,
    required String password,
    required Function isVerified,
    required Function isNotVerified,
    required Function onError,
  }) async {
    try {
      await FirebaseInstance.firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);
      print(FirebaseInstance.firebaseAuth!.currentUser!.email);
      if (FirebaseInstance.firebaseAuth!.currentUser!.emailVerified) {
        isVerified();
      } else {
        isNotVerified();
        FirebaseInstance.firebaseAuth!.signOut();
      }
    } on FirebaseAuthException catch (e) {
      onError();
      flutterToast(e.message.toString());
    } catch (e) {
      onError();

      flutterToast(e.toString());
    }
  }

  static signOut() async {
    try {
      await FirebaseInstance.firebaseAuth!.signOut();
    } on FirebaseAuthException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }
}
