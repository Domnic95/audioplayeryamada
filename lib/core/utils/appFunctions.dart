import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void disposeKeyboard() {
  return FocusManager.instance.primaryFocus?.unfocus();
}

showMessage(String msg) {
  Get.showSnackbar(GetBar(
    message: msg,
    duration: Duration(seconds: 2),
  ));
}

flutterToast(String msg) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.70),
      fontSize: 14);
}
