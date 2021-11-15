import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late bool isNext;
  LoginController() {
    isNext = true;
  }
  Future<List<MusicModel>> getList(int offset) async {
    if (isNext == false) return [];
    List<MusicModel> list = [];
    final snap =
        await AudioBookRepo.getMusicList(field: "date", descending: true);

    list.addAll(snap.docs.map((e) {
      return MusicModel.fromFirestore(e);
    }));

    isNext = false;
    return list;
  }
}
