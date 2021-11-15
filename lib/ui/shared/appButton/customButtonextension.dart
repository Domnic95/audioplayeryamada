import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:flutter/material.dart';

enum CustomButtonType {
  colourButton,
  borderButton,
}

extension CustomButtonExtension on CustomButtonType {
  ButtonProps get props {
    switch (this) {
      case CustomButtonType.colourButton:
        return ButtonProps(
          height: 43,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: getWidth(13),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: AppColor.kBarButtonColor,
        );

      case CustomButtonType.borderButton:
        return ButtonProps(
          height: 43,
          border: Border.all(color: Color(0xff134E84), width: 2),
          textStyle: TextStyle(
            color: AppColor.kBarTextColor,
            fontSize: getWidth(12),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.white,
        );
    }
  }
}
