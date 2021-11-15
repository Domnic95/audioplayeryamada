// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/object_wrappers.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// class PurchaseApi{
//
//   static const _apiKey = "rbnwtODclGtFuHkBPEBxjcyjsJyeZkWF";
//
//   static Future init() async{
//     try{
//       await Purchases.setDebugLogsEnabled(true);
//       await Purchases.setup(_apiKey);
//     }
//     catch(e){
//       print('Congfrigation error = ${e.toString()}');
//     }
//   }
//
//   static Future<List<Offering>> fetchOffers() async{
//     try {
//       final offerings = await Purchases.getOfferings();
//       final current = offerings.current;
//       return current == null ? [] : [current];
//     }
//   on PlatformException catch (e){
//
//       return [];
//     }
//   }
//
//   static Future<bool> purchasePackage(Package package) async {
//     try {
//       await Purchases.purchasePackage(package);
//       return true;
//     }catch (e) {
//       return false;
//     }
//
//   }
// }