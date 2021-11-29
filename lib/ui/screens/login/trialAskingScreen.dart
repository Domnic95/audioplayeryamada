import 'package:audiobook/core/constant/appColors.dart';
import 'package:audiobook/core/constant/appImages.dart';
import 'package:audiobook/core/constant/appSettings.dart';
import 'package:audiobook/core/services/InApp_Purchase.dart';
import 'package:audiobook/core/services/purchaseApi.dart';
import 'package:audiobook/core/utils/appFunctions.dart';
import 'package:audiobook/core/utils/config.dart';
import 'package:audiobook/ui/screens/Tab-1/homeScreen.dart';
import 'package:audiobook/ui/screens/Tab-1/models/musicModel.dart';
import 'package:audiobook/ui/screens/login/Models/SubscriptionPlan.dart';
import 'package:audiobook/ui/screens/login/controller/loginController.dart';
import 'package:audiobook/ui/shared/appButton/customButtonextension.dart';
import 'package:audiobook/ui/shared/appButton/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';

import '../../../main.dart';

class TrialAskingScreen extends StatefulWidget {
  @override
  _TrialAskingScreenState createState() => _TrialAskingScreenState();
}

class _TrialAskingScreenState extends State<TrialAskingScreen> {
  late List<SubscriptionPlan> subscriptionPlan;

  int selectedPlanIndex = 0;

  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscriptionPlan = [
      SubscriptionPlan(
          month: 'month'.tr,
          price: 550,
          subscriptionMonth: 1,
          package: purchaseService.offering.current!.monthly),
      SubscriptionPlan(
          month: 'months'.tr,
          price: 2300,
          subscriptionMonth: 6,
          package: purchaseService.offering.current!.sixMonth),
      SubscriptionPlan(
          month: 'months'.tr,
          price: 4200,
          subscriptionMonth: 12,
          package: purchaseService.offering.current!.annual)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          coverPhoto(size),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSizedBox(h: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: kDefaultPadding),
                  //   child: Text(
                  //     'many_of'.tr,
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, fontSize: getWidth(18)),
                  //   ),
                  // ),
                  // getSizedBox(h: 20),
                  // listOfTopFive(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "select_a_plan".tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        planButton(0),
                        planButton(1),
                        planButton(2),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                        type: CustomButtonType.colourButton,
                        text: 'button1'.tr, // start 7-day
                        width: 225,
                        onTap: () {
                          purchaseService.openPay(
                              subscriptionPlan[selectedPlanIndex].package);
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        Text(
                          'cancellation_is'.tr,
                          style: TextStyle(
                              fontSize: getWidth(10),
                              fontWeight: FontWeight.w600),
                        ),
                        getSizedBox(h: 10),
                        Text(
                          'by_subscribing'.tr,
                          style: TextStyle(
                              fontSize: getWidth(10),
                              fontWeight: FontWeight.w600,
                              color: AppColor.kDefaultGreyText),
                        ),
                        Row(
                          children: [
                            Text(
                              'it_is_considered'.tr,
                              style: TextStyle(
                                  fontSize: getWidth(10),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.kDefaultGreyText),
                            ),
                            Spacer(),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Text(
                            //     'restore_purchase'.tr,
                            //     style: TextStyle(
                            //         fontSize: getWidth(11),
                            //         fontWeight: FontWeight.bold,
                            //         color: AppColor.kBarTextColor),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget planButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(

        ),
        child: Card(
          shadowColor: Colors.black,

          elevation:5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(

            decoration: BoxDecoration(
                // color: Colors.white,
                // boxShadow: [
                //   new BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     blurRadius: 12.0,
                //     offset: Offset(1,1)
                //   ),
                // ],
                border: Border.all(
                    color: selectedPlanIndex == index
                        ? AppColor.kBarButtonColor
                        : Colors.transparent,
                    width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(

                          shape: BoxShape.circle,
                          color: selectedPlanIndex == index
                              ? AppColor.kBarButtonColor
                              : Colors.transparent,
                          border: Border.all(
                              color: AppColor.kBarButtonColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1 ),
                          child: Icon(
                            Icons.done,
                            size: 15,
                            color: selectedPlanIndex == index
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        subscriptionPlan[index].subscriptionMonth.toString() +
                            " " +
                            subscriptionPlan[index].month.toString() +
                            "  (" +
                            subscriptionPlan[index].price.toString() +
                            "yen".tr+")",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        subscriptionPlan[index].price.toString() + "yen".tr+"/" ,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "/month".tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future fetchOffers() async {
  //   final offerings = await PurchaseApi.fetchOffers();
  //   if (offerings.isEmpty) {
  //     showMessage("No Plans Found");
  //   } else {
  //     final offer = offerings.first;
  //     print("offer $offer");
  //     final packages = offerings
  //         .map((offer) => offer.availablePackages)
  //         .expand((pair) => pair)
  //         .toList();
  //     print(packages);
  //     await PurchaseApi.purchasePackage(packages[0]);
  //   }
  // }

  SizedBox listOfTopFive() {
    return SizedBox(
      height: 180,
      child: PaginationView<MusicModel>(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        onError: (error) {
          return Center(child: Text(error));
        },
        pageFetch: loginController.getList,
        itemBuilder: (BuildContext context, MusicModel musicModel, int index) {
          return voiceActorName(musicModel);
        },
        onEmpty: Center(
          child: Text('No Event Found'),
        ),
      ),
    );
  }

  Widget voiceActorName(MusicModel musicModel) {
    return ListBox(
      musicModel: musicModel,
    );
  }

   coverPhoto(Size size) {
    return Container(
      height: getHeight(350),
      width: Get.width,
      color: Colors.red,
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage(AppImages.planImage), fit: BoxFit.cover)),
      child: Stack(
        children: [
          Image.asset('assets/images/planPoster.png',

              height: getHeight(350),
              width: Get.width ,
              fit: BoxFit.cover
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white70,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: size.width*0.8,
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Color(0xff67AC30),
                            Color(0xffC6E717),
                          ],
                          stops: [0.1, 1.0],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                          tileMode: TileMode.repeated
                      ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'many_of'.tr,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getWidth(22),
                          color: Colors.white),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
