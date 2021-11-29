import 'package:audiobook/core/services/purchaseApi.dart';
import 'package:audiobook/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService extends GetxController {
  static const _apiKey = "yQpZWEzGkPrLvzXprXCNylAYrAjjKbKt";
  late Offerings offering;
  Future initialize() async {
   try{
     await Purchases.setDebugLogsEnabled(true);
     await Purchases.setup(_apiKey);

   }catch(e){
     print('problem in config = ${e}');}
  }

  Future fetchData() async {
    try {
      offering = await Purchases.getOfferings();

      print('playFetchData successful');
      print(offering.current!.monthly!.product.toString());
    } catch (e) {
      print('playFetchData error fetching package ${e}');
    }
  }

  Future openPay(Package? package) async {
    try {

      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package!);

      Purchases.addPurchaserInfoUpdateListener((purchaserInfo)async {
        await    userController.subscribe();
        print('Database Updated');
      });
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
      }
    }
  }
}
