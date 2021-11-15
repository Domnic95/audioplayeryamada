import 'package:audiobook/core/services/purchaseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
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
      print('selected plan ${package!.product.price}');
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo
          .entitlements.all["my_entitlement_identifier"]!.isActive) {
        AlertDialog(
          title: Text('successful'),
        );
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
      }
    }
  }
}
