import 'package:audiobook/core/constant/appImages.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/core/utils/localizationService.dart';
import 'package:audiobook/global.dart';
import 'package:audiobook/main.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/Tab-2/widgets/workDetails.dart';
import 'package:audiobook/ui/screens/Tab-4/widgets/browsingHistoryScreeen.dart';
import 'package:audiobook/ui/screens/login/loginScreen.dart';
import 'package:audiobook/ui/screens/login/trialAskingScreen.dart';
import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:audiobook/ui/shared/controllers/baseScreenController.dart';
import 'package:audiobook/ui/shared/controllers/userController.dart';
import 'package:audiobook/ui/shared/headerview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final BaseScreenController baseScreenController =
      Get.find<BaseScreenController>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        getSizedBox(h: 30),
        Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: getWidth(102),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.profileImage),
                  fit: BoxFit.cover)),
          child: Row(
            children: [
              Container(
                width: Get.width * 0.4,
                child: Text(
                  'profileCoverText'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getWidth(18),
                      color: Color(0xff209004)),
                ),
              ),
            ],
          ),
        ),
        getSizedBox(h: 25),
        header('recommended_for_you'.tr, iconShow: true),
        getSizedBox(h: 12),
        SizedBox(
          height: 180,
          child: GetBuilder(builder: (UserController controller) {
            List<MusicModel> musicModel = controller.recommended();
            if (musicModel.isEmpty) {
              return Center(child: Text('no_data_found'.tr));
            } else
              return ListView.builder(
                itemCount: musicModel.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ListBox(
                    musicModel: musicModel[index],
                    onTap: () {
                      Get.to(
                          () => WorkDetails(
                                musicModelList: musicModel,
                                musicModel: musicModel[index],
                              ),
                          transition: Transition.rightToLeftWithFade);
                    },
                  );
                },
              );
          }),
        ),
        getSizedBox(h: 30),
        header('menu'.tr, iconShow: true),
        getSizedBox(h: 12),
        listOfMenu(context),
        // getSizedBox(h: 25),
        // getSizedBox(h: 90),
      ],
    );
  }

  Widget listOfMenu(BuildContext context) {
    return GetBuilder(
      builder: (UserController controller) {
        List list = [
          'subscription'.tr,
          'browsing_history'.tr,
          't&c'.tr,
          'inquiry'.tr,
          userController.userInformation.id.isEmpty ? 'login'.tr : 'logout'.tr,
          // LocalizationService.langsIndex == 0
          //     ? "language".tr + LocalizationService.langs[1]
          //     : "language".tr + LocalizationService.langs[0],
        ];
        return Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              list.length,
              (index) => GestureDetector(
                onTap: () {
                  if (index == 5) {
                    LocalizationService.changeLocale(
                        LocalizationService.langsIndex == 0
                            ? LocalizationService.langs[1]
                            : LocalizationService.langs[0]);
                    return;
                  }
                  if (FirebaseInstance.firebaseAuth!.currentUser == null ||
                      FirebaseInstance.firebaseAuth!.currentUser!.isAnonymous) {
                    if (index == 0 || index == 1 || index == 4) {
                      audioPlayerHandlerImpl.stop();
                      Get.to(() => LoginScreen(),
                          transition: Transition.downToUp);
                      baseScreenController.currentTab = 0;
                    }
                  } else {
                    if (index == 0)
                      Get.to(() => TrialAskingScreen(),
                          transition: Transition.downToUp);
                    if (index == 1)
                      Get.to(
                          () => BrowsingHistoryScreen(
                                title: list[index],
                              ),
                          transition: Transition.downToUp);
                    if (index == 4) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Are you sure?'.tr),
                              actions: [
                                CustomButton(
                                  onTap: () {
                                    Get.back();
                                  },
                                  text: 'cancel'.tr,
                                  type: CustomButtonType.borderButton,
                                  radius: 4,
                                  width: getWidth(115),
                                  height: 29,
                                ),
                                CustomButton(
                                  onTap: () {
                                    FirebaseInstance.firebaseAuth!.signOut();
                                    userController.onLogout();
                                    baseScreenController.currentTab = 0;
                                    Get.back();
                                  },
                                  text: 'logout'.tr,
                                  type: CustomButtonType.colourButton,
                                  radius: 4,
                                  width: getWidth(115),
                                  height: 29,
                                ),
                              ],
                            );
                          });
                    }
                  }
                },
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 17),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.08),
                              width: 1))),
                  child: Text(
                    list[index],
                    style: TextStyle(
                        fontSize: getWidth(14),
                        color: Colors.black.withOpacity(0.87)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget voiceActorName(MusicModel musicModel, ActorModel actorModel) {
  //   return ListBox(
  //     onTap: () {
  //       Get.to(() => GetMoreViewAboutSearch(
  //             searchModel: actorModel.musicModel,
  //             text: actorModel.title,
  //           ));
  //     },
  //     musicModel: musicModel, imageFunction: null,
  //   );
  // }
}
