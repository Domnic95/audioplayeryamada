

import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appIcons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'controllers/baseScreenController.dart';


AppBar appBar({String? title}) {
  String getAppBarTitle(int i) {
    if (i == 0)
      return 'App icon';
    else if (i == 1)
      return 'search'.tr;
    else if (i == 2)
      return 'bookmark'.tr;
    else if (i == 3) return 'my_page'.tr;
    return "";
  }

  return AppBar(
    automaticallyImplyLeading: false,
    leading: title == null
        ? SizedBox()
        : IconButton(
      onPressed: () {
        Get.back();
      },
      splashRadius: 25,
      icon: SvgPicture.asset(AppIcons.backArrow),
    ),
    title: GetBuilder(
      builder: (BaseScreenController controller) {
        return controller.currentTab==0?Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(),
              Row(
                children: [
                  Image.asset('assets/images/applogo.png',
                    width: 40,height: 40,
                  ),
                  SizedBox(width: 10,),
                  Text('e-situAtion',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColor.kBarTextColor
                  ),),
                ],
              ),
              Container(),
              Container(),
              Container(),
            ],
          ),
        ): Text(
          // title == null ? appbarTitleList[controller.currentTab] : title,
          getAppBarTitle(controller.currentTab),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColor.kBarTextColor),
        );
      },
    ),
  );
}

AppBar appbarWithText(String name) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: name == null
        ? SizedBox()
        : IconButton(
            onPressed: () {
              Get.back();
            },
            splashRadius: 25,
            icon: SvgPicture.asset(AppIcons.backArrow),
          ),
    title: GetBuilder(
      builder: (BaseScreenController controller) {
        return Text(
          // title == null ? appbarTitleList[controller.currentTab] : title,
          name,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColor.kBarTextColor),
        );
      },
    ),
  );
}
