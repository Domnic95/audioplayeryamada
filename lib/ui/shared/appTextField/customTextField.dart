import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obSecureText;
  final String? Function(String?)? validator;
  final Function()? onTap, onFieldTap;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final double textSize;
  final Color? hintColor;
  final FocusNode? focusNode;
  final double? suffixWidth;
  final InputBorder? inputBorder;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool? enabled;
  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obSecureText = false,
    this.onTap,
    this.validator,
    this.suffix,
    this.autoValidateMode,
    this.keyboardType,
    this.textCapitalization,
    this.textSize = 13.0,
    this.prefix,
    this.hintColor,
    this.focusNode,
    this.suffixWidth,
    this.inputBorder,
    this.textInputAction,
    this.maxLength,
    this.enabled,
    this.onFieldTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: getWidth(textSize)),
      textCapitalization: textCapitalization == null
          ? TextCapitalization.none
          : textCapitalization as TextCapitalization,
      validator: validator,
      inputFormatters: inputFormatters,
      controller: controller,
      maxLength: maxLength,
      autovalidateMode: autoValidateMode,
      enabled: enabled,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obSecureText,
      onTap: onFieldTap,
      keyboardType: keyboardType,
      buildCounter: (BuildContext context,
              {required int currentLength,
              required bool isFocused,
              required int? maxLength}) =>
          null,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff979797), width: 1)),
          hintStyle: TextStyle(
            fontSize: getWidth(textSize),
            color: hintColor == null ? Color(0xffD8D8D8) : hintColor,
          ),
          suffixIcon: suffix,
          prefixIcon: prefix,
          hintText: hintText,
          suffixIconConstraints: BoxConstraints(
              maxHeight: 19,
              maxWidth: suffixWidth == null ? 40 : suffixWidth!.toDouble())),
    );
  }
}

enum TextFieldType { email, password }

Widget buildTextField(
    {required TextEditingController textEditingController,
    required String fieldTitle,
    required TextFieldType textFieldType}) {
  bool condition = TextFieldType.email == textFieldType;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getWidth(13),
            color: Color(0xff616161),
          ),
        ),
        condition
            ? CustomTextField(
                controller: textEditingController,
                textInputAction: TextInputAction.next,
                autoValidateMode: AutovalidateMode.disabled,
                validator: (val) => val!.isEmpty
                    ? 'enter_email'.tr
                    : val.isValidEmail()
                        ? null
                        : 'invalid_email'.tr,
                keyboardType: TextInputType.emailAddress,
                obSecureText: false,
                hintText: 'email@example.com',
              )
            : CustomTextField(
                controller: textEditingController,
                textInputAction: TextInputAction.done,
                autoValidateMode: AutovalidateMode.disabled,
                validator: (val) => val!.isEmpty
                    ? 'enter_password'.tr
                    : val.length >= 8
                        ? null
                        : 'invalid_password'.tr,
                keyboardType: TextInputType.visiblePassword,
                obSecureText: true,
                hintText: '********',
              ),
      ],
    ),
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }
}
