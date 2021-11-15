import 'dart:async';

import 'package:audiobook/core/constant/appColors.dart';

import 'package:audiobook/core/services/audioBookRepo.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/global.dart';
import 'package:audiobook/main.dart';
import 'package:audiobook/ui/shared/appBar.dart';
import 'package:audiobook/ui/shared/controllers/baseScreenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Tab-1/homeScreen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final BaseScreenController baseScreenController =
      Get.find<BaseScreenController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  appBar(),
      body: Column(
        //  alignment: Alignment.bottomCenter,
        children: [
          Flexible(
            child: GetBuilder(
              builder: (BaseScreenController controller) => IndexedStack(
                children: navigationTabList,
                index: controller.currentTab,
              ),
            ),
          ),
          GetBuilder(builder: (BaseScreenController controller) {
            print("GET UPDATE $currentMusicModel");
            return currentMusicModel == null
                    ? Container()
                    : GestureDetector(
                        onVerticalDragEnd: (v) {
                          currentMusicModel = null;
                          audioHandler.stop();
                          setState(() {});
                        },
                        child: PlayControlBox())

                // Positioned(
                //         bottom: 0,
                //         height: 63,
                //         width: Get.width,
                //         child: PlayControlBox(),
                //       )
                ;
          })
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }
}

Widget buildBottomBar() {
  return GetBuilder(
    builder: (BaseScreenController controller) => Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54.withOpacity(0.18),
              blurRadius: controller.currentTab == 0 ? 1.5 : 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 1,
          onTap: (val) {
            userController.update();
            controller.currentTab = val;
          },
          currentIndex: controller.currentTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: AppColor.kBarUnSelectedTextColor,
          selectedItemColor: AppColor.kBarButtonColor,
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w600, fontSize: getWidth(11)),
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w600, fontSize: getWidth(11)),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search'.tr,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: 'bookmark'.tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'my_page'.tr),
          ],
        ),
      ),
    ),
  );
}
