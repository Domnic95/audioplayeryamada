import 'package:audiobook/global.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class BookmarkController extends GetxController {
  late bool isDataNext;
  BookmarkController() {
    isDataNext = true;
  }
  List<MusicModel> bookmark = [];
  Future<List<MusicModel>> getMusicList(int offset) async {
    if (isDataNext == false) return [];
    for (int i = 0; i < userController.userInformation.bookmark.length; i++) {
      for (int j = 0; j < allMusicList.length; j++) {
        if (userController.userInformation.bookmark[i] == allMusicList[j].id) {
          bookmark.add(allMusicList[j]);
        }
      }
    }
    isDataNext = false;
    return bookmark;
  }
}
