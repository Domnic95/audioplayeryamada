import 'package:get/get.dart';

class BaseScreenController extends GetxController {
  int _currentTab = 0;

  int get currentTab => _currentTab;

  set currentTab(int value) {
    _currentTab = value;
    update();
  }
}
