import 'package:audiobook/core/services/userRepo.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/shared/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../global.dart';

class UserController extends GetxController {
  late UserModel userInformation = UserModel();
  late bool isNext;
  late bool isNext1;

  UserController() {
    isNext = true;
    isNext1 = true;
  }

  onRegisterUser() {
    userInformation.joinDate = Timestamp.now();
    updateUser();
  }

  onLogout() {
    userInformation = UserModel();
    update();
  }

  updateUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      userInformation.id = user.uid;
      userInformation.email = user.email!;
    }
  }

  getUserDetail() async {
    if (FirebaseInstance.firebaseAuth!.currentUser != null &&
        !FirebaseInstance.firebaseAuth!.currentUser!.isAnonymous) {
      userInformation = await UserRepo.getUserDetail();
    } else
      userInformation = UserModel();
  }

  List<MusicModel> getBookmark() {
    print(
        "get bookmark ${userInformation.bookmark.length}all music ${allMusicList.length}");
    // if (offset == 0) isNext = true;
    List<MusicModel> musics = [];
    for (int i = 0; i < userInformation.bookmark.length; i++) {
      for (int j = 0; j < allMusicList.length; j++) {
        if (userInformation.bookmark[i] == allMusicList[j].id) {
          musics.add(allMusicList[j]);
        }
      }
    }
    print("music list ${musics.length}");

    isNext = false;
    // return Future.delayed(Duration(milliseconds: 10), () {
    //   return musics;
    // });
    return musics;
  }

  List<MusicModel> historyMusics = [];

  Future<List<MusicModel>> getHistory(int offset) async {
    if (offset == 0) isNext1 = true;
    if (isNext1 == false) return [];
    historyMusics = [];
    for (int i = 0; i < userInformation.history.length; i++) {
      for (int j = 0; j < allMusicList.length; j++) {
        if (userInformation.history[i] == allMusicList[j].id) {
          historyMusics.add(allMusicList[j]);
        }
      }
    }

    isNext1 = false;
    return historyMusics.reversed.toList();
    // return Future.delayed(Duration(milliseconds: 10), () {
    //
    // });
  }

  addHistory({required String id}) {
    print('history is null = ${id}');
    if (userInformation.history.contains(id)) {
      userInformation.history.remove(id);
    }
    userInformation.history.add(id);
    UserRepo.addHistory();
    update();
  }

  addBookMark({required String id}) {
    if (!(userInformation.bookmark.contains(id))) {
      userInformation.bookmark.add(id);
      UserRepo.updateBookmark();
      update();
    }
  }

  unBookMark({required String id}) {
    if (userInformation.bookmark.contains(id)) {
      userInformation.bookmark.remove(id);
      UserRepo.updateBookmark();
      update();
    }
  }

  bool currentUser() {
    var v = FirebaseInstance.firebaseAuth!.currentUser == null ||
        FirebaseInstance.firebaseAuth!.currentUser!.isAnonymous;
    update();
    return v;
  }

  List<MusicModel> recommended() {
    // if (offset == 0) isNext2 = true;
    // if (isNext2 == false) return [];
    getHistory(0);
    List<MusicModel> music = [];

    for (int i = 0; i < userInformation.history.length; i++) {
      for (int j = 0; j < allMusicList.length; j++) {
        // if (historyMusics[i].genre == allMusicList[j].genre) {
        //   if (music.length == 7) break;
        //   music.add(allMusicList[j]);
        // }
      }
    }
    // isNext2 = false;
    // print(music);
    return music;
  }
}
