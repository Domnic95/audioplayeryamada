import 'package:audiobook/core/services/authRepo.dart';
import 'package:audiobook/core/utils/appFunctions.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:audiobook/ui/shared/appTextField/customTextField.dart';
import 'package:audiobook/ui/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loginScreen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disposeKeyboard();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImagePart(),
              getSizedBox(h: 30),
              signUpForm(),
              getSizedBox(h: 60),
              Center(
                child: CustomButton(
                  type: CustomButtonType.colourButton,
                  text: 'to_register'.tr,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      disposeKeyboard();
                      _formKey.currentState!.save();
                      LoadingOverlay.of().show();
                      AuthRepo.createEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      ).whenComplete(() {
                        LoadingOverlay.of().hide();

                        Get.back();
                      });
                    } else {
                      flutterToast('something_went_wrong'.tr);
                    }
                  },
                ),
              ),
              getSizedBox(h: 25),
              textButton(
                  title: 'to_login_screen'.tr,
                  onTap: () {
                    Get.to(() => LoginScreen(), transition: Transition.rightToLeftWithFade);
                  }),
              getSizedBox(h: 25),
              buildText('tc1'.tr),
              buildText('tc2'.tr),
              getSizedBox(h: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTextField(
              textEditingController: email,
              fieldTitle: 'email_address'.tr,
              textFieldType: TextFieldType.email),
          getSizedBox(h: 25),
          buildTextField(
              textEditingController: password,
              fieldTitle: 'password'.tr,
              textFieldType: TextFieldType.password),
        ],
      ),
    );
  }
}
