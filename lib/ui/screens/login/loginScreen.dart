import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appImages.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/services/authRepo.dart';
import 'package:audiobook/core/utils/appFunctions.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/main.dart';
import 'package:audiobook/ui/screens/login/registerScreen.dart';
import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:audiobook/ui/shared/appTextField/customTextField.dart';
import 'package:audiobook/ui/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
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
                  text: 'login'.tr,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      disposeKeyboard();
                      _formKey.currentState!.save();
                      LoadingOverlay.of().show();
                      AuthRepo.signWithEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text.trim(),
                        isVerified: () {
                          userController.getUserDetail();
                          LoadingOverlay.of().hide();
                          Get.back();
                        },
                        isNotVerified: () {
                          LoadingOverlay.of().hide();
                          AuthRepo.signOut();
                          email.clear();
                          password.clear();
                          flutterToast('Please verify email first');
                        },
                        onError: () {
                          LoadingOverlay.of().hide();
                        },
                      );
                    } else {
                      flutterToast('something_went_wrong'.tr);
                    }
                  },
                ),
              ),
              getSizedBox(h: 25),
              textButton(
                  title: 'to_registration_screen'.tr,
                  onTap: () {
                    disposeKeyboard();
                    email.clear();
                    password.clear();
                    Get.to(() => RegisterScreen(),
                        transition: Transition.rightToLeftWithFade);
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

Widget buildText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: getWidth(10),
          color: AppColor.kDefaultGreyText),
    ),
  );
}

SafeArea buildImagePart() {
  return SafeArea(
    bottom: false,
    child: Container(
        height: getHeight(300),
        width: Get.width,
        decoration: BoxDecoration(
            // color: Colors.red,
            image: DecorationImage(
                image: AssetImage(AppImages.loginImage), fit: BoxFit.cover)),
        // padding: EdgeInsets.symmetric(horizontal: 60)
        //     .copyWith(bottom: getWidth(kDefaultPadding * 5.5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'welcome'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff405060),
                  fontWeight: FontWeight.w800,
                  fontSize: getWidth(23),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Image.asset(
                  AppImages.appLogo,
                  // height: getHeight(100),
                  // width: getWidth(150),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'logInAnd'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff405060),
                  fontWeight: FontWeight.w800,
                  fontSize: getWidth(23),
                ),
              )
            ],
          ),
        )),
  );
}

Widget textButton({Function()? onTap, required String title}) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        color: Colors.transparent,
        //padding: EdgeInsets.all(6),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: getWidth(13)),
        ),
      ),
    ),
  );
}
