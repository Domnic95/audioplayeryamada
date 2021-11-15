import 'package:get/get.dart';

class WorkDetailController extends GetxController {
  bool _isPlay = false;

  bool get isPlay => _isPlay;

  set isPlay(bool value) {
    _isPlay = value;
    update();
  }

  bool _isPause = false;

  bool get isPause => _isPause;

  set isPause(bool value) {
    _isPause = value;
    update();
  }
}
